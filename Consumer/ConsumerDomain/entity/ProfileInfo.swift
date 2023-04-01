//
//  ProfileInfo.swift
//  Domain
//
//  Created by Nikita on 25.03.2023.
//

import Foundation
public struct ProfileInfo {
    public let id: UInt64
    public let name: String
    public let surname: String
    public let imageUrl: String
    public let rating: Double
    public let address: Address
    
    public init(id: UInt64, name: String, surname: String, imageUrl: String, rating: Double, address: Address) {
        self.id = id
        self.name = name
        self.surname = surname
        self.imageUrl = imageUrl
        self.rating = rating
        self.address = address
    }

}
