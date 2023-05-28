//
// Created by alexander on 20.02.2023.
//

import Foundation
import RxSwift
import FavoritesGRPC
import CoreGRPC

public protocol FavoriteRepositoryProtocol {

    // Добавление объявления в избранное пользователя
    func addLot(with id: Int64) -> Observable<Void>

    // Удаление объявления из избранного пользователя
    func removeLot(with id: Int64) -> Observable<Void>

    // Получение списка избранных объявлений пользователя
    func getLotsByCategory(categoryId: Int32) -> Observable<[Lot]>

    // Добавление профиля в избранное пользователя
    func addProfile(with id: Int64) -> Observable<Void>

    // Удаление профиля из избранного пользователя
    func removeProfile(with id: Int64) -> Observable<Void>

    // Получение списка избранных профилей пользователя
    func getProfiles() -> Observable<[FavoritesGRPC.ProfileSummary]>

    // Удаление всех объявлений с определенным статусом из категории
    func deleteLotsByStatusAndCategory(categoryId: Int32, status: Status) -> Observable<Void>

    // Удаление всех объявлений из категории
    func deleteAllLotsByCategory(categoryId: Int32) -> Observable<Void>
}
