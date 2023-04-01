//
//  LotAddress.swift
//  Domain
//
//  Created by Nikita on 27.03.2023.
//

import Foundation

public struct FullAddress {

    public let region: String?
    public let district: String?
    public let town: String?
    public let street: String?
    public let house: String?
    public let longitude: Double
    public let latitude: Double

    public init(region: String? = nil, district: String? = nil, town: String? = nil, street: String? = nil, house: String? = nil, longitude: Double, latitude: Double) {
        self.region = region
        self.district = district
        self.town = town
        self.street = street
        self.house = house
        self.longitude = longitude
        self.latitude = latitude
    }
}
