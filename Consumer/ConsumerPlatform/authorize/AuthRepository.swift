//
//  AuthRepository.swift
//  Platform
//
//  Created by alexander on 27.01.2023.
//

import Foundation
import ConsumerDomain
import AuthGRPC
import RxSwift
import ZveronNetwork

public final class AuthRepository: AuthRepositoryProtocol {
    private let remoteSource: AuthDataSourceProtocol
    private var currentSessionId: String?

    public init(remote: AuthDataSourceProtocol) {
        self.remoteSource = remote
    }

    public func loginBySocial(socialToken: String, finger: String, provider: AuthProvider) -> Observable<Void> {
        let request = LoginBySocialRequest.with {
            $0.accessToken = socialToken
            $0.deviceFp = finger
            $0.authProvider = provider
        }

        return remoteSource.loginBySocial(request: request).map { token in
            TokenAcquisitionService.shared.setToken(token: token)
            Void()
        }
    }

    public func loginByPassword(phoneNumber: String, password: String) -> Observable<Void> {
        let request = LoginByPasswordRequest.with {
            $0.phoneNumber = phoneNumber
            $0.password = password.toBase64()
        }

        return remoteSource.loginByPassword(request: request).map { token in
            TokenAcquisitionService.shared.setToken(token: token)
            Void()
        }
    }

    public func loginPhoneInit(phoneNumber: String, finger: String) -> Observable<Void> {
        let request = PhoneLoginInitRequest.with {
            $0.phoneNumber = phoneNumber
            $0.deviceFp = finger
        }

        return remoteSource.loginPhoneInit(request: request).map { body in
            self.currentSessionId = body.sessionID
            return Void()
        }
    }

    public func loginPhoneVerify(code: String, finger: String) -> Observable<Bool> {
        let request = PhoneLoginVerifyRequest.with {
            $0.code = code
            $0.deviceFp = finger
            $0.sessionID = self.currentSessionId ?? ""
        }

        return remoteSource.loginPhoneVerify(request: request).map { body in
            switch body.data! {
            case .sessionID(let sessionId):
                self.currentSessionId = sessionId
                return false
            case .mobileToken(let token):
                TokenAcquisitionService.shared.setToken(token: token)
                return true
            }
        }
    }

    public func registerByPhone(name: String, surname: String, password: String, finger: String) -> Observable<Void> {
        let request = PhoneRegisterRequest.with {
            $0.deviceFp = finger
            $0.name = name
            $0.surname = surname
            $0.password = password.toBase64()
            $0.sessionID = self.currentSessionId ?? ""
        }

        return remoteSource.registerByPhone(request: request).map { token in
            TokenAcquisitionService.shared.setToken(token: token)
            Void()
        }
    }
}
