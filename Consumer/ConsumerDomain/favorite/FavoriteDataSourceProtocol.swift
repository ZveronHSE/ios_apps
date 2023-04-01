//
// Created by alexander on 20.02.2023.
//

import Foundation
import RxSwift
import FavoritesGRPC

public protocol FavoriteDataSourceProtocol {

    // Добавление объявления в избранное пользователя
    func addLot(request: AddLotToFavoritesRequest) -> Observable<Void>

    // Удаление объявления из избранного пользователя
    func removeLot(request: RemoveLotFromFavoritesRequest) -> Observable<Void>

    // Получение списка избранных объявлений пользователя
    func getLotsByCategory(request: GetFavoriteLotsRequest) -> Observable<GetFavoriteLotsResponse>

    // Добавление профиля в избранное пользователя
    func addProfile(request: AddProfileToFavoritesRequest) -> Observable<Void>

    // Удаление профиля из избранного пользователя
    func removeProfile(request: RemoveProfileFromFavoritesRequest) -> Observable<Void>

    // Получение списка избранных профилей пользователя
    func getProfiles() -> Observable<GetFavoriteProfilesResponse>

    // Удаление всех объявлений с определенным статусом из категории
    func deleteLotsByStatusAndCategory(request: DeleteAllByStatusAndCategoryRequest) -> Observable<Void>

    // Удаление всех объявлений из категории
    func deleteAllLotsByCategory(request: DeleteAllByCategoryRequest) -> Observable<Void>
}

