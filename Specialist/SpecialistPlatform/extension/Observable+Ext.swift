//
//  Observable+Ext.swift
//  SpecialistPlatform
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import RxSwift
import GRPC
import ZveronNetwork
import SpecialistDomain

extension ObservableType {
    typealias ErrorMapper = (networkError: NetworkError, error: Error)

    func mapErrors(with mappers: [ErrorMapper]? = nil, default defaultError: Error = BasicError.unexpected) -> Observable<Element> {
        self.catch { error in
            guard let error = error as? NetworkError else { fatalError("Mismatch exception: \(error)") }

            let uiError = mappers?.first { $0.networkError == error }?.error ?? defaultError

            return Observable.error(uiError)
        }
    }
}

extension ObservableType where Element: MapperProtocol {

    func parse() -> Observable<Self.Element.Model> {
        return self.map { $0.mapToModel() }
    }
}
