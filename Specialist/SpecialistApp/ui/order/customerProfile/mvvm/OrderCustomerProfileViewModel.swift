//
//  OrderCustomerProfileViewModel.swift
//  SpecialistApp
//
//  Created by alexander on 19.04.2023.
//

import Foundation
import SpecialistDomain
import RxCocoa
import RxSwift

final class OrderCustomerProfileViewModel: ViewModelType {
    private let usecase: OrderUseCaseProtocol
    private let navigator: OrderCustomerProfileNavigatorProtocol
    let model: CustomerProfile

    init(
        with usecase: OrderUseCaseProtocol,
        and navigator: OrderCustomerProfileNavigatorProtocol,
        and model: CustomerProfile
    ) {
        self.usecase = usecase
        self.navigator = navigator
        self.model = model
    }

    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let backClicked = input.backClickTrigger.do(onNext: navigator.toBack)

        let items: Driver<[OrderPreview]> = input.sourceSelectTrigger.map { sourceType in
            let resultItems: [OrderPreview]!
            switch sourceType {
            case .actived: resultItems = self.model.activeOrders
            case .closed: resultItems = self.model.closedOrders
            }
            return resultItems
        }

        let itemSelected = input.itemSelectTrigger.withLatestFrom(input.sourceSelectTrigger) { indexPath, sourceType in
            switch sourceType {
            case .actived: return self.model.activeOrders[indexPath.item].id
            case .closed: return self.model.closedOrders[indexPath.item].id
            }
        }.flatMap { orderId in
            return self.usecase.getOrder(by: orderId)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        }.do(onNext: navigator.toOrder).mapToVoid()

        let activityIndicatorStart = Driver.merge(
            input.itemSelectTrigger.mapToTrue()
        )

        let activityIndicatorEnd = Driver.merge(
            itemSelected.mapToFalse(),
            errorTracker.mapToFalse()
        ).delay(.milliseconds(1))

        let activityIndicatorWithDebounce = Driver.merge(activityIndicatorStart, activityIndicatorEnd).debounce(.milliseconds(500))

        let activityIndicator = Driver.merge(activityIndicatorWithDebounce, activityIndicatorEnd).distinctUntilChanged()

        return .init(
            backClicked: backClicked.debug("back clicked", trimOutput: true),
            items: items.debug("items", trimOutput: true),
            itemSelected: itemSelected.debug("item selected", trimOutput: true),
            activityIndicator: activityIndicator.debug("activity indicator", trimOutput: true),
            errors: errorTracker.asDriver()
        )
    }
}

extension OrderCustomerProfileViewModel {
    struct Input { 
        let backClickTrigger: Driver<Void>
        let sourceSelectTrigger: Driver<ProfileFeedSource>
        let itemSelectTrigger: Driver<IndexPath>
    }

    struct Output {
        let backClicked: Driver<Void>
        let items: Driver<[OrderPreview]>
        let itemSelected: Driver<Void>
        let activityIndicator: Driver<Bool>
        let errors: Driver<Error>
    }
}
