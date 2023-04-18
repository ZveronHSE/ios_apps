//
//  OrderDataSourceProtocol.swift
//  SpecialistDomain
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import RxSwift

public protocol OrderDataSourceProtocol {

    func getWaterfall(
        size: Int,
        lastOrderId: Int?,
        filters: [OrderFilter],
        sort: OrderSortingType
    ) -> Observable<[OrderPreview]>

    func getOrder(by id: Int) -> Observable<Order>
}
