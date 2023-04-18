//
//  CustomerProfile.swift
//  SpecialistDomain
//
//  Created by alexander on 18.04.2023.
//

import Foundation

public struct CustomerProfile {
    public let id: Int
    public let fullname: String
    public let imageUrl: URL
    public let rating: Double
    public let activeOrders: [OrderPreview]
    public let closedOrders: [OrderPreview]

    public init(
        id: Int,
        fullname: String,
        imageUrl: URL,
        rating: Double,
        activeOrders: [OrderPreview],
        closedOrders: [OrderPreview]
    ) {
        self.id = id
        self.fullname = fullname
        self.imageUrl = imageUrl
        self.rating = rating
        self.activeOrders = activeOrders
        self.closedOrders = closedOrders
    }
}
