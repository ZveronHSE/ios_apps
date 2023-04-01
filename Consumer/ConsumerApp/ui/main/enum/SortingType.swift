//
//  SortingType.swift
//  iosapp
//
//  Created by alexander on 02.05.2022.
//

import Foundation

public enum SortingType: String, CaseIterable {
    case popularity = "По дате публикации"
    case cheap = "Дешевые"
    case expensive = "Дорогие"
    case near = "Рядом с вами"
    case sellerRating = "С высоким рейтингом"

    static func parseType(_ name: String) -> SortingType {
        guard let type = SortingType.init(rawValue: name) else {
            fatalError("")
        }
        return type
    }

    func toBackendParam() -> String {
        switch self {
        case .popularity: return "date_creation<<"
        case .expensive: return "price<<"
        case .cheap: return "price>>"
        case .near: return ""
        case .sellerRating: return ""
        }
    }


}
