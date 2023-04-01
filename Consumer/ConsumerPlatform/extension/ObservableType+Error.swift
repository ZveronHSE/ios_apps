//
//  ObservableType+Error.swift
//  Platform
//
//  Created by alexander on 15.02.2023.
//

import Foundation
import RxSwift
import GRPC
import ZveronNetwork
import ConsumerDomain

internal extension ObservableType {
    typealias ErrorMapper = (networkError: NetworkError, error: Error)

    func mapErrors(with mappers: [ErrorMapper]? = nil, default defaultError: Error = BasicError.unexpected) -> Observable<Element> {
        self.catch { error in
            guard let error = error as? NetworkError else { fatalError("Mismatch exception: \(error)") }

            let uiError = mappers?.first { $0.networkError == error }?.error ?? defaultError

            return Observable.error(uiError)
        }
    }
}
