//
//  ServiceType.swift
//  ConsumerDomain
//
//  Created by alexander on 22.05.2023.
//

import Foundation

public enum ServiceType: String, CaseIterable {
    case walk = "Выгул"
    case grooming = "Груминг"
    case training = "Дрессировка"
    case boarding = "Перевозка"
    case sitting = "Передержка"
    case other = "Другое"
}
