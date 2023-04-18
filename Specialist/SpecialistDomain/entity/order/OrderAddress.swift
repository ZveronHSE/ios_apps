//
//  OrderAddress.swift
//  SpecialistDomain
//
//  Created by alexander on 17.04.2023.
//

import Foundation

public struct OrderAddress {
    public let town: String
    public let station: String
    public let color: String

    public init(
        town: String,
        station: String,
        color: String
    ) {
        self.town = town
        self.station = station
        self.color = color
    }
}
