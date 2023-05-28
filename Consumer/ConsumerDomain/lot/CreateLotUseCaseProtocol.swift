//
//  CreateLotUseCaseProtocol.swift
//  Domain
//
//  Created by Nikita on 27.03.2023.
//

import Foundation
import RxSwift
import LotGRPC
import ParameterGRPC
import ObjectstorageGRPC
import CoreGRPC
// MARK: Класс взаимодействий при создании объявления
public protocol CreateLotUseCaseProtocol {
    

    func createLot(lot: CreateLot) -> Observable<CardLot>
    
    // Получить список типов объявлений по ID рутовой категории
    func getLotForms(categoryId: Int32) -> Observable<[LotForm]>

    // Получить список подкатегорий для категории
    func getChildren(categoryId: Int32) -> Observable<[ParameterGRPC.Category]>

    // Получить список параметров для определенной категории и типа объявления.
    func getParameters(categoryId: Int32, lotFormId: Int32) -> Observable<[ParameterGRPC.Parameter]>

    func uploadImage(image: Data, type: MimeType) -> Observable<String>
    
    func getOwnLots() -> Observable<([CoreGRPC.Lot], LotGRPC.LastLot)>
}
