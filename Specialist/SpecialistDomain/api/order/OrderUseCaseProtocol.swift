//
//  OrderUseCaseProtocol.swift
//  SpecialistDomain
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import RxSwift

public protocol OrderUseCaseProtocol {

    func getWaterfall(
        filters: [OrderFilter],
        sort: OrderSortingType,
        initData: Bool
    ) -> Observable<[OrderPreview]>

    func getOrder(by id: Int) -> Observable<Order>
}
