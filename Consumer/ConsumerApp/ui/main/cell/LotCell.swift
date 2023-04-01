//
//  LotCell.swift
//  iosapp
//
//  Created by alexander on 01.05.2022.
//

import Foundation
import UIKit
import RxSwift
import CoreGRPC

class LotCell: UICollectionViewCell {

    var isFavorite: Bool = false {
        willSet {
            let icon = newValue ? Icon.favoriteSelected : Icon.favoriteUnselected
            self.favoriteButton.setImage(icon, for: .normal)
        }
    }

    public static let reusableIdentifier = "lotCell"

    var disposeBag: DisposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetUp()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setPresentationStyle()
    }

    required init?(coder: NSCoder) {
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
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1058823529, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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

    private var tablePresentationConstraints: [NSLayoutConstraint] = []
    private var gridPresentationConstraints: [NSLayoutConstraint] = []

    private func initialSetUp() {
        addSubview(shadowView)
        addSubview(cornerView)

        cornerView.addSubview(imageLot)
        cornerView.addSubview(lotLabel)
        cornerView.addSubview(favoriteButton)
        cornerView.addSubview(priceLabel)
        cornerView.addSubview(dateLabel)
    }

    private func setPresentationStyle() {
        shadowView.frame = self.bounds
        cornerView.frame = self.bounds

        let isTablePresentation = frame.width > frame.height
        if tablePresentationConstraints.isEmpty && isTablePresentation { initTablePresentationConstraints() }
        if gridPresentationConstraints.isEmpty && !isTablePresentation { initGridPresentationConstraints() }

        tablePresentationConstraints.forEach { $0.isActive = isTablePresentation }
        gridPresentationConstraints.forEach { $0.isActive = !isTablePresentation }

        let lotLabelFontSize: CGFloat = isTablePresentation ? 15 : 13
        let priceLabelFontSize: CGFloat = isTablePresentation ? 17 : 15
        let dateLabelFontSize: CGFloat = isTablePresentation ? 11 : 9

        lotLabel.font = .systemFont(ofSize: lotLabelFontSize, weight: .regular)
        priceLabel.font = .systemFont(ofSize: priceLabelFontSize, weight: .medium)
        dateLabel.font = .systemFont(ofSize: dateLabelFontSize, weight: .light)

    }

    private func initTablePresentationConstraints() {
        tablePresentationConstraints = [
            imageLot.topAnchor.constraint(equalTo: cornerView.topAnchor),
            imageLot.leftAnchor.constraint(equalTo: cornerView.leftAnchor),
            imageLot.bottomAnchor.constraint(equalTo: cornerView.bottomAnchor),
            imageLot.widthAnchor.constraint(equalToConstant: cornerView.frame.width * 0.5),

            lotLabel.topAnchor.constraint(equalTo: cornerView.topAnchor, constant: 8),
            lotLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8),
            lotLabel.rightAnchor.constraint(equalTo: cornerView.rightAnchor, constant: -8),

            favoriteButton.rightAnchor.constraint(equalTo: cornerView.rightAnchor, constant: -8),
            favoriteButton.bottomAnchor.constraint(equalTo: cornerView.bottomAnchor, constant: -8),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: cornerView.frame.width / 10),

            priceLabel.topAnchor.constraint(equalTo: lotLabel.bottomAnchor, constant: 4),
            priceLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8),

            dateLabel.bottomAnchor.constraint(equalTo: cornerView.bottomAnchor, constant: -8),
            dateLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8)
        ]
    }

    private func initGridPresentationConstraints() {
        gridPresentationConstraints = [
            imageLot.topAnchor.constraint(equalTo: cornerView.topAnchor),
            imageLot.leftAnchor.constraint(equalTo: cornerView.leftAnchor),
            imageLot.rightAnchor.constraint(equalTo: cornerView.rightAnchor),
            imageLot.heightAnchor.constraint(equalToConstant: cornerView.frame.height / 2),

            lotLabel.topAnchor.constraint(equalTo: imageLot.bottomAnchor, constant: 8),
            lotLabel.leftAnchor.constraint(equalTo: cornerView.leftAnchor, constant: 8),
            lotLabel.rightAnchor.constraint(equalTo: favoriteButton.leftAnchor, constant: -16),

            favoriteButton.topAnchor.constraint(equalTo: imageLot.bottomAnchor, constant: 8),
            favoriteButton.rightAnchor.constraint(equalTo: cornerView.rightAnchor, constant: -8),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: frame.width / 6),

            priceLabel.topAnchor.constraint(equalTo: lotLabel.bottomAnchor, constant: 4),
            priceLabel.leftAnchor.constraint(equalTo: cornerView.leftAnchor, constant: 8),

            dateLabel.bottomAnchor.constraint(equalTo: cornerView.bottomAnchor, constant: -8),
            dateLabel.leftAnchor.constraint(equalTo: cornerView.leftAnchor, constant: 8)
        ]
    }

    func setup(with model: CoreGRPC.Lot) {
        disposeBag = DisposeBag()

        lotLabel.text = model.title
        priceLabel.text = model.price
        dateLabel.text = model.publicationDate
        imageLot.kf.setImage(with: URL(string: model.imageURL))
        isFavorite = model.favorite
        self.alpha = model.status == .active ? 1.0 : 0.5
    }
}
