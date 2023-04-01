//
//  FavoriteLotCell.swift
//  iosapp
//
//  Created by alexander on 05.03.2023.
//

import Foundation
import UIKit
import RxSwift
import FavoritesGRPC
import Kingfisher
import CoreGRPC

class FavoriteLotCell: UICollectionViewCell {
    public static let reusableIdentifier = "favoriteLotCell"
    var disposeBag: DisposeBag!

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout(frame: frame)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let lotLabel: UILabel = {
        let label = UILabel()
        label.font = Font.robotoRegular14
        label.textColor = Color1.black
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Font.robotoSemiBold14
        label.textColor = Color1.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Font.robotoLight10
        label.textColor = Color1.gray3
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let favoriteButton: UIButton = {
        let view = UIButton()
        view.setImage(Icon.favoriteSelected, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        return cornerView
    }()

    private func layout(frame: CGRect) {

        addSubview(shadowView)
        addSubview(cornerView)

        cornerView.addSubview(imageView)
        cornerView.addSubview(lotLabel)
        cornerView.addSubview(favoriteButton)
        cornerView.addSubview(priceLabel)
        cornerView.addSubview(dateLabel)

        imageView.topAnchor.constraint(equalTo: cornerView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: cornerView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: cornerView.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: frame.height / 2).isActive = true

        lotLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        lotLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        lotLabel.rightAnchor.constraint(equalTo: favoriteButton.leftAnchor, constant: -8).isActive = true

        favoriteButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        favoriteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 25).isActive = true

        priceLabel.topAnchor.constraint(equalTo: lotLabel.bottomAnchor, constant: 4).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: favoriteButton.leftAnchor, constant: -8).isActive = true

        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
    }
}

extension FavoriteLotCell {

    func setUp(with model: CoreGRPC.Lot) {
        disposeBag = DisposeBag()
        lotLabel.text = model.title
        priceLabel.text = model.price
        dateLabel.text = model.publicationDate
        imageView.backgroundColor = Color1.gray3
        imageView.kf.setImage(with: URL(string: model.imageURL))
        cornerView.alpha = model.status == .active ? 1.0 : 0.5
    }
}
