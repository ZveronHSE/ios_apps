//
//  ChatMessageViewModel.swift
//  ConsumerApp
//
//  Created by Nikita on 27.05.2023.
//

import Foundation

import Foundation
import ZveronNetwork
import RxSwift
import ConsumerDomain
import ChatGRPC

class ChatMessageViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    private let chatUseCase: ChatUseCaseProtocol
    
    //private let errorTracker = ErrorTracker()
    
    let isSentMessage: PublishSubject<Bool> = PublishSubject()
    let message: PublishSubject<Message> = PublishSubject()
    
    let responseFromServer: PublishSubject<ChatRouteResponse.OneOf_Response> = PublishSubject()
    let isLoadedInfo: PublishSubject<Bool> = PublishSubject()
    
    public init(_ chatUseCase: ChatUseCaseProtocol) {
        self.chatUseCase = chatUseCase
    }
    
    
    func getResponsesFromServer() {
        chatUseCase.getResponsesFromServer()
//            .trackError(errorTracker)
//            .asDriverOnErrorJustComplete()
            .subscribe(onNext: { response in
                self.responseFromServer.onNext(response)
            })
            .disposed(by: disposeBag)
        
    }
        
    
    func sendMessage(request: SendMessageRequest) {
        chatUseCase.sendMessage(request: request)
            .subscribe(onNext: {
                self.isSentMessage.onNext(true)
                print("Сообщение отправлено на сервер")
            })
            .disposed(by: disposeBag)
    }
    
    func startChat(interlocutorID: UInt64, lotID: UInt64, firstMessage: String) {
        chatUseCase.startChat(interlocutorID: interlocutorID, lotID: lotID, firstMessage: firstMessage)
            .subscribe(onNext: {
                print("Чат создан на сервере")
            })
            .disposed(by: disposeBag)
    }
}
