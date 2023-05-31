//
//  OrderSortingType.swift
//  SpecialistDomain
//
//  Created by alexander on 17.04.2023.
//

import Foundation

public enum OrderSortingType: Int, CaseIterable {
    case _default
    case serviceDelivery
    case distance
    case price
}

public enum OrderSortingTypeDir: Int, CaseIterable {
    case desc
    case asc
}
