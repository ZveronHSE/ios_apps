//
//  OrderAnimalProfileViewModel.swift
//  SpecialistApp
//
//  Created by alexander on 18.04.2023.
//

import Foundation
import RxSwift
import RxCocoa
import SpecialistDomain

final class OrderAnimalProfileViewModel: ViewModelType {
    private let navigator: OrderAnimalProfileNavigatorProtocol
    let model: AnimalProfile

    init(
        with navigator: OrderAnimalProfileNavigatorProtocol,
        and model: AnimalProfile
    ) {
        self.navigator = navigator
        self.model = model
    }

    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let backClicked = input.backClickTrigger.do(onNext: navigator.toBack)

        let documentClicked = input.documentClickTrigger.flatMap { documentIndex in
            let documentUrl = self.model.documents[documentIndex.item].url

            return PDFLoadService.shared
                .loadPdf(from: documentUrl)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
            
        }.do(onNext: navigator.presentDocument).mapToVoid()

        let activityIndicatorStart = Driver.merge(
            input.documentClickTrigger.mapToTrue()
        )

        let activityIndicatorEnd = Driver.merge(
            documentClicked.mapToFalse(),
            errorTracker.mapToFalse()
        ).delay(.milliseconds(1))

        let activityIndicatorWithDebounce = Driver.merge(activityIndicatorStart, activityIndicatorEnd).debounce(.milliseconds(500))

        let activityIndicator = Driver.merge(activityIndicatorWithDebounce, activityIndicatorEnd).distinctUntilChanged()

        return .init(
            backClicked: backClicked.debug("back clicked", trimOutput: true),
            documentClicked: documentClicked.debug("document clicked", trimOutput: true),
            activityIndicator: activityIndicator.debug("activity indicator", trimOutput: true),
            errors: errorTracker.asDriver()
        )
    }
}

extension OrderAnimalProfileViewModel {
    struct Input {
        let backClickTrigger: Driver<Void>
        let documentClickTrigger: Driver<IndexPath>
    }

    struct Output {
        let backClicked: Driver<Void>
        let documentClicked: Driver<Void>
        let activityIndicator: Driver<Bool>
        let errors: Driver<Error>
    }
}
