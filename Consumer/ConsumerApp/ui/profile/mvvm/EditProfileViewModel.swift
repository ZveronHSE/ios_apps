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
import UIKit

class EditProfileViewModel: ViewModelType {

    let disposeBag = DisposeBag()
    
    private let profileUseCase: ProfileUseCaseProtocol
    
    let result = PublishSubject<Void>()
    let profileInfo: PublishSubject<ProfileInfo> = PublishSubject()
    let imageURL: PublishSubject<String> = PublishSubject()
    private let errorTracker = ErrorTracker()
    
    public init(_ profileUseCase: ProfileUseCaseProtocol) {
        self.profileUseCase = profileUseCase
    }
    
    func setProfileInfo(with info: ProfileInfo) {
        profileUseCase.setProfileInfo(with: info)
            .trackError(errorTracker)
            .subscribe(onNext: {
                self.result.onNext(Void())
            })
            .disposed(by: disposeBag)
    }
    
    func uploadImage(image: UIImage) {
        profileUseCase.uploadImageProfile(image: image.jpegData(compressionQuality: 0.95 )! , type: .imageJpeg)
            .subscribe(onNext: {
                print("Изображение отправлено на сервер")
                self.imageURL.onNext($0)
            })
            .disposed(by: disposeBag)
    }
}
