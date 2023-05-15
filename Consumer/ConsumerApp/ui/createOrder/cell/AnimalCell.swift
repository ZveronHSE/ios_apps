//
//  AnimalCell.swift
//  ConsumerApp
//
//  Created by alexander on 23.05.2023.
//

import Foundation
import UIKit
import ConsumerDomain

class AnimalCell: UICollectionViewCell {
    public static let reusableIdentifier = "animalCell"
    public static let width: CGFloat =  110
    public static let height: CGFloat =  145

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

    let box: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let text: UILabel = {
        let v = UILabel()
        v.font = Font.robotoRegular16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.frame = bounds
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 8)
        let shadowLayer = CALayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowColor = Color1.gray3.cgColor
        shadowLayer.shadowRadius = 2
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.addSublayer(shadowLayer)
        return shadowView
    }()

    private lazy var cornerView: UIView = {
        let cornerView = UIView()
        cornerView.frame = self.bounds
        cornerView.backgroundColor = Color1.white
        cornerView.layer.cornerRadius = 8
        cornerView.layer.masksToBounds = true
        cornerView.clipsToBounds = true
        return cornerView
    }()

    private func layout() {
        addSubview(shadowView)
        addSubview(cornerView)

        cornerView.addSubview(imageLot)
        cornerView.addSubview(text)
        cornerView.addSubview(box)


        imageLot.topAnchor.constraint(equalTo: cornerView.topAnchor).isActive = true
        imageLot.leftAnchor.constraint(equalTo: cornerView.leftAnchor).isActive = true
        imageLot.rightAnchor.constraint(equalTo: cornerView.rightAnchor).isActive = true
        imageLot.heightAnchor.constraint(equalTo: imageLot.widthAnchor).isActive = true

        text.leftAnchor.constraint(equalTo: cornerView.leftAnchor, constant: 4).isActive = true
        text.bottomAnchor.constraint(equalTo: cornerView.bottomAnchor, constant: -8).isActive = true

        box.topAnchor.constraint(equalTo: text.topAnchor).isActive = true
        box.rightAnchor.constraint(equalTo: cornerView.rightAnchor, constant: -4).isActive = true
        box.bottomAnchor.constraint(equalTo: cornerView.bottomAnchor, constant: -8).isActive = true
        box.widthAnchor.constraint(equalTo: box.heightAnchor).isActive = true
    }

    public func setup(_ model: Animal) {
        imageLot.kf.setImage(with: model.imageUrl)
        text.text = model.name
        self.unselect()
    }

    public func unselect() {
        box.image = Icon.unchecked
    }

    public func select() {
        box.image = Icon.checked
    }
}
