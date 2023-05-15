//
//  Chat.swift
//  ConsumerApp
//
//  Created by Nikita on 22.04.2023.
//

import Foundation
class Chat {
    let name: String
    let imageName: String
    var messages: [Message]
    var lastMessage: Message {
        return messages.last ?? Message(text: "", date: Date(), isRead: true)
    }
    
    init(name: String, imageName: String, messages: [Message]) {
        self.name = name
        self.imageName = imageName
        self.messages = messages
    }
}

struct Message {
    let text: String
    let date: Date
    // пока будет использовать как поле идентифицуюриещее от кого отправлено
    let isRead: Bool
}
