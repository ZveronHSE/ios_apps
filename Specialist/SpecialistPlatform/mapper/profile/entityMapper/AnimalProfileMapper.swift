//
//  AnimalProfileMapper.swift
//  SpecialistPlatform
//
//  Created by alexander on 18.04.2023.
//

import Foundation
import ProfileGRPC
import SpecialistDomain

extension ProfileGRPC.FullAnimal: MapperProtocol {
    typealias Model = SpecialistDomain.AnimalProfile

    func mapToModel() -> SpecialistDomain.AnimalProfile {
        return .init(
            id: Int(self.id),
            name: self.name,
            breed: self.breed,
            species: self.species,
            // TODO: жать фикса с бека
            age: String(self.age),
            imageUrls: self.imageUrls.map { URL(string: $0)! },
            documents: self.documents.map { $0.mapToModel() }
        )
    }
}
