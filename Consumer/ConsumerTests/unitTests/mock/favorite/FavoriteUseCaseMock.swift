//
//  FavoriteUseCaseMock.swift
//  iosappTests
//
//  Created by alexander on 14.03.2023.
//

import Foundation
import ConsumerDomain
import RxSwift
import LotGRPC
import FavoritesGRPC
import CoreGRPC

final class FavoriteUseCaseMock: FavoriteUseCaseProtocol {
    var removeLot_ReturnValue: Observable<Void> = Observable.just(Void())
    var removeLot_Called = false

    var getLotsByCategory1_ReturnValue: Observable<[CoreGRPC.Lot]> = Observable.just([])
    var getLotsByCategory2_ReturnValue: Observable<[CoreGRPC.Lot]> = Observable.just([])
    var getLotsByCategory1_Called = false
    var getLotsByCategory2_Called = false

    var removeProfile_ReturnValue: Observable<Void> = Observable.just(Void())
    var removeProfile_Called = false

    var getProfiles_ReturnValue: Observable<[ProfileSummary]> = Observable.just([])
    var getProfiles_Called = false

    var deleteCosedLotsByCategory_ReturnValue: Observable<Void> = Observable.just(Void())
    var deleteCosedLotsByCategory_Called = false

    var deleteAllLotsByCategory_ReturnValue: Observable<Void> = Observable.just(Void())
    var deleteAllLotsByCategory_Called = false

    var getCardLot_ReturnValue: Observable<CardLot> = Observable.just(CardLot())
    var getCardLot_ReturnIfId: Int64 = -1
    var getCardLot_Called = false

    // TODO: 
//    var getCardProfile_ReturnValue: Observable<CardLot> = Observable.just(CardLot())
//    var getCardProfile_ReturnIfId: Int64 = -1
//    var getCardProfile_Called = false

    func removeLot(with id: Int64) -> RxSwift.Observable<Void> {
        removeLot_Called = true
        return removeLot_ReturnValue
    }

    func getLotsByCategory(categoryId: Int32) -> RxSwift.Observable<[CoreGRPC.Lot]> {

        if categoryId == 1 {
            getLotsByCategory1_Called = true
            return getLotsByCategory1_ReturnValue
        }

        if categoryId == 2 {
            getLotsByCategory2_Called = true
            return getLotsByCategory2_ReturnValue
        }

        fatalError("unexpected testing categoryId")
    }

    func removeProfile(with id: Int64) -> RxSwift.Observable<Void> {
        removeProfile_Called = true
        return removeProfile_ReturnValue
    }

    func getProfiles() -> RxSwift.Observable<[FavoritesGRPC.ProfileSummary]> {
        getProfiles_Called = true
        return getProfiles_ReturnValue
    }

    func deleteCosedLotsByCategory(categoryId: Int32) -> RxSwift.Observable<Void> {
        deleteCosedLotsByCategory_Called = true
        return deleteCosedLotsByCategory_ReturnValue
    }

    func deleteAllLotsByCategory(categoryId: Int32) -> RxSwift.Observable<Void> {
        deleteAllLotsByCategory_Called = true
        return deleteAllLotsByCategory_ReturnValue
    }

    func getCardLot(lotId: Int64) -> RxSwift.Observable<LotGRPC.CardLot> {

        if getCardLot_ReturnIfId == lotId {
            getCardLot_Called = true
            return getCardLot_ReturnValue
        }

        return Observable.just(CardLot.with { $0.title = "undefind" })
    }
}
