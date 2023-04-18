//
//  OrderAddressMapper.swift
//  SpecialistPlatform
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import OrderGRPC
import SpecialistDomain

extension OrderGRPC.Address: MapperProtocol {
    typealias Model = SpecialistDomain.OrderAddress

    func mapToModel() -> SpecialistDomain.OrderAddress {
        return .init(
            town: self.town,
            station: self.station,
            color: self.color
        )
    }
}
