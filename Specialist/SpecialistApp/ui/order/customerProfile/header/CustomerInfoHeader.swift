//
//  CustomerInfoHeader.swift
//  SpecialistApp
//
//  Created by alexander on 15.04.2023.
//

import Foundation
import UIKit
import Cosmos

final class CustomerInfoHeader: UICollectionReusableView, ReusableHeader {
    static var reuseID: String = "customerInfoHeader"
    static var headerHeight: CGFloat = 10

    private let avatarImageView: UIImageView = createView {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .zvGray3
    }

    private let fullnameLabel: UILabel = createLabel(with: .zvBlack, and: .zvRegularTitle1) {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private let ratingView: CompositeRatingView = createView()

    private let ratingValueLabel: UILabel = createLabel(with: .zvGray2, and: .zvRegularFootnote)

    override init(frame: CGRect) { super.init(frame: frame); layout() }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func layout() {
        addSubview(avatarImageView)
        addSubview(fullnameLabel)
        addSubview(ratingView)
        addSubview(ratingValueLabel)

        avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 28).isActive = true
        avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 130).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true

        fullnameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16).isActive = true
        fullnameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        fullnameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true

        ratingView.topAnchor.constraint(equalTo: fullnameLabel.bottomAnchor, constant: 12).isActive = true
        ratingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ratingView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layoutIfNeeded()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2
    }

    public func setup() {
        fullnameLabel.text = "Galanov Alexander Sergeevich"
        avatarImageView.kf.setImage(with: URL(string: "https://img3.akspic.ru/previews/2/3/3/7/6/167332/167332-oblako-lyudi_v_prirode-prirodnyj_landshaft-schastliv-poslesvechenie-x750.jpg"))
        ratingView.setup(4.9)
    }

    public static func processFitHeight(widthScreen: CGFloat, fullname: String) -> CGFloat {
        let avatarTopPadding = 28.0
        let avatarHeight = 130.0
        let fullnamePadding = 16.0
        let fullnameHeight = fullname.height(constraintedWidth: widthScreen - 32, font: .zvRegularTitle1)
        let ratingPadding = 12.0
        let ratingHeight = CompositeRatingView.processFitHeight()

        return avatarTopPadding + avatarHeight + fullnamePadding + fullnameHeight + ratingPadding + ratingHeight + 8
    }
}

final class CompositeRatingView: UIView {

    private let ratingView: CosmosView = {
        let view = CosmosView()
        view.isUserInteractionEnabled = false
        view.settings.updateOnTouch = false
        view.settings.totalStars = 5
        view.settings.starSize = 13
        view.settings.starMargin = 2.5
        view.settings.fillMode = .half

        view.settings.filledImage = .zvStar
        view.settings.filledColor = .zvOrange
        // view.settings.filledBorderColor = .clear
        view.settings.filledBorderWidth = 0
        view.settings.emptyImage = .zvStarEmpty
        view.settings.textColor = .clear
        view.settings.emptyColor = .zvOrange
        view.settings.emptyBorderWidth = 0
        //  view.settings.emptyBorderColor = .clear

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let ratingValueLabel: UILabel = createLabel(with: .zvGray2, and: .zvRegularFootnote)

    override init(frame: CGRect) { super.init(frame: frame); layout() }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func layout() {
        addSubview(ratingView)
        addSubview(ratingValueLabel)

        ratingView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        ratingView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        ratingView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        ratingValueLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        ratingValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        ratingValueLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        ratingValueLabel.leftAnchor.constraint(equalTo: ratingView.rightAnchor, constant: 16).isActive = true
    }

    public func setup(_ value: Double) {
        ratingView.rating = value
        ratingValueLabel.text = "(\(value))"
    }

    public static func processFitHeight() -> CGFloat {
        let ratingValuePadding = 0.0
        let ratingValueHeight = "(0.0)".height(constraintedWidth: 0, font: .zvRegularFootnote)

        return ratingValuePadding + ratingValueHeight
    }
}
