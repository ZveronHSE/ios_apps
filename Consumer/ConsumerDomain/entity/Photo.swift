//
//  Photo.swift
//  Domain
//
//  Created by Nikita on 27.03.2023.
//

import Foundation

public struct Photo {

    public let url: String
    public let order: Int32

    public init(url: String, order: Int32) {
        self.url = url
        self.order = order
    }
}
