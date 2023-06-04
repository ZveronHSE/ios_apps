//
//  CardLotViewModel.swift
//  ConsumerApp
//
//  Created by Nikita on 31.05.2023.
//

import Foundation
import ZveronNetwork
import RxSwift
import ConsumerDomain
import ChatGRPC

class CardLotViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    private let chatUseCase: ChatUseCaseProtocol
    private let profileUseCase: ProfileUseCaseProtocol
    let profileInfo: PublishSubject<ProfileInfo> = PublishSubject()
    
    
    public init(_ chatUseCase: ChatUseCaseProtocol, _ profileUseCase: ProfileUseCaseProtocol) {
        self.chatUseCase = chatUseCase
        self.profileUseCase = profileUseCase
    }
    

    func loadProfileInfo() {
        profileUseCase.getProfileInfo()
            .subscribe(onNext: {
                self.profileInfo.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    

    
}
