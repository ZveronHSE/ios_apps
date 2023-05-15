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

    func asDriverOnErrorJustReturn(_ element: Element) -> Driver<Element> {
        return asDriver(onErrorJustReturn: element)
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }

    func asDriverOnErrorJustReturnVoid() -> Driver<Void> {
        return self.mapToVoid().asDriver(onErrorJustReturn: Void())
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }

    func mapToTrue() -> SharedSequence<SharingStrategy, Bool> {
        return map { _ in true }
    }

    func mapToFalse() -> SharedSequence<SharingStrategy, Bool> {
        return map { _ in false }
    }
}

final class ErrorTracker: SharedSequenceConvertibleType {

    typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }

    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    private func onError(_ error: Error) {
        _subject.onNext(error)
    }

    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {

    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}
