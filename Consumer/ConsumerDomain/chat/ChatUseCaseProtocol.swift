//
//  ChatUseCaseProtocol.swift
//  ConsumerDomain
//
//  Created by Nikita on 25.05.2023.
//

import Foundation
import RxSwift
import ChatGRPC

public protocol ChatUseCaseProtocol {
    func getRecentChats(chatPagination: ChatPagination?) -> Observable<Void>
    
    func getResponsesFromServer() -> Observable<ChatRouteResponse.OneOf_Response>
    
    func sendMessage(request: SendMessageRequest) -> Observable<Void>
    
    func startChat(interlocutorID: UInt64, lotID: UInt64, firstMessage: String) -> Observable<Void>
}
