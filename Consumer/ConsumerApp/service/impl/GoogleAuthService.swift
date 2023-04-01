//
//  GoogleAuthService.swift
//  iosapp
//
//  Created by alexander on 11.01.2023.
//

import Foundation
import AppAuth
import RxSwift
import ConsumerDomain

final class GoogleAuthService: AuthServiceProtocol {
    struct AuthConfig {
        fileprivate static let authUri = "https://accounts.google.com/o/oauth2/v2/auth"
        fileprivate static let tokenUri = "https://oauth2.googleapis.com/token"
        fileprivate static let scopes = ["email", "profile"]
        fileprivate static let clientId = "205388269927-5gb8diqd7u0c1s8vc9si8uem2cahjb54.apps.googleusercontent.com"
        fileprivate static let callbackUrl = "ru.hse.zveron.iosapp:/callback"
    }

    static let shared = GoogleAuthService()
    private init() { }

    private var flow: OIDExternalUserAgentSession?

    private let configuration = OIDServiceConfiguration(
        authorizationEndpoint: URL(string: AuthConfig.authUri)!,
        tokenEndpoint: URL(string: AuthConfig.tokenUri)!)

    func login() -> Observable<String> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }

            let request = OIDAuthorizationRequest(
                configuration: self.configuration,
                clientId: AuthConfig.clientId,
                scopes: AuthConfig.scopes,
                redirectURL: URL(string: AuthConfig.callbackUrl)!,
                responseType: OIDResponseTypeCode,
                additionalParameters: nil
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
                        observer.onError(AuthError.externalAuthFailed(provider: .gmail))
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
