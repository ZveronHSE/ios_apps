//
//  ProfileViewModel.swift
//  iosapp
//
//  Created by Nikita on 26.03.2023.
//

import Foundation
import RxSwift
import ConsumerDomain
import RxRelay

class ProfileViewModel: ViewModelType {

    let disposeBag = DisposeBag()
    let profileInfo: PublishSubject<ProfileInfo> = PublishSubject()
    let isLoadedInfo: PublishSubject<Bool> = PublishSubject()
    private let profileUseCase: ProfileUseCaseProtocol
    private let errorTracker = ErrorTracker()
    
    public init(_ profileUseCase: ProfileUseCaseProtocol) {
        self.profileUseCase = profileUseCase
    }
    
    func loadProfileInfo() {
        profileUseCase.getProfileInfo()
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                self.profileInfo.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteProfile() {
        profileUseCase.deleteProfile()
            .trackError(errorTracker)
            .subscribe()
            .disposed(by: disposeBag)
    }
        
}
