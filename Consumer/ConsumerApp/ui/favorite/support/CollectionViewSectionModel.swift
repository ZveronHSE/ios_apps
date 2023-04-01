//
//  CollectionViewSectionModel.swift
//  iosapp
//
//  Created by alexander on 09.03.2023.
//

import Foundation
import FavoritesGRPC
import RxDataSources
import CoreGRPC

public enum FavoriteSectionModel {
    case FavoriteSection(type: FavoriteSourceType, items: [FavoriteSectionItem])
}

public enum FavoriteSectionItem {
    case LotItem(item: CoreGRPC.Lot)
    case ProfileItem(item: ProfileSummary)
}

extension FavoriteSectionModel: AnimatableSectionModelType {
    public typealias Item = FavoriteSectionItem
    public typealias Identity = String

    public var identity: String {
        return self.type.rawValue
    }

    public var items: [FavoriteSectionItem] {
        switch self {
        case .FavoriteSection(_, let items): return items
        }
    }

    var type: FavoriteSourceType {
        switch self {
        case .FavoriteSection(let type, _): return type
        }
    }

    public init(original: FavoriteSectionModel, items: [Item]) {
        switch original {
        case .FavoriteSection(let type, _):
            self = .FavoriteSection(type: type, items: items)
        }
    }
}

extension FavoriteSectionItem: IdentifiableType, Equatable {

    public typealias Identity = Int64

    public var identity: Int64 {
        switch self {
        case .LotItem(let item): return item.id
        case .ProfileItem(let item): return item.id
        }
    }
}
