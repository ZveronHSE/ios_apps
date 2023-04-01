//
//  LotRepository.swift
//  Platform
//
//  Created by alexander on 15.02.2023.
//

import Foundation
import ConsumerDomain
import RxSwift
import LotGRPC
import CoreGRPC

public final class LotRepository: LotRepositoryProtocol {
    private let remote: LotDataSourceProtocol

    public init(remote: LotDataSourceProtocol) {
        self.remote = remote
    }

    public func getWaterfall(
        pageSize: Int32,
        query: String?,
        categoryId: Int32?,
        filters: [Filter],
        modelParameters: [Parameter],
        sortingMode: LotGRPC.Sort
    ) -> Observable<([CoreGRPC.Lot], LotGRPC.LastLot)> {
        var request = WaterfallRequest.with {
            $0.pageSize = pageSize
            $0.filters = filters
            $0.parameters = modelParameters
            $0.sort = sortingMode
        }
        query.flatMap { request.query = $0 }
        categoryId.flatMap { request.categoryID = $0 }

        return remote.getWaterfall(request: request).map { ($0.lots, $0.lastLot) }
    }

    public func createLot(lot: CreateLot) -> Observable<CardLot> {
        return remote.createLot(lot: lot)
    }

    public func editLot(request: EditLotRequest) -> Observable<CardLot> {
        fatalError("not implemented")
    }

    public func closeLot(request: CloseLotRequest) -> Observable<Void> {
        fatalError("not implemented")
    }

    public func getCardLot(byId id: Int64) -> Observable<CardLot> {
        let request = CardLotRequest.with { $0.id = id }
        return remote.getCardLot(request: request)
    }
}
