//
//  ChatManager.swift
//  ConsumerApp
//
//  Created by Nikita on 22.04.2023.
//
import Foundation
import ChatGRPC

class ChatManager {
    static let shared = ChatManager()
    
    var chatList = [ChatGRPC.Chat]()
    var filteredChatList = [ChatGRPC.Chat]() // список чатов после фильтрации
    
    
    func filterChatsByName(_ name: String) {
        filteredChatList = chatList.filter { $0.interlocutorSummary.name.lowercased().contains(name.lowercased()) }
    }
    
    func setChatList(_ chats: [ChatGRPC.Chat]) {
        chatList = chats
    }
    
}
