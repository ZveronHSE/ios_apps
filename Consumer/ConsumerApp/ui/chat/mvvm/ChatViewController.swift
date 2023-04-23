//
//  ChatViewController.swift
//  ConsumerApp
//
//  Created by Nikita on 22.04.2023.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
    
    let chat: Chat
    let messagesTableView = UITableView()
    let messageTextField = UITextField()
    
    init(chat: Chat) {
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the messages table view
        messagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "messageCell")
        view.addSubview(messagesTableView)
        
        // Set up the message text field
        messageTextField.borderStyle = .roundedRect
        messageTextField.placeholder = "Type a message..."
        view.addSubview(messageTextField)
        
        // Set up the constraints
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        messagesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messagesTableView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor, constant: -8).isActive = true
        
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        messageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        messageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        messageTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

// MARK: - Table view data source

//extension ChatViewController: UITableViewDataSource {
//    func numberOf
//}
