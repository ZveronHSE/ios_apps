//
//  CheckBoxView.swift
//  ConsumerApp
//
//  Created by alexander on 13.05.2023.
//

import Foundation
import UIKit

class CheckBoxView: UIView {

    lazy var gesture: UITapGestureRecognizer = {
        return .init(target: self, action: #selector(changeState))
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        addSubview(box)
        addSubview(text)

        box.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        box.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        box.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        box.widthAnchor.constraint(equalTo: heightAnchor, constant: -4).isActive = true


        text.topAnchor.constraint(equalTo: topAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: box.rightAnchor, constant: 8).isActive = true
        text.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        text.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        addGestureRecognizer(gesture)
    }


    public func setup(text: String) {
        self.text.text = text
        self.box.image = Icon.unchecked
    }

    var isSelected = false

    var closure: ((Bool) -> ())?

    @objc private func changeState() {
        closure?(!isSelected)

        if !isSelected {
            self.box.image = Icon.checked
            isSelected = true
        } else {
            self.box.image = Icon.unchecked
            isSelected = false
        }
    }
}
