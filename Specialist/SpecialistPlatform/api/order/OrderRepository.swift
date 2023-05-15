//
//  OrderRepository.swift
//  SpecialistPlatform
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import SpecialistDomain
import RxSwift
import ZveronSupport

public final class OrderRepository: OrderRepositoryProtocol {
    private let source: OrderDataSourceProtocol
    private var stashedLastOrderId: Int?
    private let cacheOrder = Cache<Int, Order>(entryLifetime: .minutes(value: 5))

    public init(with source: OrderDataSourceProtocol) { self.source = source }

    public func getWaterfall(
        filters: [OrderFilter],
        sort: OrderSortingType,
        initData: Bool
    ) -> Observable<[OrderPreview]> {
        if initData { stashedLastOrderId = nil }

        return source.getWaterfall(size: 30, lastOrderId: stashedLastOrderId, filters: filters, sort: sort)
            .do(onNext: { orders in
            guard let lastOrderId = orders.last?.id else { return }
            self.stashedLastOrderId = lastOrderId
        })
    }

    public func getOrder(by id: Int) -> Observable<Order> {
        return cacheOrder[id].flatMap { Observable.just($0) } ??
        source.getOrder(by: id).do(onNext: { self.cacheOrder[id] = $0 })
    }
}
