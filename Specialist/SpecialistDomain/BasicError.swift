//
//  BasicError.swift
//  SpecialistDomain
//
//  Created by alexander on 17.04.2023.
//

import Foundation

public enum BasicError: Error {
    case timeout
    case serverInternal
    case unexpected
}

extension BasicError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .timeout:
            return NSLocalizedString("Похоже произошла ошибка из-за нестабильного интернет-соединения\nПроверь интернет и попробуй еще раз", comment: "")
        case .serverInternal: return NSLocalizedString("", comment: "")
        case .unexpected:
            return NSLocalizedString("Произошла непредвиденная ошибка\nПопробуй повторить действие чуть позже", comment: "")
        }
    }
}
