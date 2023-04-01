//
//  SecondNestingViewModel.swift
//  iosapp
//
//  Created by alexander on 07.05.2022.
//

import Foundation
import RxRelay
import ConsumerDomain
import ParameterGRPC

protocol SecondNestingViewModelHeader: NestingViewModelBase {
    var needShowAllSubCategories: PublishRelay<Void?> { get }
    var subCategories: BehaviorRelay<[ParameterGRPC.Category]> { get }
    func selectSubCategoryAt(index: Int)
}

class SecondNestingViewModel: NestingViewModel, SecondNestingViewModelHeader {

    let needShowAllSubCategories = PublishRelay<Void?>()
    let selectedSubCategory = PublishRelay<ParameterGRPC.Category>()
    let subCategories = BehaviorRelay<[ParameterGRPC.Category]>(value: [])

    override init(with useCase: WaterfallUseCaseProtocol) {
        super.init(with: useCase)
    }

    func selectSubCategoryAt(index: Int) {
        let subCategory = subCategories.value[index]
        selectedSubCategory.accept(subCategory)
    }

    func getSubCategories(category: ParameterGRPC.Category) {
        self.useCase.getChildrenCategories(byParrent: category.id)
            .bind(onNext: { children in
            self.subCategories.accept(children.sorted(by: { $0.id < $1.id }))
            }).disposed(by: disposeBag)
    }
}
