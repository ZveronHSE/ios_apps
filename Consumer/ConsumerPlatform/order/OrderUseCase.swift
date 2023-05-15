//
//  OrderUseCase.swift
//  ConsumerPlatform
//
//  Created by alexander on 12.05.2023.
//

import Foundation
import RxSwift
import ConsumerDomain

public class OrderUseCase: OrderUseCaseProtocol {
    private let rep: OrderRepositoryProtocol

    public init(rep: OrderRepositoryProtocol) {
        self.rep = rep
    }

    public func getCreatedOrders(type: OrderType) -> RxSwift.Observable<[ConsumerDomain.OrderPreview]> {
        return rep.getCreatedOrders(type: type).mapErrors(default: OrderError.failedLoadCreatedOrders)
    }

    public func getCreatedOrder(by id: Int) -> RxSwift.Observable<ConsumerDomain.Order> {
        return rep.getCreatedOrder(by: id)
    }

    public func createOrder(_ order: ConsumerDomain.Order) -> RxSwift.Observable<Void> {
        return rep.createOrder(order).mapErrors(default: OrderError.failedCreateOrder)
    }
}
