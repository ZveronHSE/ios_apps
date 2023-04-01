//
//  VkAuthService.swift
//  iosapp
//
//  Created by alexander on 11.01.2023.
//

import Foundation
import UIKit
import RxSwift
import ConsumerDomain

final class VkAuthService: AuthServiceProtocol {
    struct AuthConfig {
        fileprivate static let clientId = "51524036"
    }

    static let shared = VkAuthService()
    private init() { /* VK.setUp(appId: AuthConfig.clientId, delegate: self) */ }

    func login() -> Observable<String> {
        return Observable.create { observer in
//            VK.sessions.default.logIn(
//                onSuccess: { _ in
//                    DispatchQueue.main.async {
//                        observer.onNext(VK.sessions.default.accessToken!.get()!)
//                        observer.onCompleted()
//                    }
//                },
//                onError: { error in
//                    DispatchQueue.main.async {
//                        switch error {
//                        case .sessionAlreadyAuthorized(let session):
//                            observer.onNext(session.accessToken!.get()!)
//                            observer.onCompleted()
//                        case .authorizationCancelled: observer.onError(AuthError.externalAuthCanceled)
//                        default: observer.onError(AuthError.externalAuthFailed(provider: .vk))
//                        }
//                    }
//                }
//            )
            return Disposables.create()
        }
    }
}

//extension VkAuthService: SwiftyVKDelegate {
//    func vkNeedsScopes(for sessionId: String) -> Scopes {
//        return Scopes.status
//    }
//
//    func vkNeedToPresent(viewController: VKViewController) {
//        UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: true)
//    }
//}
