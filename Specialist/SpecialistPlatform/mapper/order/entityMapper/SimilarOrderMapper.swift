//
//  SimilarOrderMapper.swift
//  SpecialistPlatform
//
//  Created by alexander on 12.05.2023.
//

import Foundation
import SpecialistDomain
import OrderGRPC

extension OrderGRPC.SimilarOrder: MapperProtocol {
    typealias Model = SpecialistDomain.OrderPreview

    func mapToModel() -> SpecialistDomain.OrderPreview {
        return .init(
            id: Int(self.id),
            animal: self.animal.mapToModel(),
            title: self.title,
            price: self.price,
            address: self.address.mapToModel(),
            serviceDate: self.serviceDate,
            createdDate: self.dateCreated
        )
    }
}
