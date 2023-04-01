//
//  FavoriteProfileCell.swift
//  iosapp
//
//  Created by alexander on 06.03.2023.
//

import Foundation
import UIKit
import RxSwift
import FavoritesGRPC
import Cosmos

public final class FavoriteProfileCell: UICollectionViewCell {
    public static let reusableIdentifier = "profileCell"
    var disposeBag: DisposeBag!

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let fullNameLabel: UILabel = {
        let view = UILabel()
        view.font = Font.robotoMedium17
        view.textColor = Color1.gray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let favoriteButton: UIButton = {
        let view = UIButton()
        view.setImage(Icon.favoriteSelected, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let rating: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.totalStars = 5
        view.settings.starSize = 20
        view.settings.starMargin = 3.5
        view.settings.fillMode = .half

        view.settings.filledImage = Icon.star
        view.settings.filledBorderColor = .clear
        view.settings.filledBorderWidth = 0

        view.settings.emptyImage = Icon.starEmpty
        view.settings.emptyBorderWidth = 0
        view.settings.emptyBorderColor = .clear

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override public func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
    }

    private func layout() {
        backgroundColor = .clear

        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        let shadowLayer = CALayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowColor = Color1.gray3.cgColor
        shadowLayer.shadowRadius = 4
        shadowLayer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.addSublayer(shadowLayer)
        
        let cornerLayer = CALayer()
        cornerLayer.frame = bounds
        cornerLayer.cornerRadius = 16
        cornerLayer.backgroundColor = Color1.white.cgColor
        self.layer.addSublayer(cornerLayer)

        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(favoriteButton)
        addSubview(rating)

        avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true

        fullNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        fullNameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 8).isActive = true
        fullNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true

        favoriteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        favoriteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 25).isActive = true

        rating.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 4).isActive = true
        rating.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 8).isActive = true
    }

    func setUp(with model: ProfileSummary) {
        disposeBag = DisposeBag()
        avatarImageView.kf.setImage(with: URL(string: model.imageURL))
        fullNameLabel.text = model.name + " " + model.surname
        rating.rating = model.rating
    }
}

