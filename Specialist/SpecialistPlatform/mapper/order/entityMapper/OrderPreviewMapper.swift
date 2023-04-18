//
//  OrderPreviewMapper.swift
//  SpecialistPlatform
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import OrderGRPC
import SpecialistDomain

extension OrderGRPC.WaterfallOrder: MapperProtocol {
    typealias Model = SpecialistDomain.OrderPreview

    func mapToModel() -> SpecialistDomain.OrderPreview {
        return .init(
            id: Int(self.id),
            animal: self.animal.mapToModel(),
            title: self.title,
            price: self.price,
            address: self.address.mapToModel(),
            serviceDate: self.serviceDate,
            createdDate: self.createdAt
        )
    }
}
