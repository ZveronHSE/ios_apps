//
//  ParameterError.swift
//  Domain
//
//  Created by Nikita on 28.03.2023.
//

import Foundation

public enum ParameterError: Error {
    case failedGetLotForms
    case failedGetChildren
    case failedGetParameters
}

extension ParameterError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedGetLotForms: return NSLocalizedString("не удалось загрузить категории продажи для лота", comment: "продажа/случка/аренда")
        case .failedGetChildren: return NSLocalizedString("не удалось загрузить виды лота", comment: "собака/кошка")
        case .failedGetParameters: return NSLocalizedString("не удалось загрузить параметры для лота", comment: "порода/прочее")
        default: return NSLocalizedString("", comment: "")
        }
    }
}
