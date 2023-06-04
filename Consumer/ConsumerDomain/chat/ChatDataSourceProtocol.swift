//
//  ChatDataSourceProtocol.swift
//  ConsumerDomain
//
//  Created by Nikita on 25.05.2023.
//

import Foundation
import RxSwift
//TODO: потом убрать
import ChatGRPC

public protocol ChatDataSourceProtocol {
    
    func getRecentChats(request: ChatRouteRequest.OneOf_Request) -> Observable<Void>
    
    func getResponsesFromServer() -> Observable<ChatRouteResponse.OneOf_Response>
    
    func sendMessage(request: ChatRouteRequest.OneOf_Request) -> Observable<Void>
    
    func startChat(request: ChatRouteRequest.OneOf_Request) -> Observable<Void>
}
