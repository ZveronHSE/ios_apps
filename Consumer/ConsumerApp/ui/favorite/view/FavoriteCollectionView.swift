//
//  FavoriteCollectionView.swift
//  iosapp
//
//  Created by alexander on 06.03.2023.
//

import Foundation
import UIKit

class FavoriteCollectionView: UIView {
    enum PresentationStyle {
        case lots
        case profiles
    }

    private var currentStyle: PresentationStyle = .profiles

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var flowLayout: UICollectionViewFlowLayout = {
        let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = sectionInsets
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        view.register(LotCell.self, forCellWithReuseIdentifier: LotCell.reusableIdentifier)
        view.register(FavoriteProfileCell.self, forCellWithReuseIdentifier: FavoriteProfileCell.reusableIdentifier)
        view.register(FavoriteLotCell.self, forCellWithReuseIdentifier: FavoriteLotCell.reusableIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func layout() {
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.delegate = self
    }

    func setStyle(_ style: PresentationStyle) {
        self.currentStyle = style
    }
}

extension FavoriteCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let numerColumns = currentStyle == .lots ? 2.0 : 1.0
        let padding = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (numerColumns - 1.0) * flowLayout.minimumInteritemSpacing

        let cellWidth = (self.collectionView.frame.width - padding) / numerColumns
        let cellHeight = currentStyle == .lots ? CellHeight.lotCell.height : CellHeight.profileCell.height

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            collectionView.cellForItem(at: indexPath)?.plainView.alpha = 0.5
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            collectionView.cellForItem(at: indexPath)?.plainView.alpha = 1.0
        }
    }
}
