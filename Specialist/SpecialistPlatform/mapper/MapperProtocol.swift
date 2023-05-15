//
//  MapperProtocol.swift
//  SpecialistPlatform
//
//  Created by alexander on 17.04.2023.
//

import Foundation

protocol MapperProtocol {
    associatedtype Model

    func mapToModel() -> Model
}
