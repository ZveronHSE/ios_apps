//
//  ChatUseCase.swift
//  ConsumerPlatform
//
//  Created by Nikita on 25.05.2023.
//

import Foundation
import RxSwift
import ConsumerDomain
import ChatGRPC

public final class ChatUseCase: ChatUseCaseProtocol {

    private let chatRepository: ChatRepositoryProtocol
    
    public init(with chatRepository: ChatRepositoryProtocol) {
        self.chatRepository = chatRepository
    }
    
    public func getRecentChats(chatPagination: ChatPagination?) -> RxSwift.Observable<Void> {
        return chatRepository.getRecentChats(chatPagination: chatPagination)//.mapErrors(default: ChatError.failedStreaming)
    }
    
    public func getResponsesFromServer() -> RxSwift.Observable<ChatGRPC.ChatRouteResponse.OneOf_Response> {
        return chatRepository.getResponsesFromServer()//.mapErrors(default: ChatError.failedStreaming)
    }
    
    public func sendMessage(request: ChatGRPC.SendMessageRequest) -> RxSwift.Observable<Void> {
        return chatRepository.sendMessage(request: request)
    }
    
    public func startChat(interlocutorID: UInt64, lotID: UInt64, firstMessage: String) -> RxSwift.Observable<Void> {
        let request = ChatGRPC.StartChatRequest.with({
            $0.interlocutorID = interlocutorID
            $0.article = ChatGRPC.Article.with({
                $0.id = lotID
                $0.type = .lot
            })
            $0.text = firstMessage
        })
        return chatRepository.startChat(request: request)
    }
}
