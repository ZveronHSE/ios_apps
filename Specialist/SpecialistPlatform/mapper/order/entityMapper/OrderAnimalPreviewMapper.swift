//
//  OrderAnimalMapper.swift
//  SpecialistPlatform
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import OrderGRPC
import SpecialistDomain

extension OrderGRPC.Animal: MapperProtocol {
    typealias Model = SpecialistDomain.OrderAnimalPreview

    func mapToModel() -> SpecialistDomain.OrderAnimalPreview {
        return .init(
            id: Int(self.id),
            name: self.name,
            breed: self.breed,
            species: self.species,
            imageUrl: URL(string: self.imageURL)!
        )
    }
}
