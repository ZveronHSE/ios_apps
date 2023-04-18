//
//  OrderCustomerProfileMapper.swift
//  SpecialistPlatform
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import SpecialistDomain
import OrderGRPC

extension OrderGRPC.Profile: MapperProtocol {
    typealias Model = SpecialistDomain.OrderCustomerPreview

    func mapToModel() -> SpecialistDomain.OrderCustomerPreview {
        return .init(
            id: Int(self.id),
            name: self.name,
            imageUrl: URL(string: self.imageURL)!,
            rating: Double(self.rating)
        )
    }
}
