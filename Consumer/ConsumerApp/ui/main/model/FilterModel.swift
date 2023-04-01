//
//  FilterModel.swift
//  iosapp
//
//  Created by alexander on 03.05.2022.
//

import Foundation
import ParameterGRPC

struct FilterModel {
    let sortingType: SortingType
    let category: ParameterGRPC.Category?
    let lotKind: ParameterGRPC.LotForm?
    let subCategory: ParameterGRPC.Category?
    let parameters: [LotParameter]
    let minPrice: Int?
    let maxPrice: Int?

    init(
        sortingType: SortingType,
        category: ParameterGRPC.Category? = nil,
        lotKind: ParameterGRPC.LotForm? = nil,
        subCategory: ParameterGRPC.Category? = nil,
        parameters: [LotParameter] = [],
        minPrice: Int? = nil,
        maxPrice: Int? = nil
    ) {
        self.sortingType = sortingType
        self.category = category
        self.lotKind = lotKind
        self.subCategory = subCategory
        self.parameters = parameters
        self.minPrice = minPrice
        self.maxPrice = maxPrice
    }

    func updateFields(
        sortingType: SortingType? = nil,
        category: ParameterGRPC.Category? = nil,
        lotKind: ParameterGRPC.LotForm? = nil,
        subCategory: ParameterGRPC.Category? = nil,
        parameters: [LotParameter]? = nil,
        minPrice: Int? = nil,
        maxPrice: Int? = nil
    ) -> FilterModel {
        let oldModel = self
        let newModel = FilterModel(
            sortingType: sortingType != nil ? sortingType! : oldModel.sortingType,
            category: category != nil ? category! : oldModel.category,
            lotKind: lotKind != nil ? lotKind! : oldModel.lotKind,
            subCategory: subCategory != nil ? subCategory! : oldModel.subCategory,
            parameters: parameters != nil ? parameters! : oldModel.parameters,
            minPrice: minPrice != nil ? minPrice! : oldModel.minPrice,
            maxPrice:  maxPrice != nil ? maxPrice! : oldModel.maxPrice
        )
        return newModel
    }
}
