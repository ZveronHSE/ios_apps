//
//  DeliveryType.swift
//  ConsumerDomain
//
//  Created by alexander on 23.05.2023.
//

import Foundation

public enum DeliveryType: String, CaseIterable {
    case home = "Есть"
    case notHome = "Нет"
    case unnecessary = "Не важно"
}
