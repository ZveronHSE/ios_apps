//
//  OrderCustomerPreview.swift
//  SpecialistDomain
//
//  Created by alexander on 17.04.2023.
//

import Foundation

public struct OrderCustomerPreview {
    public let id: Int
    public let name: String
    public let imageUrl: URL
    public let rating: Double

    public init(
        id: Int,
        name: String,
        imageUrl: URL,
        rating: Double
    ) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.rating = rating
    }
}
