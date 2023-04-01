//
//  AuthError.swift
//  Platform
//
//  Created by alexander on 14.02.2023.
//

import Foundation
import AuthGRPC

public enum AuthError: Error {
    case notValidCode
    case externalAuthCanceled
    case externalAuthFailed(provider: AuthProvider)
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notValidCode:
            return NSLocalizedString("Неверный код, введите еще раз", comment: "")
        case .externalAuthCanceled:
            return NSLocalizedString("Вы отменили авторизацию через соц-сеть", comment: "")
        case .externalAuthFailed(let provider):
            return NSLocalizedString("При авторизации через \(provider) произошла ошибка!\nПопробуйте другой способ авторизации", comment: "")
        }
    }
}
