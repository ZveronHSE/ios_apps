//
//  Observable+Ext.swift
//  iosapp
//
//  Created by alexander on 19.02.2023.
//

import Foundation
import RxSwift
import RxCocoa
import ZveronNetwork
import UIKit

extension ObservableType {

    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }

    // Проверяет состояние авторизации пользователя
    // если пользователь авторизован то продолжает реактивную цепь
    // если пользователь неавторизован, то запускает алерт по оповещению пользователя, а также производит процесс авторизации
    // приэтом реактивная цепь заканчивается и не продолжается
    func checkAuth(by presentationController: UIViewControllerWithAuth, with alertMessage: String) -> Observable<Element> {
        self.flatMap { element in
            return Observable<Element>.create { observer in
                switch TokenAcquisitionService.shared.authState {
                case .authorized, .needUpdateAccess: observer.onNext(element)
                default:
                    presentationController.presentAlert(
                        message: alertMessage,
                        style: .alert,
                        actions: [
                            UIViewController.AlertButton(
                                title: "Ок",
                                style: .cancel,
                                handler: { _ in presentationController.presentAutharization() }
                            )
                        ]
                    )
                }
                return Disposables.create()
            }
        }
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
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
