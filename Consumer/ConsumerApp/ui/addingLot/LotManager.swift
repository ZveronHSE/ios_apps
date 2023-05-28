//
//  LotManager.swift
//  ConsumerApp
//
//  Created by Nikita on 31.05.2023.
//

import Foundation
import CoreGRPC

class LotManager {
    static let shared = LotManager()
    
    var lots = [Lot]()
    
    
    //var filteredChatList = [ChatGRPC.Chat]() // список чатов после фильтрации
    
    
//    func filterChatsByName(_ name: String) {
//        filteredChatList = chatList.filter { $0.interlocutorSummary.name.lowercased().contains(name.lowercased()) }
//    }
    
    func setLots(_ lots: [Lot]) {
        self.lots = lots
    }
    
}
