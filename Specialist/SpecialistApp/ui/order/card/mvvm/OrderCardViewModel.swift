//
//  OrderCardViewModel.swift
//  SpecialistApp
//
//  Created by alexander on 18.04.2023.
//

import Foundation
import RxSwift
import RxCocoa
import SpecialistDomain

final class OrderCardViewModel: ViewModelType {
    private let orderUsecase: OrderUseCaseProtocol
    private let profileUsecase: ProfileUseCaseProtocol
    private let navigator: OrderCardNavigatorProtocol
    let model: Order

    init(
        with orderUsecase: OrderUseCaseProtocol,
        and profileUsecase: ProfileUseCaseProtocol,
        and navigator: OrderCardNavigatorProtocol,
        and model: Order
    ) {
        self.orderUsecase = orderUsecase
        self.profileUsecase = profileUsecase
        self.navigator = navigator
        self.model = model
    }

    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let backClicked = input.backClickTrigger.do(onNext: navigator.toBack)

        let animalProfileClicked = input.animalProfileClickTrigger.flatMap { _ in
            let animalProfileId = self.model.animalPreview.id
            return self.profileUsecase
                .getAnimalProfile(by: animalProfileId)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        }.do(onNext: navigator.toAnimalProfile).mapToVoid()

        let customerProfileClicked = input.customerProfileClickTrigger.flatMap { _ in
            let customerProfileId = self.model.customerPreview.id
            return self.profileUsecase
                .getCustomerProfile(by: customerProfileId)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        }.do(onNext: navigator.toCustomerProfile).mapToVoid()

        let similarOrderClicked = input.similarOrderClickTrigger.flatMap { indexPath in
            let orderId = self.model.similarOrders[indexPath.item].id
            return self.orderUsecase
                .getOrder(by: orderId)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        }.do(onNext: navigator.toSimilarOrder).mapToVoid()

        let activityIndicatorStart = Driver.merge(
            input.animalProfileClickTrigger.mapToTrue(),
            input.customerProfileClickTrigger.mapToTrue(),
            input.similarOrderClickTrigger.mapToTrue()
        )

        let activityIndicatorEnd = Driver.merge(
            animalProfileClicked.mapToFalse(),
            customerProfileClicked.mapToFalse(),
            similarOrderClicked.mapToFalse(),
            errorTracker.mapToFalse()
        ).delay(.milliseconds(1))

        let activityIndicatorWithDebounce = Driver.merge(activityIndicatorStart, activityIndicatorEnd).debounce(.milliseconds(500))

        let activityIndicator = Driver.merge(activityIndicatorWithDebounce, activityIndicatorEnd).distinctUntilChanged()

        return .init(
            backClicked: backClicked.debug("back clicked", trimOutput: true),
            animalProfileClicked: animalProfileClicked.debug("animal profile clicked", trimOutput: true),
            customerProfileClicked: customerProfileClicked.debug("customer profile clicked", trimOutput: true),
            similarOrderClicked: similarOrderClicked.debug("similar order clicked", trimOutput: true),
            activityIndicator: activityIndicator.debug("activity indicator", trimOutput: true),
            errors: errorTracker.asDriver()
        )
    }
}

extension OrderCardViewModel {
    struct Input {
        let backClickTrigger: Driver<Void>
        let animalProfileClickTrigger: Driver<Void>
        let customerProfileClickTrigger: Driver<Void>
        let similarOrderClickTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let backClicked: Driver<Void>
        let animalProfileClicked: Driver<Void>
        let customerProfileClicked: Driver<Void>
        let similarOrderClicked: Driver<Void>
        let activityIndicator: Driver<Bool>
        let errors: Driver<Error>
    }
}
