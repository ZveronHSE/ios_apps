//
//  Observable+Ext.swift
//  SpecialistApp
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {

    func catchErrorJustComplete() -> Observable<Element> {
        return self.catch { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
