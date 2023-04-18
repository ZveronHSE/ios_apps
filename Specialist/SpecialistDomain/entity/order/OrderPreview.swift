//
//  OrderPreview.swift
//  SpecialistDomain
//
//  Created by alexander on 27.03.2023.
//

import Foundation

public struct OrderPreview {
    public let id: Int
    public let animal: OrderAnimalPreview
    public let title: String
    public let price: String
    public let address: OrderAddress
    public let serviceDate: String
    public let createdDate: String

    public init(
        id: Int,
        animal: OrderAnimalPreview,
        title: String,
        price: String,
        address: OrderAddress,
        serviceDate: String,
        createdDate: String
    ) {
        self.id = id
        self.animal = animal
        self.title = title
        self.price = price
        self.address = address
        self.serviceDate = serviceDate
        self.createdDate = createdDate
    }
}
