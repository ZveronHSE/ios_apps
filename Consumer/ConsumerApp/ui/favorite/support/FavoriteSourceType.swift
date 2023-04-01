//
//  FavoriteSourceType.swift
//  iosapp
//
//  Created by alexander on 06.03.2023.
//

import Foundation

public enum FavoriteSourceType: String, CaseIterable {
    case animal
    case goods
    case vendor

    func getCategoryId() -> Int32 {
        switch self {
        case .animal: return 1
        case .goods: return 2
        case .vendor: fatalError("vendor has not identifier")
        }
    }

    func getUIDesc() -> String {
        switch self {
        case .animal: return "Животные"
        case .goods: return "Товары для животных"
        case .vendor: return "Продавцы"
        }
    }
}
