//
//  OrderPreview.swift
//  SpecialistDomain
//
//  Created by alexander on 27.03.2023.
//

import Foundation

public struct OrderPreview {
    public let title: String
    public let price: String
    public let city: String
    public let metroStation: String
    public let metroColor: String
    public let orderPeriod: String
    public let publishDate: String
    public let animalName: String
    public let animalDesciption: String
    public let animalImageLink: String

    public init(
        title: String,
        price: String,
        city: String,
        metroStation: String,
        metroColor: String,
        orderPeriod: String,
        publishDate: String,
        animalName: String,
        animalDesciption: String,
        animalImageLink: String
    ) {
        self.title = title
        self.price = price
        self.city = city
        self.metroStation = metroStation
        self.metroColor = metroColor
        self.orderPeriod = orderPeriod
        self.publishDate = publishDate
        self.animalName = animalName
        self.animalDesciption = animalDesciption
        self.animalImageLink = animalImageLink
    }
}
