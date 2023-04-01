//
//  AuthUseCase.swift
//  Platform
//
//  Created by alexander on 27.01.2023.
//

import Foundation
import ConsumerDomain
import RxSwift
import AuthGRPC
import UIKit

public class AuthUseCase: AuthUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol

    public init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    public func loginBySocial(socialToken: String, provider: AuthProvider) -> Observable<Void> {
        return authRepository.loginBySocial(
            socialToken: socialToken,
            finger: UIDevice.current.identifierForVendor!.uuidString,
            provider: provider
        )
    }

    public func loginByPassword(phoneNumber: String, password: String) -> Observable<Void> {
        return authRepository.loginByPassword(phoneNumber: phoneNumber, password: password)
    }

    public func loginPhoneInit(phoneNumber: String) -> Observable<Void> {
        return authRepository.loginPhoneInit(
            phoneNumber: phoneNumber,
            finger: UIDevice.current.identifierForVendor!.uuidString
        )
    }

    public func loginPhoneVerify(code: String) -> Observable<Bool> {
        return authRepository.loginPhoneVerify(code: code, finger: UIDevice.current.identifierForVendor!.uuidString)
    }

    public func registerByPhone(name: String, surname: String, password: String) -> Observable<Void> {
        return authRepository.registerByPhone(
            name: name,
            surname: surname,
            password: password,
            finger: UIDevice.current.identifierForVendor!.uuidString
        )
    }
}
