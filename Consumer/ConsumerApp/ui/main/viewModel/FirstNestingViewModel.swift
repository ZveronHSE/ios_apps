//
//  FirstNestingViewModel.swift
//  iosapp
//
//  Created by alexander on 07.05.2022.
//

import Foundation
import RxRelay
import ConsumerDomain
import ParameterGRPC

protocol FirstNestingViewModelHeader: NestingViewModelBase {
    var selectedCategory: PublishRelay<ParameterGRPC.Category> { get }
}

class FirstNestingViewModel: NestingViewModel, FirstNestingViewModelHeader {
    let selectedCategory = PublishRelay<ParameterGRPC.Category>()

    override init(with useCase: WaterfallUseCaseProtocol) {
        super.init(with: useCase)
    }
}
