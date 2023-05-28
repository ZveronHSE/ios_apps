//
//  FavoriteUseCase.swift
//  Platform
//
//  Created by alexander on 04.03.2023.
//

import Foundation
import RxSwift
import ConsumerDomain
import FavoritesGRPC
import LotGRPC
import CoreGRPC

public final class FavoriteUseCase: FavoriteUseCaseProtocol {
    private let favoriteRepository: FavoriteRepositoryProtocol
    private let lotRepository: LotRepositoryProtocol

    public init(with favoriteRepository: FavoriteRepositoryProtocol, and lotRepository: LotRepositoryProtocol) {
        self.favoriteRepository = favoriteRepository
        self.lotRepository = lotRepository
    }

    public func removeLot(with id: Int64) -> Observable<Void> {
        return favoriteRepository.removeLot(with: id)
            .mapErrors(default: FavoriteError.failedRemoveItem)
    }

    public func getLotsByCategory(categoryId: Int32) -> Observable<[Lot]> {
        return favoriteRepository.getLotsByCategory(categoryId: categoryId)
            .mapErrors(default: FavoriteError.failedLoad)
    }

    public func removeProfile(with id: Int64) -> Observable<Void> {
        return favoriteRepository.removeProfile(with: id)
            .mapErrors(default: FavoriteError.failedRemoveItem)
    }

    public func getProfiles() -> Observable<[FavoritesGRPC.ProfileSummary]> {
        return favoriteRepository.getProfiles()
            .mapErrors(default: FavoriteError.failedLoad)
    }

    public func deleteCosedLotsByCategory(categoryId: Int32) -> Observable<Void> {
        return favoriteRepository.deleteLotsByStatusAndCategory(categoryId: categoryId, status: .closed)
            .mapErrors(default: FavoriteError.failedRemoveClosedItems)
    }

    public func deleteAllLotsByCategory(categoryId: Int32) -> Observable<Void> {
        return favoriteRepository.deleteAllLotsByCategory(categoryId: categoryId)
            .mapErrors(default: FavoriteError.failedRemoveAllItems)
    }

    public func getCardLot(lotId: Int64) -> Observable<CardLot> {
        return lotRepository.getCardLot(byId: lotId)
            .mapErrors(default: FavoriteError.failedLoadCurrentLot)
    }
}
