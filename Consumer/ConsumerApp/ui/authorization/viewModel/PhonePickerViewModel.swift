//
//  NumberPickerViewModel.swift
//  iosapp
//
//  Created by alexander on 17.04.2022.
//

import Foundation
import ConsumerDomain
import RxSwift
import RxCocoa

public final class PhonePickerViewModel: ViewModelType {
    var disposeBag: RxSwift.DisposeBag {
        DisposeBag()
    }

    enum ScreenState {
        case normal
        case error(cause: Error)
    }

    struct Input {
        let sendCodeTrigger: Driver<Void>
        let inputPhoneTrigger: Driver<String>
        let authByPasswordTrigger: Driver<Void>
    }

    struct Output {
        let sendCode: Driver<Void>
        let authByPassword: Driver<Void>
        let isButtonEnabled: Driver<Bool>
        let screenState: Driver<ScreenState>
    }

    private let authUseCase: AuthUseCaseProtocol

    init(_ authUseCase: AuthUseCaseProtocol) {
        self.authUseCase = authUseCase
    }

    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()

        let sendCode = input.sendCodeTrigger.withLatestFrom(input.inputPhoneTrigger).flatMap {
            let formattedPhone = $0
                .replacingOccurrences(of: "+7", with: "7")
                .replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: " ", with: "")

            return self.authUseCase
                .loginPhoneInit(phoneNumber: formattedPhone)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
            // TODO: invoke navigator, from this view to next view
            // .do(onNext: )
        }

        let authByPassword = input.authByPasswordTrigger
        // TODO: invoke navigator, from this view to next view
        //       .do(onNext: )

        let isPhoneInputted = input.inputPhoneTrigger
            .map { $0.count == 16 }
            .distinctUntilChanged()

        let screenState = Observable.of(isPhoneInputted.map { _ in ScreenState.normal }, errorTracker.map { .error(cause: $0) })
            .merge()
            .asDriverOnErrorJustComplete()

        let isButtonEnabled = Observable.of(isPhoneInputted, errorTracker.map { _ in false })
            .merge()
            .asDriverOnErrorJustComplete()

        return Output(
            sendCode: sendCode,
            authByPassword: authByPassword,
            isButtonEnabled: isButtonEnabled,
            screenState: screenState
        )
    }
}
