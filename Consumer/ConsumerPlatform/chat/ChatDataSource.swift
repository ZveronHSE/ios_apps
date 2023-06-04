//
//  ChatDataSource.swift
//  ConsumerPlatform
//
//  Created by Nikita on 25.05.2023.
//

import Foundation
import ZveronNetwork
import ConsumerDomain
import ChatGRPC
import RxSwift

public final class ChatRemoteDataSource: ChatDataSourceProtocol  {
    
    private let apigateway: Apigateway

    public init(_ apigateway: Apigateway) {
        self.apigateway = apigateway
    }
    
    public func getRecentChats(request: ChatRouteRequest.OneOf_Request) -> Observable<Void> {
        return apigateway.sendMessages(request: request)
    }
    
    
    
    public func getResponsesFromServer() -> Observable<ChatRouteResponse.OneOf_Response> {
        return apigateway.getMessages()
    }
    
    public func sendMessage(request: ChatGRPC.ChatRouteRequest.OneOf_Request) -> RxSwift.Observable<Void> {
        return apigateway.sendMessages(request: request)
    }
    
    public func startChat(request: ChatGRPC.ChatRouteRequest.OneOf_Request) -> RxSwift.Observable<Void> {
        apigateway.sendMessages(request: request)
    }
}
