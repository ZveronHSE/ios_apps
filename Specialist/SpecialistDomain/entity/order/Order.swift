//
//  Order.swift
//  SpecialistDomain
//
//  Created by alexander on 29.03.2023.
//

import Foundation

public struct Order {
    public let id: Int
    public let customerPreview: OrderCustomerPreview
    public let animalPreview: OrderAnimalPreview
    public let title: String
    public let price: String
    public let createdDate: String
    public let address: OrderAddress
    public let serviceDate: String
    public let serviceTime: String
    public let description: String
    public let similarOrders: [OrderPreview]
    public let availableResponse: Bool

    public init(
        id: Int,
        customerPreview: OrderCustomerPreview,
        animalPreview: OrderAnimalPreview,
        title: String,
        price: String,
        createdDate: String,
        address: OrderAddress,
        serviceDate: String,
        serviceTime: String,
        description: String,
        similarOrders: [OrderPreview],
        availableResponse: Bool
    ) {
        self.id = id
        self.customerPreview = customerPreview
        self.animalPreview = animalPreview
        self.title = title
        self.price = price
        self.createdDate = createdDate
        self.address = address
        self.serviceDate = serviceDate
        self.serviceTime = serviceTime
        self.description = description
        self.similarOrders = similarOrders
        self.availableResponse = availableResponse
    }
}
