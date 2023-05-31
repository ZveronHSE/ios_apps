//
//  ProfileError.swift
//  Domain
//
//  Created by Nikita on 24.03.2023.
//

import Foundation

public enum ProfileError: Error {
    case failedLoadInfo
    case failedDeleteProfile
    case failedEditProfile
    case failedLoadAnimals
}

extension ProfileError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedLoadInfo: return NSLocalizedString("не загрузилась информация Профиля", comment: "")
        case .failedDeleteProfile: return NSLocalizedString("не удалось удалить аккаунт", comment: "")
        case .failedEditProfile: return NSLocalizedString("не удалось изменить данные аккаунта", comment: "")
        case .failedLoadAnimals: return NSLocalizedString("Не удалось загрузить ваших питомцев. Попробуйте еще раз", comment: "")
        default: return NSLocalizedString("", comment: "")
        }
    }
}
