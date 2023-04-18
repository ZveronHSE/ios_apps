//
//  GetOrderResponseMapper.swift
//  SpecialistPlatform
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import SpecialistDomain
import OrderGRPC

extension OrderGRPC.GetOrderResponse: MapperProtocol {
    typealias Model = Order

    func mapToModel() -> SpecialistDomain.Order {
        return self.order.mapToModel()
    }
}
