//
//  UICollectionView+Cell.swift
//  SpecialistApp
//
//  Created by alexander on 13.04.2023.
//

import Foundation
import UIKit

extension UICollectionView {
    func register<T: ReusableCell>(_ class: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseID)
    }

    func registerHeader<T: ReusableHeader>(_ class: T.Type) {
        self.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseID)
    }

    func createCell<T: ReusableCell>(by index: Int) -> T {
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Невозможно создать ячейку с типом \(T.self)")
        }

        return cell
    }

    func createCell<T: ReusableCell>(by index: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseID, for: index) as? T else {
            fatalError("Невозможно создать ячейку с типом \(T.self)")
        }

        return cell
    }

    func createHeader<T: ReusableHeader>(by index: IndexPath) -> T {
        guard let header = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseID, for: index) as? T else {
            fatalError("Невозможно создать header с типом \(T.self)")
        }

        return header
    }
}
