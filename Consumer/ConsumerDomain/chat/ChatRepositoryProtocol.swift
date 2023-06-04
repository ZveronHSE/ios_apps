//
//  ChatRepositoryProtocol.swift
//  ConsumerDomain
//
//  Created by Nikita on 25.05.2023.
//

import Foundation
import ChatGRPC
import RxSwift

public protocol ChatRepositoryProtocol {
    
    func getRecentChats(chatPagination: ChatPagination?) -> Observable<Void>
    
    func getResponsesFromServer() -> Observable<ChatRouteResponse.OneOf_Response>
    
    func sendMessage(request: SendMessageRequest) -> Observable<Void>
    
    func startChat(request: StartChatRequest) -> Observable<Void>
}
