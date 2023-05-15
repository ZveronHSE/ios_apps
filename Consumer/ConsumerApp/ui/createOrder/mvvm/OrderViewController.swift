//
//  OrderViewController.swift
//  ConsumerApp
//
//  Created by alexander on 12.05.2023.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import ConsumerDomain

class TypeOrdersConverter: Converter {
    func convertToResult(_ value: String) -> OrderType {
        return OrderType.init(rawValue: value)!
    }

    typealias Value = OrderType

    func allValues() -> [String] {
        return OrderType.allCases.map { $0.rawValue }
    }
}

class OrderViewController: UIViewController {
    private let viewModel = ViewModelFactory.get(OrderViewModel.self)
    private let disposeBag = DisposeBag()
    private var type: OrderType? = .active

    private let items = PublishSubject<[OrderPreview]>()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setUp()
        bindViews()
    }

    private let addBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let groupButtons: RadioButtonGroup = {
        let v = RadioButtonGroup(converter: TypeOrdersConverter())
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()



    private var flowLayout: UICollectionViewFlowLayout = {
        let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = sectionInsets
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 78, right: 0)
        view.register(OrderPreviewCell.self, forCellWithReuseIdentifier: OrderPreviewCell.reusableIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func layout() {
        view.addSubview(groupButtons)
        view.addSubview(collectionView)

        groupButtons.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        groupButtons.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true

        collectionView.topAnchor.constraint(equalTo: groupButtons.bottomAnchor, constant: 28).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        collectionView.delegate = self

        view.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.frame.height / 8)).isActive = true
    }

    func bindViews() {
        addBtn.rx.tap.subscribe { _ in
            let addingVC = CreateOrderFirstViewController()
            let navAddingVC = UINavigationController(rootViewController: addingVC)
            navAddingVC.modalPresentationStyle = .fullScreen
            self.present(navAddingVC, animated: true, completion: nil)
        }.disposed(by: disposeBag)

        groupButtons.callback = {
            guard let type = $0 as? OrderType else { return }
            self.type = type
            self.viewModel.usecase.getCreatedOrders(type: type).asDriverOnErrorJustComplete().drive(onNext: {
                self.items.onNext($0)
            }).disposed(by: self.disposeBag)
        }

        let ds = RxCollectionViewSectionedAnimatedDataSource<CustomSectionModel<OrderPreview>> { _, collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OrderPreviewCell.reusableIdentifier,
                for: indexPath) as? OrderPreviewCell
                else {
                fatalError("")
            }

            cell.setup(model)
            return cell
        }

        items.asObservable()
            .map { [.init(key: "123", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: ds)).disposed(by: disposeBag)

        items.asObservable().subscribe(onNext: { item in
            if item.isEmpty {
                self.emptyLabel.text = self.type  == .active ? "Нет активных заказов" : "Нет завершенных заказов"
                self.emptyLabel.show(animated: true)
            } else {
                self.emptyLabel.hide(animated: true)
            }

        }).disposed(by: disposeBag)
    }

    private lazy var emptyLabel: UILabel = {
        let v = UILabel()
        v.font = Font.robotoRegular17
        v.textColor = Color1.gray3
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Нет активных заказов"
        v.hide(animated: false)
        return v
    }()

    func setUp() {
        addBtn.layer.cornerRadius = Corner.mainButton.rawValue
        addBtn.setTitle("Создать заказ", for: .normal)
        addBtn.contentHorizontalAlignment = .center
        addBtn.setTitleColor(.white, for: .normal)
        view.addSubview(addBtn)

        addBtn.heightAnchor.constraint(equalToConstant: 52).isActive = true
        addBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16).isActive = true
        addBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        addBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        addBtn.layoutIfNeeded()
        addBtn.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
    }

    override func viewWillAppear(_ animated: Bool) {

        let ds = RxCollectionViewSectionedReloadDataSource<SectionModel<String, OrderPreview>> { _, collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OrderPreviewCell.reusableIdentifier,
                for: indexPath) as? OrderPreviewCell
                else {
                fatalError("")
            }

            cell.setup(model)
            return cell
        }

        viewModel.usecase.getCreatedOrders(type: type!).asDriverOnErrorJustComplete().drive(onNext: {
            self.items.onNext($0)
        }).disposed(by: self.disposeBag)
    }
}

extension OrderViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let padding = flowLayout.sectionInset.left + flowLayout.sectionInset.right

        let cellWidth = self.collectionView.frame.width - padding
        let cellHeight = CellHeight.lotTableCell.height

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            collectionView.cellForItem(at: indexPath)?.plainView.alpha = 0.5
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            collectionView.cellForItem(at: indexPath)?.plainView.alpha = 1.0
        }
    }
}


protocol SectionItemType: IdentifiableType, Equatable where Identity == Int { }

struct CustomSectionModel<SectionItem: SectionItemType> {
    var key: String
    var items: [SectionItem]
}

extension CustomSectionModel: AnimatableSectionModelType {
    init(original: CustomSectionModel<SectionItem>, items: [SectionItem]) {
        self = original
        self.items = items
    }

    var identity: String { self.key }
}

extension OrderPreview: SectionItemType {
    public var identity: Int { self.id }

    public static func == (lhs: OrderPreview, rhs: OrderPreview) -> Bool { lhs.id == rhs.id }
}
