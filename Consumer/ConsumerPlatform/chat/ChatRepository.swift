//
//  ChatRepository.swift
//  ConsumerPlatform
//
//  Created by Nikita on 25.05.2023.
//

import Foundation
import RxSwift
import ConsumerDomain
import SwiftProtobuf
import ChatGRPC

public final class ChatRepository: ChatRepositoryProtocol {

    private let remote: ChatDataSourceProtocol
    
    public init(remote: ChatDataSourceProtocol) { self.remote = remote }
    
    public func getRecentChats(chatPagination: ChatPagination?) -> Observable<Void> {

        if chatPagination == nil {
            return remote.getRecentChats(request: .getRecentChats(.init()) )
        }
        
        guard let chatPagination = chatPagination else { return Observable.of(Void())}
        
        return remote.getRecentChats(request: .getRecentChats(.with({
            $0.pagination = .with({
                $0.size = chatPagination.size
                $0.timeBefore = chatPagination.timeBefore
            })
        })))
    }
    
    public func getResponsesFromServer() -> Observable<ChatRouteResponse.OneOf_Response> {
        return remote.getResponsesFromServer()
    }
    
    public func sendMessage(request: ChatGRPC.SendMessageRequest) -> RxSwift.Observable<Void> {
        remote.sendMessage(request: .sendMessage(request))
    }
    
    public func startChat(request: ChatGRPC.StartChatRequest) -> RxSwift.Observable<Void> {
        remote.sendMessage(request: .startChat(request))
    }
}
