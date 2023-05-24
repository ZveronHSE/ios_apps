//
//  ChatViewController.swift
//  iosapp
//
//  Created by alexander on 30.04.2022.
//

import UIKit

class ChatListViewController: UIViewControllerWithAuth, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let settingsBtn = NavigationButton.chatSettings.button
    
    lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        s.searchBar.translatesAutoresizingMaskIntoConstraints = false
        // чтобы взаимодействовать с отображаемым контентом для тапа по записям
        s.obscuresBackgroundDuringPresentation = false

        s.searchBar.searchTextField.backgroundColor = .white
        s.searchBar.barTintColor = .white


        s.searchBar.placeholder = "Поиск по адресату сообщения"
        s.searchBar.sizeToFit()
        s.searchBar.searchBarStyle = .prominent
        s.searchResultsUpdater = self
        return s
    }()
    
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.title = "Сообщения"
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: settingsBtn)]
    
        
        self.view.backgroundColor = Color.backgroundScreen.color
        
        // Set the constraints for the collection view , constant: 16
        view.addSubview(collectionView)
        
        // Set the constraints for the collection view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.alwaysBounceVertical = true
        

        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        let chat: Chat
        if ChatManager.shared.filteredChatList.isEmpty {
            chat = ChatManager.shared.chatList[indexPath.row]
        } else {
            chat = ChatManager.shared.filteredChatList[indexPath.row]
        }
        cell.imageUser.image = UIImage(named: "onboarding2")
        cell.imageLot.image = UIImage(named: "onboarding1")
        cell.userLabel.text = "Никита Ткаченко"
        cell.lotLabel.text = "Корм для собак «Luca» 50 ₽"
        cell.messageLabel.text = "Добрый день, подскажите пожалуйста, сколько будет стоить эта замечательная будка для моего кота"
        cell.dateLabel.text = "10.02"
        cell.countMessagesLabel.text = "1"
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.backgroundColor = Color1.white
        return cell
    }
    
    // MARK: - Collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chat = ChatManager.shared.chatList[indexPath.row]
        let messageVC = ChatMessageViewController()
        messageVC.setup(with: chat)
       // uWindow.rootViewController = UINavigationController(rootViewController: tabVC)
        // pushToRoot(vc: messageVC)
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
                chat.name.lowercased().contains(searchText.lowercased())
            }
            ChatManager.shared.filteredChatList = filteredChats
        } else {
            ChatManager.shared.filteredChatList = []
        }
        collectionView.reloadData()
    }
}
