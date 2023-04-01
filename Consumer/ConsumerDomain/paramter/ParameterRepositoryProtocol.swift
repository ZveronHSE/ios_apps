//
//  ParameterRepositoryProtocol.swift
//  Domain
//
//  Created by alexander on 18.03.2023.
//

import Foundation
import ParameterGRPC
import RxSwift

public protocol ParameterRepositoryProtocol {

    // Получить главные категории
    func getRoot() -> Observable<[ParameterGRPC.Category]>

    // Получить список подкатегорий для категории
    func getChildren(categoryId: Int32) -> Observable<[ParameterGRPC.Category]>

    // Получить список типов объявлений по ID рутовой категории
    func getLotForms(categoryId: Int32) -> Observable<[ParameterGRPC.LotForm]>

    // Получить список параметров для определенной категории и типа объявления.
    func getParameters(categoryId: Int32, lotFormId: Int32) -> Observable<[ParameterGRPC.Parameter]>
}
