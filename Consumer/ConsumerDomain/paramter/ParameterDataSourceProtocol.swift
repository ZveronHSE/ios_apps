//
//  ParameterDataSource.swift
//  Domain
//
//  Created by alexander on 18.03.2023.
//

import Foundation
import ParameterGRPC
import RxSwift
import SwiftProtobuf

public protocol ParameterDataSourceProtocol {

    // Получить главные категории
    func getRoot() -> Observable<CategoryResponse>

    // Получить список подкатегорий для категории
    func getChildren(request: Google_Protobuf_Int32Value) -> Observable<CategoryResponse>

    // Получить список типов объявлений по ID рутовой категории
    func getLotForms(request: Google_Protobuf_Int32Value) -> Observable<LotFormResponse>

    // Получить список параметров для определенной категории и типа объявления.
    func getParameters(request: ParameterRequest) -> Observable<ParameterResponse>
}
