//
//  LotError.swift
//  Domain
//
//  Created by Nikita on 27.03.2023.
//

import Foundation

public enum LotError: Error {
    case failedCreateLot
}

extension LotError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedCreateLot: return NSLocalizedString("не удалось создать объявление", comment: "")
        default: return NSLocalizedString("", comment: "")
        }
    }
}
