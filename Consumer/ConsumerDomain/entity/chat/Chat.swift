////
////  Chat.swift
////  ConsumerDomain
////
////  Created by Nikita on 26.05.2023.
////
//
//import Foundation
//import CoreGRPC
//
//public struct Chat {
//
//    public let chatId: String
//    public let interlocutorSummary: ProfileSummary
//    // 100 последних сообщений
//    public let messages: [Message]
//    public let unreadMessages: UInt32
//    public let lastUpdate: Date
//    // Id услуги, связанной с чатом
//    public let serviceId: UInt64?
//    public let reviewId: UInt64?
//    // Все объявления, связанные с чатом
//    public let lots: [Lot]
//    public let folder: ChatFolder
//    // Заблокирован ли получатель (тот, кто просматривает информацию о чате)
//    public let isBlocked: Bool
//
//    public init(chatId: String, interlocutorSummary: ProfileSummary, messages: [Message], unreadMessages: UInt32, lastUpdate: Date, serviceId: UInt64? = nil, reviewId: UInt64? = nil, lots: [Lot], folder: ChatFolder, isBlocked: Bool) {
//        self.chatId = chatId
//        self.interlocutorSummary = interlocutorSummary
//        self.messages = messages
//        self.unreadMessages = unreadMessages
//        self.lastUpdate = lastUpdate
//        self.serviceId = serviceId
//        self.reviewId = reviewId
//        self.lots = lots
//        self.folder = folder
//        self.isBlocked = isBlocked
//    }
//}
