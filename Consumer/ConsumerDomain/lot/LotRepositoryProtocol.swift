//
//  LotRepositoryProtocol.swift
//  Domain
//
//  Created by alexander on 15.02.2023.
//

import Foundation
import RxSwift
import LotGRPC
import CoreGRPC

public protocol LotRepositoryProtocol {

    // Получить список объявлений для ленты
    func getWaterfall(
        pageSize: Int32,
        query: String?,
        categoryId: Int32?,
        filters: [Filter],
        modelParameters: [Parameter],
        sortingMode: Sort
    ) -> Observable<([CoreGRPC.Lot], LotGRPC.LastLot)>

    // Создать лот
    func createLot(lot: CreateLot) -> Observable<CardLot>

    // Редактировать лот
    func editLot(request: EditLotRequest) -> Observable<CardLot>

    // Закрыть лот
    func closeLot(request: CloseLotRequest) -> Observable<Void>

    // Получить информацию про объявление
    func getCardLot(byId: Int64) -> Observable<CardLot>
}
