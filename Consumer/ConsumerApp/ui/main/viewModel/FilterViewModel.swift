//
//  FilterViewModel.swift
//  iosapp
//
//  Created by alexander on 03.05.2022.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import ConsumerDomain
import ParameterGRPC

class FilterViewModel: ViewModelType {
    let disposeBag: DisposeBag = DisposeBag()
    let needPresentPickerForSubCategory = PublishRelay<[ParameterGRPC.Category]>()
    let needPresentPickerForParameter = PublishRelay<LotParameter>()
    let needPresentPickerForLotType = PublishRelay<[ParameterGRPC.LotForm]>()

    let selectedLotKind = BehaviorRelay<ParameterGRPC.LotForm?>(value: nil)

    let minimumPrice = BehaviorRelay<Int?>(value: nil)
    let maximumPrice = BehaviorRelay<Int?>(value: nil)

    var parameters = BehaviorRelay<[LotParameter]>(value: [])
    let selectedSubCategory = BehaviorRelay<ParameterGRPC.Category?>(value: nil)
    var stashedSubCategories: [ParameterGRPC.Category] = []
    let selectedCategory = BehaviorRelay<ParameterGRPC.Category?>(value: nil)

    let sortingMode = BehaviorRelay<SortingType?>(value: nil)
    let presentationMode = BehaviorRelay<PresentModeType>(value: .table)

    let parametersSectionHeight = BehaviorRelay<CGFloat>(value: 0.0)

    var previousSubCategory: ParameterGRPC.Category?

    private let useCase: WaterfallUseCaseProtocol
    init(with useCase: WaterfallUseCaseProtocol) {
        self.useCase = useCase

        // если указана категория, то загружаем подкатегории
        // и удаляем параметры, если они были указаны
        selectedCategory.bind {
            self.selectedLotKind.accept(nil)
            self.selectedSubCategory.accept(nil)
            self.parameters.accept([])
            self.loadSubCategoriesByCategory($0)
        }.disposed(by: disposeBag)

        selectedSubCategory.bind {
            if self.previousSubCategory != nil {
                self.parameters.accept([])
            }
            self.previousSubCategory = $0
            self.loadParametersBySubCategory($0)
        }.disposed(by: disposeBag)

        Observable.combineLatest(selectedCategory, parameters) { category, parameters in
            var height = 0.0

            if category != nil { height += CellHeight.filterCellTextPicker.height }

            parameters.forEach {
                height += $0.type == .string ? CellHeight.filterCellTextPicker.height:
                    CellHeight.filterCellDatePicker.height
            }

            return height
        }.bind(to: parametersSectionHeight).disposed(by: disposeBag)
    }

    func selectedLotType() {
        self.useCase.getLotForms(byCategory: self.selectedCategory.value!.id)
            .bind(to: needPresentPickerForLotType)
            .disposed(by: disposeBag)
    }

    func selectedParameterAt(index: Int) {
        // был произведен клик по подкатегории
        if index == 0 {
            guard !stashedSubCategories.isEmpty else { return }
            needPresentPickerForSubCategory.accept(stashedSubCategories)
        } else {
            let param = parameters.value[index - 1]
            guard param.type == .string else { return }
            needPresentPickerForParameter.accept(param)
        }
    }

    private func loadSubCategoriesByCategory(_ category: ParameterGRPC.Category?) {
        print("term to load subcategories")
        guard category != nil else { return }

        self.useCase.getChildrenCategories(byParrent: category!.id)
            .bind(onNext: { children in
            self.stashedSubCategories = children.sorted(by: { $0.id < $1.id })
        }).disposed(by: disposeBag)
    }

    private func loadParametersBySubCategory(_ subCategory: ParameterGRPC.Category?) {
        print("term to load parameters")
        guard parameters.value.isEmpty else { return }
        guard subCategory != nil else { return }

        self.useCase.getParameters(byCategory: subCategory!.id, andLotForm: 1)
            .bind(onNext: { parameters in
            var newParams = parameters.sorted(by: { $0.name < $1.name }).map {
                LotParameter(
                    id: $0.id,
                    name: $0.name,
                    type: $0.type,
                    isRequired: $0.isRequired,
                    values: $0.values,
                    choosenValues: []
                )
            }
            self.parameters.accept(newParams)
        }).disposed(by: disposeBag)
    }

}
