//
//  OrderPreviewCell.swift
//  ConsumerApp
//
//  Created by alexander on 12.05.2023.
//

import Foundation
import UIKit
import ConsumerDomain

class OrderPreviewCell: UICollectionViewCell {
    public static let reusableIdentifier = "orderPreviewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let imageLot: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Color1.gray3
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let lotLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1058823529, alpha: 1)
        label.font = Font.robotoRegular16
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1058823529, alpha: 1)
        label.font = Font.robotoSemiBold18
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let publishLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color1.gray3
        label.font = Font.robotoLight14
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.frame = bounds
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        let shadowLayer = CALayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowColor = Color1.gray3.cgColor
        shadowLayer.shadowRadius = 4
        shadowLayer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.addSublayer(shadowLayer)
        return shadowView
    }()

    private lazy var cornerView: UIView = {
        let cornerView = UIView()
        cornerView.frame = self.bounds
        cornerView.backgroundColor = Color1.white
        cornerView.layer.cornerRadius = 16
        cornerView.layer.masksToBounds = true
        cornerView.clipsToBounds = true
        return cornerView
    }()

    private func layout() {
        addSubview(shadowView)
        addSubview(cornerView)

        cornerView.addSubview(imageLot)
        cornerView.addSubview(lotLabel)
        cornerView.addSubview(priceLabel)
        cornerView.addSubview(publishLabel)

        imageLot.topAnchor.constraint(equalTo: cornerView.topAnchor).isActive = true
        imageLot.leftAnchor.constraint(equalTo: cornerView.leftAnchor).isActive = true
        imageLot.bottomAnchor.constraint(equalTo: cornerView.bottomAnchor).isActive = true
        imageLot.widthAnchor.constraint(equalToConstant: cornerView.frame.height).isActive = true

        priceLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8).isActive = true
        priceLabel.topAnchor.constraint(equalTo: lotLabel.bottomAnchor, constant: 8).isActive = true

        lotLabel.topAnchor.constraint(equalTo: cornerView.topAnchor, constant: 8).isActive = true
        lotLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8).isActive = true
        lotLabel.rightAnchor.constraint(equalTo: cornerView.rightAnchor, constant: -24).isActive = true

        publishLabel.bottomAnchor.constraint(equalTo: cornerView.bottomAnchor, constant: -8).isActive = true
        publishLabel.rightAnchor.constraint(equalTo: cornerView.rightAnchor, constant: -8).isActive = true
    }

    public func setup(_ model: OrderPreview) {
        imageLot.kf.setImage(with: model.imageUrl)
        lotLabel.text = model.title
        priceLabel.text = model.price
        publishLabel.text = model.createdAt
    }
}
