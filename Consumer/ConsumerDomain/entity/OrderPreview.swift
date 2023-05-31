//
//  OrderPreview.swift
//  ConsumerDomain
//
//  Created by alexander on 12.05.2023.
//

import Foundation

public struct OrderPreview {
    public let id: Int
    public let title: String
    public let price: String
    public let createdAt: String
    public let imageUrl: URL

    public init(
        id: Int,
        title: String,
        price: String,
        createdAt: String,
        imageUrl: URL
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.createdAt = createdAt
        self.imageUrl = imageUrl
    }
}
