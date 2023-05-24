//
//  EditProfileViewModel.swift
//  iosapp
//
//  Created by Nikita on 27.03.2023.
//

import Foundation
import RxSwift
import ConsumerDomain
import RxRelay

class EditProfileViewModel: ViewModelType {

    let disposeBag = DisposeBag()
    
    private let profileUseCase: ProfileUseCaseProtocol
    let profileInfo: PublishSubject<ProfileInfo> = PublishSubject()
    private let errorTracker = ErrorTracker()
    
    public init(_ profileUseCase: ProfileUseCaseProtocol) {
        self.profileUseCase = profileUseCase
    }
    
    func setProfileInfo(with info: ProfileInfo) {
        profileUseCase.setProfileInfo(with: info)
            .trackError(errorTracker)
            .subscribe()
            .disposed(by: disposeBag)
        
    }
    
}
