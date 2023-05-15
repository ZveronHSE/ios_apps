//
//  ProfileError.swift
//  SpecialistDomain
//
//  Created by alexander on 18.04.2023.
//

import Foundation

public enum ProfileError: Error {
    case getAnimalError
    case getProfileError
}

extension ProfileError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        default: return NSLocalizedString("", comment: "")
        }
    }
}
