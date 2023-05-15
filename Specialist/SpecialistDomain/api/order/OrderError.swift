//
//  OrderError.swift
//  SpecialistDomain
//
//  Created by alexander on 17.04.2023.
//

import Foundation

public enum OrderError: Error {
    case fetchError
    case getError
}

extension OrderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        default: return NSLocalizedString("", comment: "")
        }
    }
}
