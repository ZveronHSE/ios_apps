//
//  CategoryType.swift
//  iosapp
//
//  Created by alexander on 03.05.2022.
//

import Foundation
import SwiftUI
import ParameterGRPC

public enum CategoryType: String, CaseIterable {
    case animal = "Животные"
    case goods = "Товары"

    static func parseType(_ name: String) -> CategoryType {
        guard let type = CategoryType.init(rawValue: name) else {
            fatalError("")
        }
        return type
    }

    func getModel() -> ParameterGRPC.Category {
        switch self {
        case .animal: return ParameterGRPC.Category.with { $0.id = 1; $0.name = self.rawValue }
        case .goods: return ParameterGRPC.Category.with { $0.id = 2; $0.name = self.rawValue }
        }
    }
}
