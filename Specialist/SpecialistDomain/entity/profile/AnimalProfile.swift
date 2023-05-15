//
//  AnimalProfile.swift
//  SpecialistDomain
//
//  Created by alexander on 18.04.2023.
//

import Foundation

public struct AnimalProfile {
    public let id: Int
    public let name: String
    public let breed: String
    public let species: String
    public let age: String
    public let imageUrls: [URL]
    public let documents: [AnimalDocument]

    public init(
        id: Int,
        name: String,
        breed: String,
        species: String,
        age: String,
        imageUrls: [URL],
        documents: [AnimalDocument]
    ) {
        self.id = id
        self.name = name
        self.breed = breed
        self.species = species
        self.age = age
        self.imageUrls = imageUrls
        self.documents = documents
    }
}
