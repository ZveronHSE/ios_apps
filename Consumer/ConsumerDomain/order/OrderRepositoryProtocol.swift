//
//  OrderRepositoryProtocol.swift
//  ConsumerDomain
//
//  Created by alexander on 12.05.2023.
//

import Foundation
import RxSwift

// MARK: Класс взаимодействий на экране профиля
public protocol OrderRepositoryProtocol {

    func getCreatedOrders(type: OrderType) -> Observable<[OrderPreview]>

    func getCreatedOrder(by id: Int) -> Observable<Order>

    func createOrder(_ order: Order) -> Observable<Void>
}
