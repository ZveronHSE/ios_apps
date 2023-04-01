//
//  ExternalAuthViewModel.swift
//  iosapp
//
//  Created by alexander on 25.04.2022.
//

import Foundation
import ConsumerDomain
import RxSwift
import RxCocoa
import AuthGRPC

class ExternalAuthViewModel: ViewModelType {

    struct Input {
        let authTrigger: Driver<AuthProvider>
    }

    struct Output {
        let auth: Driver<Void>
        let cancelAuth: Driver<Void>
        let errors: Driver<Error>
    }

    // MARK: Properties
    let disposeBag = DisposeBag()
    private let authUseCase: AuthUseCaseProtocol

    init(_ authUseCase: AuthUseCaseProtocol) {
        self.authUseCase = authUseCase
    }

    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()

        let auth = input.authTrigger
        // TODO: dissmiss view conteroller Implement this when navigator will be implemented
        // .do(onNext: {} )
        .flatMap { provider in
            let authService: AuthServiceProtocol!

            switch provider {
            case .gmail: authService = GoogleAuthService.shared
            case .vk: authService = VkAuthService.shared
            case .mailRu: authService = MailAuthService.shared
            case .apple: fatalError("not implemented")
            default: fatalError("unexpected auth provider is present \(provider)")
            }

            return authService.login().flatMap { token in
                self.authUseCase.loginBySocial(socialToken: token, provider: provider)
            }
                .trackError(errorTracker)
            // TODO: dissmiss view conteroller Implement this when navigator will be implemented
            // .do(onNext: {} )
            .asDriverOnErrorJustComplete()
        }

        let cancelAuth = errorTracker.filter {
            if let error = $0 as? AuthError {
                switch error {
                case .externalAuthCanceled: return true
                default: return false
                }
            }
            return false
        }
            .map { _ in Void() }
        // TODO: present this view again. Implement this when navigator will be implemented
        // .do(onNext: {} )
        .asDriver()


        let errors = errorTracker.filter({
            if let error = $0 as? AuthError {
                switch error {
                case .externalAuthCanceled: return false
                default: return true
                }
            }
            return true
        })
            .asDriver()

        return Output(
            auth: auth,
            cancelAuth: cancelAuth,
            errors: errors
        )
    }
}
