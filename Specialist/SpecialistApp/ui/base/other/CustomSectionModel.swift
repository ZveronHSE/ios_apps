//
//  CustomSectionModel.swift
//  SpecialistApp
//
//  Created by alexander on 20.04.2023.
//

import Foundation
import RxDataSources

protocol SectionItemType: IdentifiableType, Equatable where Identity == Int { }

struct CustomSectionModel<SectionItem: SectionItemType> {
    var key: String
    var items: [SectionItem]
}

extension CustomSectionModel: AnimatableSectionModelType {
    init(original: CustomSectionModel<SectionItem>, items: [SectionItem]) {
        self = original
        self.items = items
    }

    var identity: String { self.key }
}
