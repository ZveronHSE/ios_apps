//
//  TokenAcquisitionService.swift
//
//
//  Created by alexander on 01.02.2023.
//

import Foundation
import AuthGRPC
import ZveronSupport

/// Cервис по предоставлению и сохранению jwt токена
/// Также предоставляет актуальный статус пользователя отностиельно авторизации
public final class TokenAcquisitionService {
    /// configuration for keychain
    private struct TokenKeys {
        fileprivate static let service: String = "internal"
        fileprivate static let account: String = "jwt"
    }
    
    public static let shared = TokenAcquisitionService()
    private let locker = NSRecursiveLock()
    private init() { }

    var isUpdating: Bool = false
}

// MARK: methods to work with token
public extension TokenAcquisitionService {
    func setToken(token: MobileToken) {
        locker.lock()
        KeychainHelper.shared.save((try? token.jsonUTF8Data())!, service: TokenKeys.service, account: TokenKeys.account)
        locker.unlock()
    }

    func getToken() -> MobileToken? {
        // TODO: FOR DEBBUGING
        //cleanToken()

        locker.lock()
        let token = KeychainHelper.shared.read(service: TokenKeys.service, account: TokenKeys.account)
            .flatMap { (try? MobileToken.init(jsonUTF8Data: $0))! }
        locker.unlock()
        return token
    }

    func cleanToken() {
        locker.lock()
        KeychainHelper.shared.delete(service: TokenKeys.service, account: TokenKeys.account)
        locker.unlock()
    }

    func lock() {
        locker.lock()
        print("\(Thread.current.description) locked token service")
    }

    func unlock() {
        locker.unlock()
        print("\(Thread.current.description) unlocked token service")
    }
}

// MARK: auth state for current user
public extension TokenAcquisitionService {
    enum AuthState {
        /// access token valid
        case authorized

        /// access is expired but refresh is valid
        case needUpdateAccess

        /// access and refresh is expired
        case logout

        /// access and refresh not present
        case notAuthorized
    }

    var authState: AuthState {
        guard let actualToken = getToken() else { return .notAuthorized }
        guard actualToken.refreshToken.expiration.date > Date() else { return .logout }
        guard actualToken.accessToken.expiration.date > Date() else { return .needUpdateAccess }
        return .authorized
    }
}
