//
//  OrderUseCase.swift
//  SpecialistPlatform
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import SpecialistDomain
import RxSwift

public final class OrderUseCase: OrderUseCaseProtocol {
    private let repository: OrderRepositoryProtocol

    public init(with repository: OrderRepositoryProtocol) { self.repository = repository }

    public func getWaterfall(
        filters: [OrderFilter],
        sort: OrderSortingType,
        initData: Bool
    ) -> Observable<[OrderPreview]> {
        return repository.getWaterfall(filters: filters, sort: sort, initData: initData).mapErrors(default: OrderError.fetchError)
    }

    public func getOrder(by id: Int) -> RxSwift.Observable<SpecialistDomain.Order> {
        return repository.getOrder(by: id).mapErrors(default: OrderError.getError)
    }
}
