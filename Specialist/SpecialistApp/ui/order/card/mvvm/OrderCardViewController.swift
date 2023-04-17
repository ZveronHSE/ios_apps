//
//  OrderCardViewController.swift
//  specialist
//
//  Created by alexander on 29.03.2023.
//

import Foundation
import UIKit
import Cosmos
import SpecialistDomain

final class OrderCardViewController: UIViewController {

    private let scrollView: UIScrollView = createView {
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }

    private let continueButton: UIButton = createButton {
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .zvRegularSubheadline
        $0.backgroundColor = .zvRedMain
        $0.layer.cornerRadius = 10
    }

    private let contentView: UIView = createView()
    private let headerView: HeaderView = createView()
    private let addressView: AddressView = createView()
    private let serviceDateView: HeaderAndTitleView = createView()
    private let serviceTimeView: HeaderAndTitleView = createView()
    private let animalView: AnimalView = createView()
    private let profileView: ProfileView = createView()
    private let descriptionView: HeaderAndTitleView = createView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .zvBackground
        navigationItem.leftBarButtonItem = createNavigationButton(type: .back) { [weak self] in
            self?.popFromRoot()
        }

        layoutScrollView()
        layoutContentView()
    }

    private func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(continueButton)

        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        continueButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        continueButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }

    private func layoutContentView() {
        let paddings = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)

        contentView.addSubview(headerView)
        contentView.addSubview(addressView)
        contentView.addSubview(serviceDateView)
        contentView.addSubview(serviceTimeView)
        contentView.addSubview(animalView)
        contentView.addSubview(profileView)
        contentView.addSubview(descriptionView)

        headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        headerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left).isActive = true
        headerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right).isActive = true

        addressView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 28).isActive = true
        addressView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left).isActive = true
        addressView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right).isActive = true

        serviceDateView.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 12).isActive = true
        serviceDateView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left).isActive = true
        serviceDateView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right).isActive = true

        serviceTimeView.topAnchor.constraint(equalTo: serviceDateView.bottomAnchor, constant: 12).isActive = true
        serviceTimeView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left).isActive = true
        serviceTimeView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right).isActive = true

        let cardWidth = (view.frame.size.width - 36) / 2
        animalView.topAnchor.constraint(equalTo: serviceTimeView.bottomAnchor, constant: 12).isActive = true
        animalView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left).isActive = true
        animalView.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true

        profileView.topAnchor.constraint(equalTo: animalView.topAnchor).isActive = true
        profileView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right).isActive = true
        profileView.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true

        descriptionView.topAnchor.constraint(equalTo: animalView.bottomAnchor, constant: 16).isActive = true
        descriptionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left).isActive = true
        descriptionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right).isActive = true
        descriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    public func setup() {
        navigationItem.title = "Стрижка"
        continueButton.setTitle("Показать объявления", for: .normal)

        headerView.setup()
        addressView.setup()
        serviceDateView.setup(with: "Дата оказания услуги", and: "27.12.2022")
        serviceTimeView.setup(with: "Дата оказания услуги", and: "13:00 - 21:00")
        animalView.setup(
            onClick: { [weak self] in
                let nextVC = OrderAnimalProfileController()
                nextVC.setup()
                self?.navigationController?.pushViewController(nextVC, animated: true)
            }
        )
        profileView.setup(
            onClick: { [weak self] in
                let nextVC = OrderCustomerProfileController()
                nextVC.setup()
                self?.navigationController?.pushViewController(nextVC, animated: true)
            }
        )
        descriptionView.setup(with: "Описание", and: "Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса Необходимо выполнить стрижку кота Томаса")
        // continueButton.
    }
}

// MARK: header view
fileprivate final class HeaderView: UIView {

    private lazy var titleLabel: UILabel = createLabel(with: .zvBlack, and: .zvMediumTitle2)
    private lazy var priceLabel: UILabel = createLabel(with: .zvBlack, and: .zvMediumTitle2)
    private lazy var publishDateLabel: UILabel = createLabel(with: .zvGray3, and: .zvRegularCaption1)

    override init(frame: CGRect) { super.init(frame: frame); layout() }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public func layout() {
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(publishDateLabel)

        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        publishDateLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        publishDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    public func setup() {
        titleLabel.text = "Cтрижка кота"
        priceLabel.text = "500$"
        publishDateLabel.text = "Сегодня 9:43"
    }
}

// MARK: address view
fileprivate final class AddressView: UIView {

    private let titleLabel: UILabel = createLabel(with: .zvGray3, and: .zvRegularCaption3)
    private let cityLabel: UILabel = createLabel(with: .zvBlack, and: .zvRegularSubheadline)
    private let metroStationColor: UIView = createView { $0.layer.cornerRadius = 2 }
    private let metroStationLabel: UILabel = createLabel(with: .zvBlack, and: .zvRegularSubheadline)

    override init(frame: CGRect) { super.init(frame: frame); layout() }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public func layout() {
        addSubview(titleLabel)
        addSubview(cityLabel)
        addSubview(metroStationColor)
        addSubview(metroStationLabel)

        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        cityLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        cityLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cityLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        metroStationColor.centerYAnchor.constraint(equalTo: cityLabel.centerYAnchor).isActive = true
        metroStationColor.leftAnchor.constraint(equalTo: cityLabel.rightAnchor, constant: 4).isActive = true
        metroStationColor.widthAnchor.constraint(equalTo: metroStationColor.heightAnchor).isActive = true
        metroStationColor.heightAnchor.constraint(equalToConstant: 4).isActive = true

        metroStationLabel.centerYAnchor.constraint(equalTo: metroStationColor.centerYAnchor).isActive = true
        metroStationLabel.leftAnchor.constraint(equalTo: metroStationColor.rightAnchor, constant: 4).isActive = true
    }

    public func setup() {
        titleLabel.text = "Адрес"
        cityLabel.text = "г. Москва"
        metroStationColor.backgroundColor = UIColor(hexString: "#F1B223")
        metroStationLabel.text = "Водный стадион"
    }
}

// MARK: animal view
fileprivate final class AnimalView: UIView {

    private let titleLabel: UILabel = createLabel(with: .zvGray3, and: .zvRegularCaption3)
    private let cardView: AnimalCardView = {
        let view = AnimalCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) { super.init(frame: frame); layout() }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public func layout() {
        addSubview(titleLabel)
        addSubview(cardView)

        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        cardView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }

    public func setup(onClick clickClosure: @escaping (() -> Void)) {
        titleLabel.text = "Питомец"
        cardView.setup(onClick: clickClosure)
    }

    private final class AnimalCardView: ShadowCardView {

        private let avatarImageView: UIImageView = createView {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        private let nameLabel: UILabel = createLabel(with: .zvGray2, and: .zvMediumFootnote)
        private let descriptionLabel: UILabel = createLabel(with: .zvGray1, and: .zvRegularCaption2)

        init() { super.init(with: .init(cornerRadius: 8, shadowRadius: 4)); layout() }

        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

        public func layout() {
            contentView.addSubview(avatarImageView)
            contentView.addSubview(nameLabel)
            contentView.addSubview(descriptionLabel)

            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            avatarImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 12).isActive = true

            descriptionLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        }

        public func setup(onClick clickClosure: @escaping (() -> Void)) {
            self.onClick = clickClosure

            nameLabel.text = "Томас"
            descriptionLabel.text = "Кот, жесткий"
            avatarImageView.kf.setImage(with: URL(string: "https://demotivation.ru/wp-content/uploads/2020/11/zwalls.ru-51679.jpg"))
        }
    }
}

// MARK: profile view
fileprivate final class ProfileView: UIView {

    private let titleLabel: UILabel = createLabel(with: .zvGray3, and: .zvRegularCaption3)
    private let cardView: ProfileCardView = {
        let view = ProfileCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) { super.init(frame: frame); layout() }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public func layout() {
        addSubview(titleLabel)
        addSubview(cardView)

        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        cardView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }

    public func setup(onClick clickClosure: @escaping (() -> Void)) {
        titleLabel.text = "Заказчик"

        cardView.setup(onClick: clickClosure)
    }

    private final class ProfileCardView: ShadowCardView {

        private let avatarImageView: UIImageView = createView {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }

        private let nameLabel: UILabel = createLabel(with: .zvGray2, and: .zvMediumFootnote)

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

        public init() { super.init(with: .init(cornerRadius: 8, shadowRadius: 4)); layout() }
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

        public func layout() {
            contentView.addSubview(avatarImageView)
            contentView.addSubview(nameLabel)
            contentView.addSubview(ratingView)

            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            avatarImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 12).isActive = true

            ratingView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
            ratingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        }

        public func setup(onClick clickClosure: @escaping (() -> Void)) {
            self.onClick = clickClosure

            nameLabel.text = "Иван"
            ratingView.rating = 2.5
            avatarImageView.kf.setImage(with: URL(string: "https://demotivation.ru/wp-content/uploads/2020/11/zwalls.ru-51679.jpg"))
        }
    }
}
