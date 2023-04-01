//
// Created by alexander on 20.02.2023.
//

import Foundation
import FavoritesGRPC

public enum FavoriteError: Error {
    case failedLoad
    case failedRemoveItem
    case failedRemoveAllItems
    case failedRemoveClosedItems
    case failedLoadCurrentLot
}

extension FavoriteError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedLoad: return NSLocalizedString("", comment: "")
        case .failedRemoveItem: return NSLocalizedString("", comment: "")
        default: return NSLocalizedString("", comment: "")
        }
    }
}
