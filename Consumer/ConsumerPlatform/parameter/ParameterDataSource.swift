//
//  ParameterDataSource.swift
//  Platform
//
//  Created by alexander on 18.03.2023.
//

import Foundation
import ConsumerDomain
import ParameterGRPC
import RxSwift
import ZveronNetwork
import SwiftProtobuf

public class ParameterRemoteDataSource: ParameterDataSourceProtocol {

    private let apigateway: Apigateway
    public init(with apigateway: Apigateway) {
        self.apigateway = apigateway
    }

    public func getRoot() -> RxSwift.Observable<ParameterGRPC.CategoryResponse> {
        fatalError("not implemented")
    }

    public func getChildren(request: Google_Protobuf_Int32Value) -> RxSwift.Observable<ParameterGRPC.CategoryResponse> {
        return apigateway.callWithRetry(returnType: CategoryResponse.self, requestBody: request, methodAlies: "categoryChildrenGet")
    }

    public func getLotForms(request: Google_Protobuf_Int32Value) -> RxSwift.Observable<ParameterGRPC.LotFormResponse> {
        return apigateway.callWithRetry(returnType: LotFormResponse.self, requestBody: request, methodAlies: "lotFormsGet")
    }

    public func getParameters(request: ParameterGRPC.ParameterRequest) -> RxSwift.Observable<ParameterGRPC.ParameterResponse> {
        return apigateway.callWithRetry(returnType: ParameterResponse.self, requestBody: request, methodAlies: "parametersGet")

    }
}
