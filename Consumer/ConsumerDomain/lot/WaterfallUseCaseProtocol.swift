//
//  LotUseCaseProtocol.swift
//  Domain
//
//  Created by alexander on 12.02.2023.
//

import Foundation
import RxSwift
import LotGRPC
import CoreGRPC
import ParameterGRPC

// MARK: Класс взаимодействий на экране с объявлениями
public protocol WaterfallUseCaseProtocol {

    // Получить список объявлений для ленты
    func getWaterfall(
        pageSize: Int32,
        query: String?,
        categoryId: Int32?,
        filters: [Filter],
        modelParameters: [LotGRPC.Parameter],
        sortingMode: Sort
    ) -> Observable<([CoreGRPC.Lot],LastLot)>

    // Получить информацию про объявление
    func getCardLot(byId id: Int64) -> Observable<CardLot>

    // Добавление объявления в избранное пользователя
    func addLot(with id: Int64) -> Observable<Void>

    // Удаление объявления из избранного пользователя
    func removeLot(with id: Int64) -> Observable<Void>

    func getChildrenCategories(byParrent id: Int32) -> Observable<[ParameterGRPC.Category]>

    func getLotForms(byCategory id: Int32) -> RxSwift.Observable<[ParameterGRPC.LotForm]>

    func getParameters(byCategory categoryId: Int32, andLotForm lotFormId: Int32) -> Observable<[ParameterGRPC.Parameter]>
}
