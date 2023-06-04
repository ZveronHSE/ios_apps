//
//  ChatMessageViewModel.swift
//  ConsumerApp
//
//  Created by Nikita on 25.05.2023.
//

import Foundation
import ZveronNetwork
import RxSwift
import ConsumerDomain
import ChatGRPC

class ChatListViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    private let chatUseCase: ChatUseCaseProtocol
    private let profileUseCase: ProfileUseCaseProtocol
    //private let errorTracker = ErrorTracker()
    
    let isSentInfo: PublishSubject<Bool> = PublishSubject()
    let responseFromServer: PublishSubject<ChatRouteResponse.OneOf_Response> = PublishSubject()
    let isLoadedInfoChats: PublishSubject<Bool> = PublishSubject()
    let isLoadedInfoChatsRefresh: PublishSubject<Bool> = PublishSubject()
    
    let profileInfo: PublishSubject<ProfileInfo> = PublishSubject()
    let isLoadedProfileInfo: PublishSubject<Bool> = PublishSubject()
    
    public var isFullLoaded: Observable<Bool> {
        return Observable.combineLatest(isLoadedInfoChats, isLoadedProfileInfo) { $0 && $1 }
    }
    

    
    public init(_ chatUseCase: ChatUseCaseProtocol, _ profileUseCase: ProfileUseCaseProtocol) {
        self.chatUseCase = chatUseCase
        self.profileUseCase = profileUseCase
    }
   

    func getRecentChats(pagination: ChatPagination? = nil) {
//        let pagination = ChatPagination.with{$0.size = 100}
        
        chatUseCase.getRecentChats(chatPagination: pagination)
//            .trackError(errorTracker)
//            .asDriverOnErrorJustComplete()
            .subscribe(onNext: {
                self.isSentInfo.onNext(true)
                print("Запрос о получении недавних чатов отправлен на сервер")
            })
            .disposed(by: disposeBag)
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
        
    func loadProfileInfo() {
        profileUseCase.getProfileInfo()
            .subscribe(onNext: {
                self.profileInfo.onNext($0)
                self.isLoadedProfileInfo.onNext(true)
            })
            .disposed(by: disposeBag)
    }
}
