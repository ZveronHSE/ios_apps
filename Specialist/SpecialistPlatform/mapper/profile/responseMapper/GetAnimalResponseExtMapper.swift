//
//  GetAnimalResponseExtMapper.swift
//  SpecialistPlatform
//
//  Created by alexander on 18.04.2023.
//

import Foundation
import SpecialistDomain
import ProfileGRPC

extension ProfileGRPC.GetAnimalResponseExt: MapperProtocol {
    typealias Model = AnimalProfile

    func mapToModel() -> AnimalProfile {
        return self.animal.mapToModel()
    }
}
