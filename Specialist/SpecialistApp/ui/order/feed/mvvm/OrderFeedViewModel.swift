//
//  OrderFeedViewModel.swift
//  SpecialistApp
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import RxSwift
import RxCocoa
import SpecialistDomain

final class OrderFeedViewModel: ViewModelType {
    private let usecase: OrderUseCaseProtocol
    private let navigator: OrderFeedNavigatorProtocol

    private let _items = BehaviorSubject<[OrderPreview]>(value: [])
    private var items: Driver<[OrderPreview]> {
        return _items.skip(1)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
    }

    init(
        with usecase: OrderUseCaseProtocol,
        and navigator: OrderFeedNavigatorProtocol
    ) {
        self.usecase = usecase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()

        let dataInitLoaded = input.initDataTrigger
            .flatMap { _ in
                self.usecase.getWaterfall(filters: [], sort: ._default, initData: true)
                .do(onNext: { self._items.onNext($0) })
                .trackError(errorTracker)
                .asDriverOnErrorJustReturnVoid()
        }

        let dataFetched = input.fetchDataTrigger.flatMap { _ in
            self.usecase.getWaterfall(filters: [], sort: ._default, initData: false)
                .do(onNext: { self._items.onNext((try? self._items.value())! + $0) })
                .trackError(errorTracker)
                .asDriverOnErrorJustReturnVoid()
        }

        let dataLoaded = Driver.merge(dataInitLoaded, dataFetched)

        let itemSelected = input.itemSelectTrigger.withLatestFrom(items) { indexPath, items in
            return items[indexPath.item].id
        }.flatMap { id in
            self.usecase.getOrder(by: id)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        }.do(onNext: navigator.toOrder).mapToVoid()

        let activityIndicatorStart = Driver.merge(
            input.initDataTrigger.mapToTrue(),
            input.fetchDataTrigger.mapToTrue(),
            input.itemSelectTrigger.mapToTrue()
        )

        let activityIndicatorEnd = Driver.merge(
            dataLoaded.mapToFalse(),
            itemSelected.mapToFalse(),
            errorTracker.mapToFalse()
        ).delay(.milliseconds(1))

        let activityIndicatorWithDebounce = Driver.merge(activityIndicatorStart, activityIndicatorEnd).debounce(.milliseconds(500))

        let activityIndicator = Driver.merge(activityIndicatorWithDebounce, activityIndicatorEnd).distinctUntilChanged()

        return .init(
            dataLoaded: dataLoaded.debug("data loaded", trimOutput: true),
            activityIndicator: activityIndicator.debug("activityIndicator", trimOutput: true),
            items: items.debug("items emitted", trimOutput: true),
            itemSelected: itemSelected.debug("item selected", trimOutput: true),
            errors: errorTracker.asDriver()
        )
    }
}

// MARK: ViewModel input/output
extension OrderFeedViewModel {

    struct Input {
        let initDataTrigger: Driver<Void>
        let fetchDataTrigger: Driver<Void>
        let itemSelectTrigger: Driver<IndexPath>
    }

    struct Output {
        let dataLoaded: Driver<Void>
        let activityIndicator: Driver<Bool>
        let items: Driver<[OrderPreview]>
        let itemSelected: Driver<Void>
        let errors: Driver<Error>
    }
}
