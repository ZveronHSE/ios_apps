//
//  GetWaterfallResponseMapper.swift
//  SpecialistPlatform
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import SpecialistDomain
import OrderGRPC

extension OrderGRPC.GetWaterfallResponse: MapperProtocol {
    typealias Model = [OrderPreview]

    func mapToModel() -> [SpecialistDomain.OrderPreview] {
        return self.orders.map { $0.mapToModel() }
    }
}
