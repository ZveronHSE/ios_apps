//
//  UIBackgroundView.swift
//  iosapp
//
//  Created by alexander on 07.03.2023.
//

import Foundation
import UIKit
import RxSwift

final class UIBackgroundView: UIView {
    private var disposeBag: DisposeBag!

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let textLabel: UILabel = {
        let view = UILabel()
        view.font = Font.robotoRegular16
        view.textColor = Color1.gray3
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let actionButton: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = .clear
        view.tintColor = .clear
        view.titleLabel?.font = Font.robotoRegular14
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.numberOfLines = 0
        view.setTitleColor(Color1.orange2, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func layout() {
        backgroundColor = .clear

        addSubview(iconImageView)
        addSubview(textLabel)
        addSubview(actionButton)

        iconImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 55).isActive = true

        textLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        actionButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 24).isActive = true
        actionButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        actionButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func configure(
        icon: UIImage,
        mainText: String,
        buttonIsDisplayed: Bool = false,
        buttonText: String? = nil,
        buttonClickTrigger: (() -> Void)? = nil
    ) {
        iconImageView.image = icon.withTintColor(Color1.gray3)
        textLabel.text = mainText
        actionButton.setTitle(buttonText, for: .normal)
        buttonIsDisplayed ? actionButton.show() : actionButton.hide()

        disposeBag = DisposeBag()
        actionButton.rx.tap.asDriver().drive(onNext: { _ in buttonClickTrigger?() }).disposed(by: disposeBag)
    }
}
