//
//  CustomerProfile.swift
//  SpecialistPlatform
//
//  Created by alexander on 12.05.2023.
//

import Foundation
import OrderGRPC
import SpecialistDomain

extension OrderGRPC.Customer: MapperProtocol {
    typealias Model = SpecialistDomain.CustomerProfile

    func mapToModel() -> SpecialistDomain.CustomerProfile {
        return .init(
            id: Int(self.id),
            fullname: self.name,
            imageUrl: URL(string: self.imageURL)!,
            rating: Double(self.rating),
            activeOrders: self.activeOrders.map{ $0.mapToModel() },
            closedOrders: self.completedOrders.map{ $0.mapToModel() }
        )
    }
}

extension OrderGRPC.CustomerActiveOrder: MapperProtocol {
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

extension OrderGRPC.CustomerCompletedOrder: MapperProtocol {
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
