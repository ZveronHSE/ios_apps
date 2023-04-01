//
//  FavoriteRepository.swift
//  Platform
//
//  Created by alexander on 04.03.2023.
//

import Foundation
import ConsumerDomain
import FavoritesGRPC
import RxSwift
import CoreGRPC

public final class FavoriteRepository: FavoriteRepositoryProtocol {

    private let remote: FavoriteDataSourceProtocol

    public init(remote: FavoriteDataSourceProtocol) { self.remote = remote }

    public func addLot(with id: Int64) -> Observable<Void> {
        let request = AddLotToFavoritesRequest.with { $0.id = id }
        return remote.addLot(request: request)
    }

    public func removeLot(with id: Int64) -> Observable<Void> {
        let request = RemoveLotFromFavoritesRequest.with { $0.id = id }
        return remote.removeLot(request: request)
    }

    public func getLotsByCategory(categoryId: Int32) -> Observable<[Lot]> {
        let request = GetFavoriteLotsRequest.with { $0.categoryID = Int32(categoryId) }
        return remote.getLotsByCategory(request: request).map { $0.favoriteLots }
    }

    public func addProfile(with id: Int64) -> Observable<Void> {
        let request = AddProfileToFavoritesRequest.with { $0.id = id }
        return remote.addProfile(request: request)
    }

    public func removeProfile(with id: Int64) -> Observable<Void> {
        let request = RemoveProfileFromFavoritesRequest.with { $0.id = id }
        return remote.removeProfile(request: request)
    }

    public func getProfiles() -> Observable<[ProfileSummary]> {
        return remote.getProfiles().map { $0.favoriteProfiles }
    }

    public func deleteLotsByStatusAndCategory(categoryId: Int32, status: Status) -> Observable<Void> {
        let request = DeleteAllByStatusAndCategoryRequest.with {
            $0.categoryID = categoryId
            $0.status = status
        }
        return remote.deleteLotsByStatusAndCategory(request: request)
    }

    public func deleteAllLotsByCategory(categoryId: Int32) -> Observable<Void> {
        let request = DeleteAllByCategoryRequest.with { $0.categoryID = categoryId }
        return remote.deleteAllLotsByCategory(request: request)
    }
}
