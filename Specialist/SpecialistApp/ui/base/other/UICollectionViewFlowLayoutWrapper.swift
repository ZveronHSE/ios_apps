//
//  UICollectionViewFlowLayoutWrapper.swift
//  SpecialistApp
//
//  Created by alexander on 19.04.2023.
//

import Foundation
import UIKit

final class UICollectionViewFlowLayoutWrapper: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    private let cellSize: CGSize

    init(cellSize: CGSize) { self.cellSize = cellSize; super.init() }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.select(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.unselect(animated: true)
    }
}
