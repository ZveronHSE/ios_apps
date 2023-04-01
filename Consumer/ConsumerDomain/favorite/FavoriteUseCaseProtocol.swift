//
// Created by alexander on 20.02.2023.
//

import Foundation
import RxSwift
import FavoritesGRPC
import LotGRPC
import CoreGRPC

// MARK: Класс взаимодействий на экране избранного
public protocol FavoriteUseCaseProtocol {

    // Удаление объявления из избранного пользователя
    func removeLot(with id: Int64) -> Observable<Void>

    // Получение списка избранных объявлений пользователя
    func getLotsByCategory(categoryId: Int32) -> Observable<[Lot]>

    // Удаление профиля из избранного пользователя
    func removeProfile(with id: Int64) -> Observable<Void>

    // Получение списка избранных профилей пользователя
    func getProfiles() -> Observable<[ProfileSummary]>

    // Удаление всех объявлений с определенным статусом из категории
    func deleteCosedLotsByCategory(categoryId: Int32) -> Observable<Void>

    // Удаление всех объявлений из категории
    func deleteAllLotsByCategory(categoryId: Int32) -> Observable<Void>

    // Получить информацию про объявление
    func getCardLot(lotId: Int64) -> Observable<CardLot>
}
