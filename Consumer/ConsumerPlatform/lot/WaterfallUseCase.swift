//
//  LotUseCase.swift
//  Platform
//
//  Created by alexander on 12.02.2023.
//

import Foundation
import RxSwift
import LotGRPC
import ConsumerDomain
import CoreGRPC
import ParameterGRPC

public final class WaterfallUseCase: WaterfallUseCaseProtocol {

    private let lotRepository: LotRepositoryProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol
    private let parameterRepository: ParameterRepositoryProtocol

    public init(
        with lotRepository: LotRepositoryProtocol,
        and favoriteRepository: FavoriteRepositoryProtocol,
        and parameterRepository: ParameterRepositoryProtocol
    ) {
        self.lotRepository = lotRepository
        self.favoriteRepository = favoriteRepository
        self.parameterRepository = parameterRepository
    }

    public func getWaterfall(
        pageSize: Int32,
        query: String?,
        categoryId: Int32?,
        filters: [Filter],
        modelParameters: [LotGRPC.Parameter],
        sortingMode: Sort
    ) -> Observable<([CoreGRPC.Lot], LastLot)> {
        return lotRepository.getWaterfall(
            pageSize: pageSize,
            query: query,
            categoryId: categoryId,
            filters: filters,
            modelParameters: modelParameters,
            sortingMode: sortingMode
        )
    }

    public func getCardLot(byId id: Int64) -> Observable<CardLot> {
        return lotRepository.getCardLot(byId: id)
    }

    public func addLot(with id: Int64) -> Observable<Void> {
        return favoriteRepository.addLot(with: id)
    }

    public func removeLot(with id: Int64) -> Observable<Void> {
        return favoriteRepository.removeLot(with: id)
    }

    public func getChildrenCategories(byParrent id: Int32) -> Observable<[ParameterGRPC.Category]> {
        return parameterRepository.getChildren(categoryId: id)
    }

    public func getLotForms(byCategory id: Int32) -> RxSwift.Observable<[ParameterGRPC.LotForm]> {
        return parameterRepository.getLotForms(categoryId: id)
    }

    public func getParameters(byCategory categoryId: Int32, andLotForm lotFormId: Int32) -> Observable<[ParameterGRPC.Parameter]> {
        return parameterRepository.getParameters(categoryId: categoryId, lotFormId: lotFormId)
    }
}
