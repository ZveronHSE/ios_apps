//
//  Animal.swift
//  ConsumerDomain
//
//  Created by alexander on 23.05.2023.
//

import Foundation

public struct Animal {
    public let id: Int
    public let name: String
    public let breed: String
    public let species: String
    public let age: Int
    public let imageUrl: URL

    public init(
        id: Int,
        name: String,
        breed: String,
        species: String,
        age: Int,
        imageUrl: URL
    ) {
        self.id = id
        self.name = name
        self.breed = breed
        self.species = species
        self.age = age
        self.imageUrl = imageUrl
    }
}
