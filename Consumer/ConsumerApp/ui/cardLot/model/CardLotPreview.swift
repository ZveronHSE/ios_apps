//
//  CardLotPreview.swift
//  iosapp
//
//  Created by Никита Ткаченко on 15.05.2022.
//

import Foundation
import UIKit

struct CardLotPreview {
    var id: Int
    var photos: [CardLotPhoto]
    var title: String
    var gender: String?
    var address: CardLotAddress
    var statics: Statics
    var parameters: [CardLotParameters]
    var description: String
    var seller: Seller?
    var price: Int
    var contact: ContactWays?
    var isFavoriteLot: Bool
    var isOwnLot: Bool
    var canAddReview: Bool
}

//extension CardLotPreview {
//    // (4) Описываем CodingKeys для парсера.
//    enum CodingKeys: String, CodingKey {
//        case id
//        case photos
//        case title
//        case gender
//        case address
//        case statics
//        //var parameters: [CardLotParameters]
//        case description
//        case seller
//        case price
//        case contact
//        case isFavoriteLot
//        case isOwnLot
//        case canAddReview
//        // (5) Здесь определяем только те имена ключей, которые будут нужны нам внутри контейнера photos.
//        // (6) Здесь необязательно соблюдать какие-то правила именования, но название PhotosKeys - дает представление о том, что мы рассматриваем ключи внутри значения ключа photos
////        enum PhotosKeys: String, CodingKey {
////            // (7) Описываем конкретно интересующий нас ключ "photo"
////            case photoKey = "photo"
////        }
//    }
//    // (8) Дальше переопределяем инициализатор
//    init(from decoder: Decoder) throws {
//        // (9) Заходим внутрь JSON, который определяется контейнером из двух ключей, но нам из них нужно только одно - photos
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        // (10) Заходим в контейнер (nested - вложенный) ключа photos и говорим какие именно ключи смы будем там рассматривать
//        //let photosContainer = try container.nestedContainer(keyedBy: CodingKeys.PhotosKeys.self, forKey: .photos)
//        // (11) Декодируем уже стандартным методом
//        // (12) Дословно здесь написано следующее положи в свойство photos объект-массив, который определен своим типом и лежит .photoKey (.photoKey.rawValue == "photo")
//        photos = try container.decode([CardLotPhoto].self, forKey: CodingKeys.photos)
//        id = try container.decode(Int.self, forKey: CodingKeys.id)
//        title = try container.decode(String.self, forKey: CodingKeys.title)
//        gender = try container.decode(String.self, forKey: CodingKeys.gender)
//        address = try container.decode(CardLotAddress.self, forKey: CodingKeys.address)
//        statics = try container.decode(Statics.self, forKey: CodingKeys.statics)
//        description = try container.decode(String.self, forKey: CodingKeys.description)
//        seller = try container.decode(Seller.self, forKey: CodingKeys.seller)
//        price = try container.decode(Int.self, forKey: CodingKeys.price)
//        contact = try container.decode(ContactWays.self, forKey: CodingKeys.contact)
//        isFavoriteLot = try container.decode(Bool.self, forKey: CodingKeys.isFavoriteLot)
//        isOwnLot = try container.decode(Bool.self, forKey: CodingKeys.isOwnLot)
//        canAddReview = try container.decode(Bool.self, forKey: CodingKeys.canAddReview)
//    }
//}
