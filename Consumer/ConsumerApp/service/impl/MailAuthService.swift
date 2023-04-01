//
//  MailAuthService.swift
//  iosapp
//
//  Created by alexander on 18.01.2023.
//

import Foundation
import AppAuth
import RxSwift
import ConsumerDomain

final class MailAuthService: AuthServiceProtocol {

    struct AuthConfig {
        fileprivate static let authUri = "https://oauth.mail.ru/login"
        fileprivate static let tokenUri = "https://oauth.mail.ru/token"
        fileprivate static let scopes = ["userinfo"]
        fileprivate static let clientId = "c7cfaed4ad0943fc8a0bb4eb3792efc9"
        fileprivate static let clientSecret = "bb5ee10ff7c64a37ad478a9899039cc5"
        fileprivate static let callbackUrl = "ru.hse.zveron.iosapp://mail.ru/redirect"
    }

    static let shared = MailAuthService()
    private init() { }

    private var flow: OIDExternalUserAgentSession?

    private let configuration = OIDServiceConfiguration(
        authorizationEndpoint: URL(string: AuthConfig.authUri)!,
        tokenEndpoint: URL(string: AuthConfig.tokenUri)!
    )

    func login() -> Observable<String> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }

            let request = OIDAuthorizationRequest(
                configuration: self.configuration,
                clientId: AuthConfig.clientId,
                clientSecret: AuthConfig.clientSecret,
                scopes: AuthConfig.scopes,
                redirectURL: URL(string: AuthConfig.callbackUrl)!,
                responseType: OIDResponseTypeCode,
                additionalParameters: ["prompt_force": "1"]
            )

            let presentingController = UIApplication.shared.keyWindow!.rootViewController!

            self.flow = OIDAuthState.authState(
                byPresenting: request,
                presenting: presentingController
            ) { authState, error in

                if let error = error {
                    if (error as NSError).code == OIDErrorCode.userCanceledAuthorizationFlow.rawValue {
                        observer.onError(AuthError.externalAuthCanceled)
                    } else {
                        observer.onError(AuthError.externalAuthFailed(provider: .mailRu))
                    }
                } else {
                    let token = authState!.lastTokenResponse!.accessToken!
                    observer.onNext(token)
                    observer.onCompleted()
                }
                self.flow = nil
            }

            return Disposables.create()
        }
    }
}
