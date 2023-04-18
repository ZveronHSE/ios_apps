//
//  AnimalProfileDocument.swift
//  SpecialistDomain
//
//  Created by alexander on 18.04.2023.
//

import Foundation

public struct AnimalDocument {
    public let name: String
    public let url: URL

    public init(
        name: String,
        url: URL
    ) {
        self.name = name
        self.url = url
    }
}
