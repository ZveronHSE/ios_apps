//
//  OrderAnimalPreview.swift
//  SpecialistDomain
//
//  Created by alexander on 17.04.2023.
//

import Foundation

public struct OrderAnimalPreview {
    public let id: Int
    public let name: String
    public let breed: String
    public let species: String
    public let imageUrl: URL

    public init(
        id: Int,
        name: String,
        breed: String,
        species: String,
        imageUrl: URL
    ) {
        self.id = id
        self.name = name
        self.breed = breed
        self.species = species
        self.imageUrl = imageUrl
    }
}
