//
//  OrderError.swift
//  ConsumerDomain
//
//  Created by alexander on 12.05.2023.
//

import Foundation
public enum OrderError: Error {
    case failedLoadCreatedOrders
    case failedCreateOrder
}

extension OrderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedCreateOrder: return NSLocalizedString("Ошибка при создании заказа. Попробуй еще раз", comment: "")
        case .failedLoadCreatedOrders: return NSLocalizedString("Ошибка при загрузке созданных заказов.", comment: "")
        default: return NSLocalizedString("", comment: "")
        }
    }
}
