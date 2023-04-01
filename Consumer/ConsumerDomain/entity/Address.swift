//
//  Address.swift
//  Domain
//
//  Created by Nikita on 25.03.2023.
//

import Foundation

public struct Address {
    
    public let region: String
    public let town: String
    public let longitude: Double
    public let latitude: Double
    
    public init(region: String, town: String, longitude: Double, latitude: Double) {
        self.region = region
        self.town = town
        self.longitude = longitude
        self.latitude = latitude
    }
}
