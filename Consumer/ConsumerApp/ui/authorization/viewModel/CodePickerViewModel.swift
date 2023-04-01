//
//  SendCodePickerViewModel.swift
//  iosapp
//
//  Created by alexander on 21.04.2022.
//

import Foundation
import RxSwift
import ZveronRemoteDataService
import RxRelay
import SwiftUI
import ConsumerDomain

class CodePickerViewModel: ViewModelType {
    // MARK: Events
    let checkCode = PublishRelay<CheckCodeStatus>()
    let setErrorScreenState = PublishRelay<String?>()
    let codeTextFieldState = PublishRelay<Bool>()
    let alert = PublishRelay<String?>()

    // MARK: Properties
    let disposeBag = DisposeBag()
    private let authUseCase: AuthUseCaseProtocol

    init(_ authUseCase: AuthUseCaseProtocol) {
        self.authUseCase = authUseCase

        setErrorScreenState.subscribe(onNext: { errorMessage in
            let isErrorState = errorMessage == nil
            self.codeTextFieldState.accept(isErrorState)
            self.alert.accept(errorMessage)
        }).disposed(by: disposeBag)
    }

    func reSendCode(phone: String) {
        let phoneFormatted = phone
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")

        authUseCase.loginPhoneInit(phoneNumber: phoneFormatted).subscribe(
            onNext: { },
            onError: { self.setErrorScreenState.accept($0.localizedDescription) }
        ).disposed(by: disposeBag)
    }

    func checkCode(code: String) {
        authUseCase.loginPhoneVerify(code: code).subscribe(
            onNext: { isAuthorized in
                self.checkCode.accept(isAuthorized ? .loginSuccess : .needRegistration)
            },
            onError: { self.setErrorScreenState.accept($0.localizedDescription) }
        ).disposed(by: disposeBag)
    }
}

public enum CheckCodeStatus {
    case loginSuccess
    case needRegistration
}
