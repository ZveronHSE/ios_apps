//
//  AnimalDocumentMapper.swift
//  SpecialistPlatform
//
//  Created by alexander on 22.05.2023.
//

import Foundation
import ProfileGRPC
import SpecialistDomain

extension ProfileGRPC.AnimalDocument: MapperProtocol {
    typealias Model = SpecialistDomain.AnimalDocument

    func mapToModel() -> SpecialistDomain.AnimalDocument {
        return .init(
            name: self.name,
            url: URL(string: self.url)!
        )
    }
}
