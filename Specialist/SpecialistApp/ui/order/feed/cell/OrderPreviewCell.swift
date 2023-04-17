//
//  OrderCell.swift
//  specialist
//
//  Created by alexander on 27.03.2023.
//

import Foundation
import UIKit
import SpecialistDomain
import Kingfisher

final class OrderPreviewCell: UICollectionViewCell, ReusableCell {
    static var cellSize: CGSize = CGSize(width: 0, height: 130)
    public static let reuseID = "orderCell"

    private lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.frame = bounds
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        let shadowLayer = CALayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowColor = UIColor.zvGray1.cgColor
        shadowLayer.shadowRadius = 4
        shadowLayer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.addSublayer(shadowLayer)
        return shadowView
    }()

    private lazy var cornerView: UIView = {
        let cornerView = UIView()
        cornerView.frame = self.bounds
        cornerView.backgroundColor = .zvWhite
        cornerView.layer.cornerRadius = 16
        cornerView.layer.masksToBounds = true
        return cornerView
    }()

    private let titleLabel: UILabel = createLabel(with: .zvBlack, and: .zvMediumFootnote)
    private let priceLabel: UILabel = createLabel(with: .zvBlack, and: .zvMediumSubheadline)
    private let cityLabel: UILabel = createLabel(with: .zvBlack, and: .zvRegularCaption2)
    private let metroStationLabel: UILabel = createLabel(with: .zvBlack, and: .zvRegularCaption2)
    private let orderPeriodLabel: UILabel = createLabel(with: .zvGray2, and: .zvRegularCaption2)
    private let animalNameLabel: UILabel = createLabel(with: .zvGray2, and: .zvRegularCaption2)
    private let animalDescriptionLabel: UILabel = createLabel(with: .zvGray1, and: .zvRegularCaption3)
    private let publishDateLabel: UILabel = createLabel(with: .zvGray3, and: .zvRegularCaption3)
    private let cityIcon: UIImageView = createView { $0.image = .zvTrello.withTintColor(.zvGray1) }
    private let metroStationColor: UIView = createView { $0.clipsToBounds = true }
    private let orderPeriodIcon: UIImageView = createView { $0.image = .zvCalendar.withTintColor(.zvGray1) }
    private let animalImage: UIImageView = createView {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) { super.init(frame: frame); layout() }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public func layout() {
        let paddings = UIEdgeInsets(top: 16, left: 16, bottom: -16, right: -16)

        addSubview(shadowView)
        addSubview(cornerView)

        cornerView.addSubview(titleLabel)
        cornerView.addSubview(cityLabel)
        cornerView.addSubview(orderPeriodLabel)
        cornerView.addSubview(metroStationLabel)
        cornerView.addSubview(animalNameLabel)
        cornerView.addSubview(animalDescriptionLabel)
        cornerView.addSubview(priceLabel)
        cornerView.addSubview(publishDateLabel)
        cornerView.addSubview(cityIcon)
        cornerView.addSubview(metroStationColor)
        cornerView.addSubview(orderPeriodIcon)
        cornerView.addSubview(animalImage)

        titleLabel.topAnchor.constraint(equalTo: cornerView.topAnchor, constant: paddings.top).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: cornerView.leftAnchor, constant: paddings.left).isActive = true

        priceLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: cornerView.rightAnchor, constant: paddings.right).isActive = true

        cityIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        cityIcon.leftAnchor.constraint(equalTo: cornerView.leftAnchor, constant: paddings.left).isActive = true
        cityIcon.widthAnchor.constraint(equalTo: cityIcon.heightAnchor).isActive = true
        cityIcon.heightAnchor.constraint(equalToConstant: 12).isActive = true

        cityLabel.centerYAnchor.constraint(equalTo: cityIcon.centerYAnchor).isActive = true
        cityLabel.leftAnchor.constraint(equalTo: cityIcon.rightAnchor, constant: 6).isActive = true

        metroStationColor.centerYAnchor.constraint(equalTo: cityLabel.centerYAnchor).isActive = true
        metroStationColor.leftAnchor.constraint(equalTo: cityLabel.rightAnchor, constant: 4).isActive = true
        metroStationColor.widthAnchor.constraint(equalTo: metroStationColor.heightAnchor).isActive = true
        metroStationColor.heightAnchor.constraint(equalToConstant: 4).isActive = true

        metroStationLabel.centerYAnchor.constraint(equalTo: metroStationColor.centerYAnchor).isActive = true
        metroStationLabel.leftAnchor.constraint(equalTo: metroStationColor.rightAnchor, constant: 4).isActive = true

        orderPeriodIcon.topAnchor.constraint(equalTo: cityIcon.bottomAnchor, constant: 9).isActive = true
        orderPeriodIcon.leftAnchor.constraint(equalTo: cornerView.leftAnchor, constant: paddings.left).isActive = true
        orderPeriodIcon.widthAnchor.constraint(equalTo: orderPeriodIcon.heightAnchor).isActive = true
        orderPeriodIcon.heightAnchor.constraint(equalToConstant: 12).isActive = true

        orderPeriodLabel.centerYAnchor.constraint(equalTo: orderPeriodIcon.centerYAnchor).isActive = true
        orderPeriodLabel.leftAnchor.constraint(equalTo: orderPeriodIcon.rightAnchor, constant: 6).isActive = true

        animalImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        animalImage.leftAnchor.constraint(equalTo: cornerView.leftAnchor, constant: paddings.left).isActive = true
        animalImage.widthAnchor.constraint(equalTo: animalImage.heightAnchor).isActive = true
        animalImage.bottomAnchor.constraint(equalTo: cornerView.bottomAnchor, constant: paddings.bottom).isActive = true

        animalNameLabel.topAnchor.constraint(equalTo: animalImage.topAnchor).isActive = true
        animalNameLabel.leftAnchor.constraint(equalTo: animalImage.rightAnchor, constant: 8).isActive = true

        animalDescriptionLabel.bottomAnchor.constraint(equalTo: animalImage.bottomAnchor).isActive = true
        animalDescriptionLabel.leftAnchor.constraint(equalTo: animalImage.rightAnchor, constant: 8).isActive = true

        publishDateLabel.centerYAnchor.constraint(equalTo: animalImage.centerYAnchor).isActive = true
        publishDateLabel.rightAnchor.constraint(equalTo: cornerView.rightAnchor, constant: paddings.right).isActive = true
    }

    public override func layoutSubviews() {
        animalImage.layer.cornerRadius = animalImage.frame.size.width / 2
        metroStationColor.layer.cornerRadius = metroStationColor.frame.size.width / 2
    }

    public func setup(with model: OrderPreview) {
        titleLabel.text = model.title
        cityLabel.text = model.city
        metroStationLabel.text = model.metroStation
        orderPeriodLabel.text = model.orderPeriod
        animalNameLabel.text = model.animalName
        animalDescriptionLabel.text = model.animalDesciption
        priceLabel.text = model.price
        publishDateLabel.text = model.publishDate
        metroStationColor.backgroundColor = UIColor(hexString: model.metroColor)
        animalImage.kf.setImage(with: URL(string: model.animalImageLink)!)
    }
}
