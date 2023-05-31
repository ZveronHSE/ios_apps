//
//  CustomButton.swift
//  ConsumerApp
//
//  Created by alexander on 22.05.2023.
//

import Foundation
import UIKit

class CustomButtonView: UIView {

    lazy var gesture: UITapGestureRecognizer = {
        return .init(target: self, action: #selector(tapped))
    }()

    let text: UILabel = {
        let v = UILabel()
        v.font = Font.robotoRegular16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let imageView: UIImageView = {
        let v = UIImageView()
        v.image = Icon.arrowRight.withTintColor(Color1.orange3)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {

        backgroundColor = Color1.white
        layer.cornerRadius = 10
        addSubview(text)
        addSubview(imageView)

        text.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        text.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        text.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true

        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        imageView.topAnchor.constraint(equalTo: text.topAnchor, constant: 4).isActive = true
        imageView.bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: -4).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.7).isActive = true

        addGestureRecognizer(gesture)
    }


    public func setup(text: String) {
        self.text.text = text
    }

    var closure: (() -> ())?

    @objc private func tapped() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.5
        }
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        }
        closure?()
    }
}
