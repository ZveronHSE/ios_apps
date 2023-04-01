//
//  Lot.swift
//  Domain
//
//  Created by Nikita on 27.03.2023.
//

import Foundation

public struct CreateLot {

    public var title: String
    public var photos: [Photo]
    public var parameters: [Int32: String]
    public var description: String
    public var price: Int32
    public var communication_channel: [CommunicationChannel]
    public var gender: Gender?
    public var address: FullAddress
    public var lot_form_id: Int32
    public var category_id: Int32

    public init(title: String, photos: [Photo], parameters: [Int32 : String], description: String, price: Int32, communication_channel: [CommunicationChannel], gender: Gender? = nil, address: FullAddress, lot_form_id: Int32, category_id: Int32) {
        self.title = title
        self.photos = photos
        self.parameters = parameters
        self.description = description
        self.price = price
        self.communication_channel = communication_channel
        self.gender = gender
        self.address = address
        self.lot_form_id = lot_form_id
        self.category_id = category_id
    }
    
    public mutating func addParameters(key: Int32, value: String) {
        if let _ = parameters[key] {
            parameters[key]!.append(value)
        } else {
            parameters[key] = value
        }
    }

}
