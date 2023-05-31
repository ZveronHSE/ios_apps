//
//  Order.swift
//  ConsumerDomain
//
//  Created by alexander on 12.05.2023.
//

import Foundation

public struct Order {
    public let animalId: Int
    public let title: String
    public let price: Int
    public let priceType: PriceType
    public let dateFrom: Date
    public let dateTo: Date
    public let timeFrom: Date
    public let timeTo: Date
    public let deliveryMethod: DeliveryType
    public let serviceType: ServiceType
    public let desc: String

    public init( animalId: Int, title: String, price: Int, priceType: PriceType, dateFrom: Date, dateTo: Date, timeFrom: Date, timeTo: Date, deliveryMethod: DeliveryType, serviceType: ServiceType, desc: String) {
        self.animalId = animalId
        self.title = title
        self.price = price
        self.priceType = priceType
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.timeFrom = timeFrom
        self.timeTo = timeTo
        self.deliveryMethod = deliveryMethod
        self.serviceType = serviceType
        self.desc = desc
    }
}
