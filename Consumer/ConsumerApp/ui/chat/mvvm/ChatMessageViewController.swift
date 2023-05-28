//
//  ChatViewController.swift
//  ConsumerApp
//
//  Created by Nikita on 22.04.2023.
//

import Foundation
import UIKit
import RxSwift
import ChatGRPC
import ConsumerDomain

import SwiftProtobuf

class ChatMessageViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    private let viewModel = ViewModelFactory.get(ChatMessageViewModel.self)
    
    private let backBtn = NavigationButton.back.button
    private let phoneBtn = NavigationButton.chatPhone.button
    private let chatSettingsBtn = NavigationButton.chatSettingsBlack.button
    let disposeBag: DisposeBag = DisposeBag()
    
    private var profileImageBtn: UIButton = {
        let imgView = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgView.layer.masksToBounds = false
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = imgView.frame.height / 2.0
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .gray
        imgView.layer.borderWidth = 2
        imgView.layer.borderColor = UIColor.white.cgColor
        return imgView
    }()
    
    private var safeAreaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color1.white
        return view
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 16
//        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.backgroundScreen.color
        collectionView.showsHorizontalScrollIndicator = false
       // collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.register(ChatMessageViewCell.self, forCellWithReuseIdentifier: "messageCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    private var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sizeToFit()
        view.backgroundColor = Color1.gray2
        return view
    }()
    
    
    private var messageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.keyboardType = UIKeyboardType.default
        textView.returnKeyType = UIReturnKeyType.done
        textView.textColor = UIColor.lightGray
        textView.text = "Сообщение"
        textView.textAlignment = .left
        textView.layer.cornerRadius = 10
        textView.isScrollEnabled = false
        return textView
    }()
    

    private var chatAddButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let chatAddImage = #imageLiteral(resourceName: "plusGradient")
        btn.setImage(chatAddImage, for: .normal)
        return btn
    }()
    
    private var chatSendButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let chatAddImage = #imageLiteral(resourceName: "chat_send_message")
        btn.setImage(chatAddImage, for: .normal)
        return btn
    }()
    
    
    private var chat: Chat!
    
    private var profileInfo: ProfileInfo!
    
    
    func setup(_ chat: Chat, _ profileInfo: ProfileInfo) {
        self.chat = chat
        self.profileInfo = profileInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        messageTextView.delegate = self
        // subtitle:chat.interlocutorSummary.formattedOnlineStatus
        navigationItem.setTitleView(title: chat.interlocutorSummary.name + " " + chat.interlocutorSummary.surname, subtitle:"" , imageName: chat.interlocutorSummary.imageURL)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 30
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: chatSettingsBtn), space, UIBarButtonItem(customView: phoneBtn)]
        self.view.backgroundColor = Color.backgroundScreen.color
        layout()
        bind()
        viewModel.getResponsesFromServer()
    }
    
    
//    override func viewDidLayoutSubviews() {
//        let section = 0
//        let lastItemIndex = self.collectionView.numberOfItems(inSection: section) - 1
//        let indexPath:NSIndexPath = NSIndexPath.init(item: lastItemIndex, section: section)
//        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: false)
//        }
    
//    override func viewDidAppear(_ animated: Bool) {
//        scrollToLastCell()
//    }
//
//    func scrollToLastCell() {
//        let section = 0
//        let lastItemIndex = self.collectionView.numberOfItems(inSection: section) - 1
////        let indexPath:NSIndexPath = NSIndexPath.init(item: lastItemIndex, section: section)
////        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
//        let bottomOffset = CGPoint(x: 0,
//                                   y: collectionView.frame.height + (collectionView.contentSize.height * CGFloat(lastItemIndex+1)))
//        collectionView.setContentOffset(bottomOffset, animated: false)
//    }
    
    
    func layout() {

        view.addSubview(safeAreaView)
        safeAreaView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        safeAreaView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        safeAreaView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        safeAreaView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
 
        view.addSubview(bottomView)
        bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true


        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true



        
        view.addSubview(chatAddButton)
        chatAddButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor,constant: -6).isActive = true
        chatAddButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        chatAddButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        chatAddButton.widthAnchor.constraint(equalToConstant: 24).isActive = true

        view.addSubview(chatSendButton)
        chatSendButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor,constant: -6).isActive = true
        chatSendButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        chatSendButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        chatSendButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(messageTextView)
        //messageTextView.centerYAnchor.constraint(equalTo: chatAddButton.centerYAnchor).isActive = true
        messageTextView.leftAnchor.constraint(equalTo: self.chatAddButton.rightAnchor, constant: 8).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: self.chatSendButton.leftAnchor, constant: -16).isActive = true
        messageTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 240).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
        
        
        bottomView.topAnchor.constraint(equalTo: messageTextView.topAnchor, constant: -10).isActive = true
    }
        
    
    func bind() {
        backBtn.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        
        viewModel.responseFromServer
            .subscribe(onNext: { response in
                switch response {
                case .receiveMessage(let response):
                    self.chat.messages.insert(response.message, at: 0)
                    self.collectionView.reloadData()
                    print("ПРИШЛО СООБЩЕНИЕ С СЕРВЕРА")
                    print( response.debugDescription)
                    
                case .chatSummary(let response):
                    print( response.debugDescription)
                    
                case .getMessagesResponse(let response):
                    print( response.debugDescription)
                    
                case .getRecentChats(let chatsResponse):
                    print( chatsResponse.debugDescription)
                    
                case .receiveEvent(let response):
                    print( response.debugDescription)
                    
                    
                case .error(let response):
                    print( response.debugDescription)
                    
                }
            }).disposed(by: disposeBag)
        
        chatSendButton.rx.tap.bind(onNext: {
            let inputText = self.messageTextView.text
            guard let inputText = inputText else { return }
            if inputText.isEmpty || self.messageTextView.textColor == UIColor.lightGray {
                return
            }
            
            if self.chat.messages.isEmpty {
                self.viewModel.startChat(interlocutorID: self.chat.interlocutorSummary.id, lotID: UInt64(self.chat.lots.first!.id), firstMessage: inputText)
            } else {
                self.viewModel.sendMessage(request: .with({
                    $0.text = inputText
                    $0.chatID = self.chat.chatID
                }))
            }

            
            
            self.messageTextView.text = nil
            self.messageTextView.endEditing(true)
            let message = Message.with({
                $0.senderID = self.profileInfo.id
                $0.text = inputText
                $0.sentAt = Google_Protobuf_Timestamp(date: Date())
            })
            self.chat.messages.insert(message, at: 0)
            self.collectionView.reloadData()
         }).disposed(by: disposeBag)
        
      
    }
    
    
    // MARK: - Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! ChatMessageViewCell
        let message = chat.messages[chat.messages.count - indexPath.row - 1]
        cell.messageTextView.text = message.text
        let dateLastMessage = message.sentAt.date
//        if Date().hours(from: dateLastMessage) < 23 {
        cell.dateMessageLabel.text = dateLastMessage.toString(withFormat: "HH:mm")
//        } else {
//            cell.dateMessageLabel.text = dateLastMessage.toString(withFormat: "d MMM, HH:mm")
//        }
        
        
        // ожидаемый размер отображения текста
        let size = CGSize(width: 250, height: 1000)
        // используем высоту шрифта для определения высоты текста и текст может содержать несколько строк
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        // оценочный прямоугольник
        var estimatedFrame = NSString(string: message.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        // увеличиваем высоту чтобы учесть расстояние между строками
        estimatedFrame.size.height += 16
        // находим размер имени отправителя также с помощью прямоугольника
        let dateSize = NSString(string: message.sentAt.date.toString(withFormat: "dd-MM")).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)], context: nil)
        // находим максимальное значение чтобы имя отправителя и текст точно поместились без обрезки текста
        let maxValue = max(estimatedFrame.width, dateSize.width)
        estimatedFrame.size.width = maxValue + 10
        
        
        
        
        
        if message.senderID != self.profileInfo.id {
            // Ячейка собеседника
            cell.dateMessageLabel.textAlignment = .right
            cell.profileImageView.frame = CGRect(x: 8, y: estimatedFrame.height - 8, width: 30, height: 30)
            cell.dateMessageLabel.frame = CGRect(x: 44, y: estimatedFrame.height, width: estimatedFrame.width + 16, height: 16)
            cell.checkMessageView.frame = CGRect(x: estimatedFrame.width + 48 + 16, y: estimatedFrame.height, width: 16, height: 16)
            cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16 + 12, height: estimatedFrame.height + 20 + 6)
            cell.bubbleImageView.image = ChatMessageViewCell.grayBubbleImage
            cell.bubbleImageView.tintColor = Color1.white
            cell.messageTextView.textColor = Color1.black
            
            cell.profileImageView.kf.setImage(with: URL(string: chat.interlocutorSummary.imageURL))
        } else {
            // Ячейка текущего пользователя
            cell.dateMessageLabel.textAlignment = .right
            cell.profileImageView.frame = CGRect(x: self.collectionView.bounds.width - 38, y: estimatedFrame.height - 8, width: 30, height: 30)
            
            cell.dateMessageLabel.frame = CGRect(x: collectionView.bounds.width - estimatedFrame.width - 32 - 8 - 30 - 30, y: estimatedFrame.height, width: estimatedFrame.width + 16, height: 16)
            cell.checkMessageView.frame = CGRect(x: collectionView.bounds.width - 48 - 32, y: estimatedFrame.height, width: 16, height: 16)
            
            cell.messageTextView.frame = CGRect(x: collectionView.bounds.width - estimatedFrame.width - 16 - 16 - 8 - 30, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: collectionView.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10 - 30, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
            cell.bubbleImageView.image = ChatMessageViewCell.blueBubbleImage
            cell.bubbleImageView.tintColor = UIColor(red: 1, green: 191/255, blue: 61/255, alpha: 1)
            cell.messageTextView.textColor = Color1.white
            cell.profileImageView.kf.setImage(with: URL(string: profileInfo.imageUrl))
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = chat.messages[chat.messages.count - indexPath.row - 1]
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var estimatedFrame = NSString(string: message.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        estimatedFrame.size.height += 16
        
        return CGSize(width: collectionView.frame.width, height: estimatedFrame.height + 20)
    }
     
    
    
    
}
extension ChatMessageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Сообщение"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.sizeToFit()
        bottomView.sizeToFit()
        let height = textView.frame.size.height
        if height >= 240 {
            print(textView.text.count)
            textView.isScrollEnabled = true
        }
    }
    

}


extension UINavigationItem {
    func setTitleView(title: String, subtitle: String, imageName: String) {
        
        let firstLabel = UILabel()
        firstLabel.text = title
        firstLabel.textColor = Color1.gray5
        firstLabel.font = Font.robotoSemiBold14
        firstLabel.textAlignment = .left

        
        let secondLabel = UILabel()
        secondLabel.text = subtitle
        secondLabel.textColor = Color1.gray5
        secondLabel.font = Font.robotoLight12
        secondLabel.textAlignment = .left

        
        let stackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.spacing = 5
        //stackView.alignment = .center
        firstLabel.layoutIfNeeded()
        secondLabel.layoutIfNeeded()
        let width = max(firstLabel.text!.width(constraintedHeight: 0, font: firstLabel.font), secondLabel.text!.width(constraintedHeight: 0, font: secondLabel.font))
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 40)
        

        
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.layer.cornerRadius = image.frame.height / 2.0
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .gray
        image.kf.setImage(with: URL(string: imageName))
        image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        image.layoutIfNeeded()
        
        
        let stackViewHorizontal: UIStackView = UIStackView(arrangedSubviews: [image, stackView])
        stackViewHorizontal.translatesAutoresizingMaskIntoConstraints = false
        stackViewHorizontal.isUserInteractionEnabled = false
        stackViewHorizontal.alignment = .center
        stackViewHorizontal.axis = .horizontal
        stackViewHorizontal.distribution = .fill
        stackViewHorizontal.spacing = 10
        stackViewHorizontal.frame = CGRect(x: 0, y: 0, width: width + image.frame.width, height: 40)

        stackViewHorizontal.isLayoutMarginsRelativeArrangement = true
        stackViewHorizontal.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        
        stackViewHorizontal.layoutIfNeeded()
        stackView.widthAnchor.constraint(equalToConstant: 180).isActive = true

        self.titleView = stackViewHorizontal
    }
}
