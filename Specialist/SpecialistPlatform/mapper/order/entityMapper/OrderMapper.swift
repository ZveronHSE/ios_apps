//
//  OrderMapper.swift
//  SpecialistPlatform
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import SpecialistDomain
import OrderGRPC

extension OrderGRPC.FullOrder: MapperProtocol {
    typealias Model = SpecialistDomain.Order

    func mapToModel() -> SpecialistDomain.Order {
        return .init(
            id: Int(self.id),
            customerPreview: self.profile.mapToModel(),
            animalPreview: self.animal.mapToModel(),
            title: self.title,
            price: self.price,
            createdDate: self.createdAt,
            address: self.address.mapToModel(),
            serviceDate: self.serviceDate,
            serviceTime: self.serviceTime,
            description: self.description_p,
            similarOrders: self.similarOrders.map { $0.mapToModel() },
            availableResponse: self.canAccept
        )
    }
}
