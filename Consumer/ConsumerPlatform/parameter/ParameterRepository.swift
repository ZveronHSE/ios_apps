//
//  ParameterRepository.swift
//  Platform
//
//  Created by alexander on 18.03.2023.
//

import Foundation
import ConsumerDomain
import RxSwift
import ParameterGRPC
import SwiftProtobuf

public class ParameterRepository: ParameterRepositoryProtocol {

    private let remote: ParameterDataSourceProtocol
    public init(with remote: ParameterDataSourceProtocol) {
        self.remote = remote
    }

    public func getRoot() -> RxSwift.Observable<[ParameterGRPC.Category]> {
        return remote.getRoot().map { $0.categories }
    }

    public func getChildren(categoryId: Int32) -> RxSwift.Observable<[ParameterGRPC.Category]> {
        let request = Google_Protobuf_Int32Value.with { $0.value = categoryId }
        return remote.getChildren(request: request).map { $0.categories }
    }

    public func getLotForms(categoryId: Int32) -> RxSwift.Observable<[ParameterGRPC.LotForm]> {
        let request = Google_Protobuf_Int32Value.with { $0.value = categoryId }
        return remote.getLotForms(request: request).map { $0.lotForms }
    }

    public func getParameters(categoryId: Int32, lotFormId: Int32) -> RxSwift.Observable<[ParameterGRPC.Parameter]> {
        let request = ParameterRequest.with { $0.categoryID = categoryId; $0.lotFormID = lotFormId }
        return remote.getParameters(request: request).map { $0.parameters }
    }
}
