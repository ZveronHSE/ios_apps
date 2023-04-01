//
//  LotUseCaseProtocol.swift
//  Domain
//
//  Created by alexander on 15.02.2023.
//

import Foundation
import RxSwift
import LotGRPC

public protocol LotDataSourceProtocol {

    // Получить список объявлений для ленты
    func getWaterfall(request: WaterfallRequest) -> Observable<WaterfallResponse>

    // Создать лот
    func createLot(lot: CreateLot) -> Observable<CardLot>

    // Редактировать лот
    func editLot(request: EditLotRequest) -> Observable<CardLot>

    // Закрыть лот
    func closeLot(request: CloseLotRequest) -> Observable<Void>

    // Получить информацию про объявление
    func getCardLot(request: CardLotRequest) -> Observable<CardLot>
}
