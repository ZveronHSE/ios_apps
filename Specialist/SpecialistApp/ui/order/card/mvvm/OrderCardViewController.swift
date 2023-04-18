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
import RxSwift
import RxCocoa

final class OrderCardViewController: UIViewController {
    let disposeBag = DisposeBag()
    private let backClickTrigger = PublishSubject<Void>()
    private let animalProfileClickTrigger = PublishSubject<Void>()
    private let customerProfileClickTrigger = PublishSubject<Void>()

    private let scrollView: UIScrollView = createView {
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }

    private let continueButton: UIButton = createButton {
        $0.setTitleColor(.zvWhite, for: .normal)
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
    private let similarOrdersView: SimilarOrdersView = createView()
    private let activityIndicator: UIActivityIndicatorView = createActivityIndicator()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .zvBackground
        navigationItem.leftBarButtonItem = createNavigationButton(type: .back) { [weak self] in
            self?.backClickTrigger.onNext(Void())
        }

        layoutScrollView()
        layoutContentView()
    }

    private func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(continueButton)
        view.addSubview(activityIndicator)

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

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
        contentView.addSubview(similarOrdersView)

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

        similarOrdersView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 40).isActive = true
        similarOrdersView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        similarOrdersView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        similarOrdersView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    public func setup(with model: Order) {
        navigationItem.title = model.title
        continueButton.setTitle("Откликнуться", for: .normal)
        headerView.setup(with: model.title, and: model.price, and: model.createdDate)
        addressView.setup(with: model.address)
        serviceDateView.setup(with: "Дата оказания услуги", and: model.serviceDate)
        serviceTimeView.setup(with: "Время оказания услуги", and: model.serviceTime)
        animalView.setup(
            model: model.animalPreview,
            onClick: { [weak self] in self?.animalProfileClickTrigger.onNext(Void()) }
        )
        profileView.setup(
            model: model.customerPreview,
            onClick: { [weak self] in self?.customerProfileClickTrigger.onNext(Void()) }
        )
        descriptionView.setup(with: "Описание", and: model.description)
        similarOrdersView.setup(with: model.similarOrders)
        model.availableResponse ? continueButton.enable(animated: false) : continueButton.disable(animated: false)
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

    public func setup(with title: String, and price: String, and createdDate: String) {
        titleLabel.text = title
        priceLabel.text = price
        publishDateLabel.text = createdDate
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

    public func setup(with model: OrderAddress) {
        titleLabel.text = "Адрес"
        cityLabel.text = model.town
        metroStationColor.backgroundColor = UIColor(hexString: model.color)
        metroStationLabel.text = model.station
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

    public func setup(model: OrderAnimalPreview, onClick clickClosure: @escaping (() -> Void)) {
        titleLabel.text = "Питомец"
        cardView.setup(model: model, onClick: clickClosure)
    }

    private final class AnimalCardView: ShadowCardView {

        private let avatarImageView: UIImageView = createView {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        private let nameLabel: UILabel = createLabel(with: .zvGray2, and: .zvMediumFootnote) {
            $0.textAlignment = .left
            $0.lineBreakMode = .byTruncatingTail
        }
        private let descriptionLabel: UILabel = createLabel(with: .zvGray1, and: .zvRegularCaption2) {
            $0.textAlignment = .left
            $0.lineBreakMode = .byTruncatingTail
        }

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
            descriptionLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        }

        public func setup(model: OrderAnimalPreview, onClick clickClosure: @escaping (() -> Void)) {
            self.onClick = clickClosure

            nameLabel.text = model.name
            descriptionLabel.text = model.breed + ", " + model.species
            avatarImageView.kf.setImage(with: model.imageUrl)
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

    public func setup(model: OrderCustomerPreview, onClick clickClosure: @escaping (() -> Void)) {
        titleLabel.text = "Заказчик"
        cardView.setup(model: model, onClick: clickClosure)
    }

    private final class ProfileCardView: ShadowCardView {

        private let avatarImageView: UIImageView = createView {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }

        private let nameLabel: UILabel = createLabel(with: .zvGray2, and: .zvMediumFootnote) {
            $0.textAlignment = .left
            $0.lineBreakMode = .byTruncatingTail
        }

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

        public func setup(model: OrderCustomerPreview, onClick clickClosure: @escaping (() -> Void)) {
            self.onClick = clickClosure

            nameLabel.text = model.name
            ratingView.rating = model.rating
            avatarImageView.kf.setImage(with: model.imageUrl)
        }
    }
}

// MARK: SimilarOrdersView
fileprivate final class SimilarOrdersView: UIView {
    private let disposeBag = DisposeBag()
    private let submittedSimilarOrder = PublishSubject<[OrderPreview]>()
    let itemSelectTrigger = PublishSubject<IndexPath>()

    private lazy var titleLabel: UILabel = createLabel(with: .zvBlack, and: .zvMediumTitle2)

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayoutWrapper(cellSize: OrderPreviewCell.cellSize)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(OrderPreviewCell.self)
        collectionView.delegate = layout
        collectionView.backgroundColor = .zvBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.clipsToBounds = false
        return collectionView
    }()

    override init(frame: CGRect) { super.init(frame: frame); layout(); bindView() }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public func layout() {
        addSubview(titleLabel)
        addSubview(collectionView)

        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true

        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: OrderPreviewCell.cellSize.height).isActive = true
    }

    private func bindView() {
        submittedSimilarOrder.bind(to: collectionView.rx.items) { cv, index, orderPreview in
            let cell: OrderPreviewCell = cv.createCell(by: index)
            cell.setup(with: orderPreview)
            return cell
        }.disposed(by: disposeBag)

        collectionView.rx.itemSelected.bind(to: itemSelectTrigger).disposed(by: disposeBag)
    }

    public func setup(with similarOrders: [OrderPreview]) {
        self.titleLabel.text = "Похожие услуги"
        self.submittedSimilarOrder.onNext(similarOrders)
    }
}

extension OrderCardViewController: BindableView {
    private func createInput() -> OrderCardViewModel.Input {
        return .init(
            backClickTrigger: backClickTrigger.asDriverOnErrorJustComplete()
                .debug("back click trigger", trimOutput: true),
            animalProfileClickTrigger: animalProfileClickTrigger.asDriverOnErrorJustComplete()
                .debug("animal profile click trigger", trimOutput: true),
            customerProfileClickTrigger: customerProfileClickTrigger.asDriverOnErrorJustComplete()
                .debug("customer profile click trigger", trimOutput: true),
            similarOrderClickTrigger: similarOrdersView.itemSelectTrigger.asDriverOnErrorJustComplete()
                .debug("similar order click trigger", trimOutput: true)
        )
    }

    func bind(to viewModel: OrderCardViewModel) {
        self.setup(with: viewModel.model)

        let input = createInput()
        let output = viewModel.transform(input: input)

        output.backClicked.drive().disposed(by: disposeBag)
        output.animalProfileClicked.drive().disposed(by: disposeBag)
        output.customerProfileClicked.drive().disposed(by: disposeBag)
        output.similarOrderClicked.drive().disposed(by: disposeBag)

        output.activityIndicator.drive(onNext: { isActive in
            if isActive {
                self.activityIndicator.startAnimating()
                self.activityIndicator.show(animated: true)
            } else {
                self.activityIndicator.hide(animated: true) { _ in self.activityIndicator.stopAnimating() }
            }
        }).disposed(by: disposeBag)

        // TODO: Сделать обработку ошибок на ui
        output.errors.drive(onNext: { _ in
            print("Ошибка при загрузке карточки заказа")
            print("Ошибка при загрузке профиля питомца или заказчика")
        }).disposed(by: disposeBag)
    }
}
