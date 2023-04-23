//
//  ChatManager.swift
//  ConsumerApp
//
//  Created by Nikita on 22.04.2023.
//

import Foundation
class ChatManager {
    static let shared = ChatManager()
    
    var chatList = [Chat]()
    var filteredChatList = [Chat]() // список чатов после фильтрации
    
    private init() {
        chatList = [
            Chat(name: "John Doe", imageName: "onboarding1", messages: [
                Message(text: "Hello", date: Date()),
                Message(text: "How are you?", date: Date().addingTimeInterval(-120)),
                Message(text: "I'm fine, thank you!", date: Date().addingTimeInterval(-60))
            ]),
            Chat(name: "Jane Smith", imageName: "onboarding2", messages: [
                Message(text: "Hey there!", date: Date()),
                Message(text: "What are you up to?", date: Date().addingTimeInterval(-120)),
                Message(text: "Nothing much, just hanging out.", date: Date().addingTimeInterval(-60))
            ]),
            Chat(name: "Bob Johnson", imageName: "onboarding3", messages: [
                Message(text: "Hi", date: Date()),
                Message(text: "How's your day going?", date: Date().addingTimeInterval(-120)),
                Message(text: "It's going pretty well, thanks for asking!", date: Date().addingTimeInterval(-60))
            ])
        ]
    }
    
    func filterChatsByName(_ name: String) {
        filteredChatList = chatList.filter { $0.name.lowercased().contains(name.lowercased()) }
    }
}
