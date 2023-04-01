//
//  ThirdNestingViewModel.swift
//  iosapp
//
//  Created by alexander on 07.05.2022.
//

import Foundation
import RxRelay
import ConsumerDomain
import ParameterGRPC

protocol ThirdNestingViewModelHeader: NestingViewModelBase {
    func selectParameterAt(index: Int)
}

class ThirdNestingViewModel: NestingViewModel, ThirdNestingViewModelHeader {
    var selectedParameter = PublishRelay<LotParameter>()

    override init(with useCase: WaterfallUseCaseProtocol) {
        super.init(with: useCase)
    }

    func getParameters(subCategory: ParameterGRPC.Category) {
        self.useCase.getParameters(byCategory: Int32(subCategory.id), andLotForm: 1)
            .bind(onNext: { parameters in
                let sortedParameters = parameters.sorted(by: { $0.name < $1.name })
                let mappedParameters = sortedParameters.map {
                    LotParameter(
                        id: $0.id,
                        name: $0.name,
                        type: $0.type,
                        isRequired: $0.isRequired,
                        values: $0.values,
                        choosenValues: []
                    )
                }

                let oldFilter = self.filter.value!
                let newFilter = oldFilter.updateFields(parameters: mappedParameters)
                self.filter.accept(newFilter)
            }).disposed(by: disposeBag)
    }

    func selectParameterAt(index: Int) {
        let parameter = filter.value!.parameters[index]
        selectedParameter.accept(parameter)
    }
}
