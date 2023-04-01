//
//  FavoriteTypeCell.swift
//  iosapp
//
//  Created by alexander on 09.05.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ZveronRemoteDataService

class FavoriteTypeCell: UICollectionViewCell {
    public static let reuseID = "favoriteHeaderCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    var label: UILabel = {
        let label = UILabel()
        label.font = Font.robotoReqular12
        label.textColor = Color1.gray5
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setupViews() {
        backgroundColor = Color1.white
        layer.cornerRadius = 12

        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
    }

    func selected() {
        removeGradientLayer()
        applyGradient(.mainButton, .horizontal, 12)
        label.textColor = Color1.white
    }

    func unselected() {
        removeGradientLayer()
        applyGradientForBorder(.mainButton, .horizontal, 1.5, 12)
        label.textColor = Color1.gray5
    }
}
