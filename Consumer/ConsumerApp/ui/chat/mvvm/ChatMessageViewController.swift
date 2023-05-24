//
//  ChatViewController.swift
//  ConsumerApp
//
//  Created by Nikita on 22.04.2023.
//

import Foundation
import UIKit
import RxSwift

class ChatMessageViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let backBtn = NavigationButton.back.button
    private let phoneBtn = NavigationButton.chatPhone.button
    private let chatSettingsBtn = NavigationButton.chatSettingsBlack.button
    let disposeBag: DisposeBag = DisposeBag()
    
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
    
    private var chatAddButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let chatAddImage = #imageLiteral(resourceName: "plusGradient")
        btn.setImage(chatAddImage, for: .normal)
        return btn
    }()
    
    private var messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.placeholder = "Введите сообщение"
        textField.textAlignment = .left
        textField.layer.cornerRadius = 10
        
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        let chatAddImage = #imageLiteral(resourceName: "chat_send_message")
        btn.setImage(chatAddImage, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        textField.rightView = btn
        textField.rightViewMode = .always
        return textField
    }()
    
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
    
    
    
    private var chat: Chat!
    
    

    func setup(with chat: Chat) {
        self.chat = chat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        //navigationItem.title = chat.name
        
        
        
        navigationItem.setTitleView(title: chat.name, subtitle: "Был последний раз 5 минут назад", imageName: "onboarding1")

        
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 30
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: chatSettingsBtn), space, UIBarButtonItem(customView: phoneBtn)]
        self.view.backgroundColor = Color.backgroundScreen.color
        layout()
        bindViews()
    }
    
    func layout() {

        view.addSubview(safeAreaView)
        safeAreaView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        safeAreaView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        safeAreaView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        safeAreaView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
 
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true



        
        view.addSubview(chatAddButton)
        chatAddButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor,constant: -16 - 12).isActive = true
        chatAddButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        chatAddButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        chatAddButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        view.addSubview(messageTextField)
        messageTextField.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor,constant: -16).isActive = true
        messageTextField.leftAnchor.constraint(equalTo: self.chatAddButton.rightAnchor, constant: 8).isActive = true
        messageTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        messageTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
 
    }
    
    func bindViews() {
        backBtn.rx.tap.bind(onNext: {
           // self.popFromRoot()
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    
    // MARK: - Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChatManager.shared.chatList.first?.messages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! ChatMessageViewCell
        
        // Set up the cell with chat data
        let message: Message
        message = (ChatManager.shared.chatList.first?.messages[indexPath.row])!
        cell.messageTextView.text = message.text
        cell.dateMessageLabel.text = message.date.toString(withFormat: "dd-MM")
        
        // ожидаемый размер отображения текста
        let size = CGSize(width: 250, height: 1000)
        // используем высоту шрифта для определения высоты текста и текст может содержать несколько строк
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        // оценочный прямоугольник
        var estimatedFrame = NSString(string: message.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        // увеличиваем высоту чтобы учесть расстояние между строками
        estimatedFrame.size.height += 16
        // находим размер имени отправителя также с помощью прямоугольника
        let nameSize = NSString(string: message.date.toString(withFormat: "dd-MM")).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], context: nil)
        // находим максимальное значение чтобы имя отправителя и текст точно поместились без обрезки текста
        let maxValue = max(estimatedFrame.width, nameSize.width)
        estimatedFrame.size.width = maxValue
        
        
        if message.isRead {
            
            cell.dateMessageLabel.textAlignment = .right
            cell.profileImageView.frame = CGRect(x: 8, y: estimatedFrame.height - 8, width: 30, height: 30)
            cell.dateMessageLabel.frame = CGRect(x: 44, y: estimatedFrame.height, width: estimatedFrame.width + 16, height: 16)
            cell.checkMessageView.frame = CGRect(x: estimatedFrame.width + 48 + 16, y: estimatedFrame.height, width: 16, height: 16)
            cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16 + 12, height: estimatedFrame.height + 20 + 6)
            cell.bubbleImageView.image = ChatMessageViewCell.grayBubbleImage
            cell.bubbleImageView.tintColor = Color1.white
            cell.messageTextView.textColor = Color1.black
        } else {
            
            cell.dateMessageLabel.textAlignment = .right
            cell.profileImageView.frame = CGRect(x: self.collectionView.bounds.width - 38, y: estimatedFrame.height - 8, width: 30, height: 30)
            
            cell.dateMessageLabel.frame = CGRect(x: collectionView.bounds.width - estimatedFrame.width - 32 - 8 - 30 - 30, y: estimatedFrame.height, width: estimatedFrame.width + 16, height: 16)
            cell.checkMessageView.frame = CGRect(x: collectionView.bounds.width - 48 - 32, y: estimatedFrame.height, width: 16, height: 16)
            
            cell.messageTextView.frame = CGRect(x: collectionView.bounds.width - estimatedFrame.width - 16 - 16 - 8 - 30, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: collectionView.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10 - 30, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
            cell.bubbleImageView.image = ChatMessageViewCell.blueBubbleImage
            cell.bubbleImageView.tintColor = UIColor(red: 1, green: 191/255, blue: 61/255, alpha: 1)
            cell.messageTextView.textColor = Color1.white
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
            
            let message: Message
            message = (ChatManager.shared.chatList.first?.messages[indexPath.item])!
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            var estimatedFrame = NSString(string: message.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
            estimatedFrame.size.height += 16
            
            return CGSize(width: collectionView.frame.width, height: estimatedFrame.height + 20)
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
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor(red: 1, green: 191/255, blue: 61/255, alpha: 1).cgColor
        image.image = UIImage(named: imageName)
        image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        image.layoutIfNeeded()
        
        let stackViewHorizontal: UIStackView = UIStackView(arrangedSubviews: [image, stackView])
        stackViewHorizontal.translatesAutoresizingMaskIntoConstraints = false
        stackViewHorizontal.isUserInteractionEnabled = false
        stackViewHorizontal.alignment = .center
        stackViewHorizontal.axis = .horizontal
        stackViewHorizontal.distribution = .equalCentering
        stackViewHorizontal.spacing = 10
        stackViewHorizontal.frame = CGRect(x: 0, y: 0, width: width + image.frame.width, height: 40)
        
       
        //stackViewHorizontal.isLayoutMarginsRelativeArrangement = true
        //stackViewHorizontal.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        
       // stackViewHorizontal.layoutIfNeeded()
        self.titleView = stackViewHorizontal
    }
}
