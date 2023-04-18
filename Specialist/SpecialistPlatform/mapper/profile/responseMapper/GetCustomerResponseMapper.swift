//
//  GetCustomerResponseMapper.swift
//  SpecialistPlatform
//
//  Created by alexander on 12.05.2023.
//

import Foundation
import SpecialistDomain
import OrderGRPC

extension OrderGRPC.GetCustomerResponse: MapperProtocol {
    typealias Model = CustomerProfile

    func mapToModel() -> CustomerProfile {
        return self.customer.mapToModel()
    }
}
