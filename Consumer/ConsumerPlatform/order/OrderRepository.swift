//
//  OrderRepository.swift
//  ConsumerPlatform
//
//  Created by alexander on 12.05.2023.
//

import Foundation
import RxSwift
import ConsumerDomain

public class OrderRepository: OrderRepositoryProtocol {
    private let ds: OrderDataSourceProtocol

    public init(ds: OrderDataSourceProtocol) {
        self.ds = ds
    }

    public func getCreatedOrders(type: OrderType) -> RxSwift.Observable<[ConsumerDomain.OrderPreview]> {
        return ds.getCreatedOrders(type: type)
    }
    
    public func getCreatedOrder(by id: Int) -> RxSwift.Observable<ConsumerDomain.Order> {
        return ds.getCreatedOrder(by: id)
    }
    
    public func createOrder(_ order: ConsumerDomain.Order) -> RxSwift.Observable<Void> {
        return ds.createOrder(order)
    }
}
