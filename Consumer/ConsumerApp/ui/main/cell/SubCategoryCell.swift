//
//  SubCategoryCollectionViewCell.swift
//  iosapp
//
//  Created by alexander on 29.03.2022.
//

import UIKit
import ParameterGRPC

class SubCategoryCell: UICollectionViewCell {
    public static let reusableIdentifier = "subcategoryCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var data: ParameterGRPC.Category? {
        didSet {
            guard let data = data else { return }
            labelCell.text = data.name
            let icon =  UIImage.init(named: "subcategory_icon_\(data.id)")
            imageCell.image  = icon ?? #imageLiteral(resourceName: "subcategory_icon_14")
        }
    }

   private let labelCell: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageCell: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private func setupViews() {
        backgroundColor = .clear
        addSubview(labelCell)
        addSubview(container)
        container.addSubview(imageCell)

        container.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: container.widthAnchor).isActive = true

        imageCell.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
        imageCell.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 10).isActive = true
        imageCell.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -10).isActive = true
        imageCell.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10).isActive = true


        labelCell.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        labelCell.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        labelCell.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    public override func layoutSubviews() {
        self.container.layer.cornerRadius = self.frame.size.width / 2
        self.layer.cornerRadius = 10
    }
}
