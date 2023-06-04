//
//  ChatViewController.swift
//  iosapp
//
//  Created by alexander on 30.04.2022.
//

import UIKit
import ChatGRPC
import ConsumerDomain

class ChatListViewController: UIViewControllerWithAuth, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let viewModel = ViewModelFactory.get(ChatListViewModel.self)
    
    private let settingsBtn = NavigationButton.chatSettings.button
    
//    lazy var searchController: UISearchController = {
//        let s = UISearchController(searchResultsController: nil)
//        s.searchBar.translatesAutoresizingMaskIntoConstraints = false
//        // чтобы взаимодействовать с отображаемым контентом для тапа по записям
//        s.obscuresBackgroundDuringPresentation = false
//
//        s.searchBar.searchTextField.backgroundColor = .white
//        s.searchBar.barTintColor = .white
//
//
//        s.searchBar.placeholder = "Поиск по адресату сообщения"
//        s.searchBar.sizeToFit()
//        s.searchBar.searchBarStyle = .prominent
//        s.searchResultsUpdater = self
//        return s
//    }()
//
    
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.backgroundScreen.color
        collectionView.showsHorizontalScrollIndicator = false
       // collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.register(ChatListViewCell.self, forCellWithReuseIdentifier: "chatCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "Обновление ...")
//        refreshControl.tintColor = .zvGray3
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        return refreshControl
    }()
    
    private var profileInfo: ProfileInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Сообщения"
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: settingsBtn)]
        //navigationItem.searchController = searchController
        definesPresentationContext = true
        collectionView.refreshControl = self.refreshControl
        layout()
        bind()
        viewModel.getResponsesFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadProfileInfo()
        
        

        self.viewModel.isLoadedInfoChats.onNext(false)
        self.viewModel.isLoadedProfileInfo.onNext(false)
        viewModel.getRecentChats()
        
    }
    
    func layout() {
        // Set the constraints for the collection view , constant: 16
        view.addSubview(collectionView)
        
        // Set the constraints for the collection view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func bind() {
        viewModel.responseFromServer
            .subscribe(onNext: { response in
                switch response {
                case .receiveMessage(let response):
                    print( response.debugDescription)
                    
                case .chatSummary(let response):
                    print( response.debugDescription)
                    
                case .getMessagesResponse(let response):
                    print( response.debugDescription)
                    
                case .getRecentChats(let chatsResponse):
                    print( chatsResponse.debugDescription)
                    self.bindGetRecentChats(chatsResponse)
                    self.viewModel.isLoadedInfoChats.onNext(true)
                    self.viewModel.isLoadedInfoChatsRefresh.onNext(true)
                    self.refreshControl.endRefreshing()
                    
                case .receiveEvent(let response):
                    print( response.debugDescription)
                    
                    
                case .error(let response):
                    print( response.debugDescription)
                    
                }
            }).disposed(by: disposeBag)
        
        
        viewModel.isFullLoaded
            .subscribe(onNext: { isLoadedInfo in
            if !isLoadedInfo {
                self.collectionView.isHidden = true
                self.activityIndicator.show()
                self.activityIndicator.startAnimating()
            } else {
                self.collectionView.isHidden = false
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hide()
            }
        }).disposed(by: disposeBag)
        
        
        
        viewModel.profileInfo
            .subscribe(onNext: {
                self.profileInfo = $0
            }).disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                self.viewModel.isLoadedInfoChatsRefresh.onNext(false)
                self.viewModel.getRecentChats()
            })
        
        viewModel.isLoadedInfoChatsRefresh
            .subscribe(onNext: { isLoadedInfoChatsRefresh in
                if isLoadedInfoChatsRefresh {
                    self.refreshControl.endRefreshing()
                }
            }).disposed(by: disposeBag)
    }
    
    func bindGetRecentChats(_ chatsResponse: GetRecentChatsResponse) {
        // TODO: заменить на tapGesture когда пользователь тянет верхнюю часть экрана вниз
        viewModel.isLoadedInfoChats.onNext(false)
        let chats = chatsResponse.chats
        ChatManager.shared.setChatList(chats)
        
        collectionView.reloadData()
    }
                 
    
    
    // MARK: - Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ChatManager.shared.filteredChatList.isEmpty {
            return ChatManager.shared.chatList.count
        } else {
            return ChatManager.shared.filteredChatList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as! ChatListViewCell
        
        // Set up the cell with chat data
        let chat: ChatGRPC.Chat
        if ChatManager.shared.filteredChatList.isEmpty {
            chat = ChatManager.shared.chatList[indexPath.row]
        } else {
            chat = ChatManager.shared.filteredChatList[indexPath.row]
        }
        let profileInfo = chat.interlocutorSummary
        cell.userLabel.text = profileInfo.name + " " + profileInfo.surname
        cell.imageUser.kf.setImage(with: URL(string: profileInfo.imageURL))
        cell.messageLabel.text = chat.messages.first?.text
        
        let dateLastMessage = (chat.messages.first?.sentAt.date)!
        if Date().hours(from: dateLastMessage) < 23 {
            cell.dateLabel.text = dateLastMessage.toString(withFormat: "HH:mm")
        } else {
            cell.dateLabel.text = dateLastMessage.toString(withFormat: "d MMM, HH:mm")
        }
        
//        let countUnreadMessages = chat.unreadMessages
//        if countUnreadMessages > 0 {
//            cell.countMessagesLabel.text = String(countUnreadMessages)
//        } else {
//            cell.viewCountMessages.hide()
//        }
        
        cell.imageLot.kf.setImage(with: URL(string: chat.lots.first!.imageURL))
        cell.lotLabel.text = chat.lots.first!.title + " " + chat.lots.first!.price
        
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.backgroundColor = Color1.white
        return cell
    }
    
    // MARK: - Collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chat = ChatManager.shared.chatList[indexPath.row]
        let messageVC = ChatMessageViewController()
        messageVC.setup(chat, profileInfo)
        messageVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(messageVC, animated: true)
    }
    

    
    // MARK: - Collection view flow layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 80)
    }
}

extension ChatListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let filteredChats = ChatManager.shared.chatList.filter { chat in
                chat.interlocutorSummary.name.lowercased().contains(searchText.lowercased())
            }
            ChatManager.shared.filteredChatList = filteredChats
        } else {
            ChatManager.shared.filteredChatList = []
        }
        collectionView.reloadData()
    }
}
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
