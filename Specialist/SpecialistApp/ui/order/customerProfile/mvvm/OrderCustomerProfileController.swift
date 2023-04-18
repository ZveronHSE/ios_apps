//
//  OrderCustomerProfile.swift
//  SpecialistApp
//
//  Created by alexander on 14.04.2023.
//

import Foundation
import UIKit
import RxSwift
import SpecialistDomain
import RxDataSources

final class OrderCustomerProfileController: UIViewController {
    let disposeBag = DisposeBag()
    private let backClickTrigger = PublishSubject<Void>()
    private let sourceSelectTrigger = PublishSubject<ProfileFeedSource>()

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let view = UICollectionViewFlowLayout()
        view.minimumLineSpacing = 20
        view.sectionHeadersPinToVisibleBounds = true
        view.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.backgroundColor = .clear

        view.register(OrderPreviewCell.self)
        view.registerHeader(CustomerInfoHeader.self)
        view.registerHeader(FeedHeader.self)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    private lazy var emptyLabel: UILabel = createLabel(with: .zvGray1, and: .zvRegularBody) { $0.hide(animated: false) }
    private let activityIndicator: UIActivityIndicatorView = createActivityIndicator()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .zvBackground
        navigationItem.leftBarButtonItem = createNavigationButton(type: .back) { [weak self] in
            self?.backClickTrigger.onNext(Void())
        }
        navigationItem.title = "Профиль заказчика"
        emptyLabel.text = "Нет активных заказов"

        layout()
    }

    private func layout() {
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        view.addSubview(activityIndicator)

        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / 6).isActive = true

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension OrderCustomerProfileController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right)
        let height = SectionInfo(rawValue: indexPath.section)!.sectionType().cellSize.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.select(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.unselect(animated: true)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int { SectionInfo.allCases.count }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return SectionInfo(rawValue: section)!.sectionInset()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        switch SectionInfo(rawValue: section)! {
        case .feed: return CGSize(width: collectionView.frame.width, height: SectionInfo(rawValue: section)!.headerHeight())
        case .customerInfo:
            let height = CustomerInfoHeader.processFitHeight(widthScreen: view.frame.width, fullname: "Galanov Alexander Sergeevich")
            return CGSize(width: collectionView.frame.width, height: height)
        }
    }
}

private enum SectionInfo: Int, CaseIterable {
    case customerInfo
    case feed

    func headerHeight() -> CGFloat {
        switch self {
        case .customerInfo: return 240
        case .feed: return 28 /*buttons height*/ + 16 * 2 /*vertical padding*/
        }
    }

    func sectionInset() -> UIEdgeInsets {
        switch self {
        case .customerInfo: return .zero
        case .feed: return .zero // .init(top: 32, left: 0, bottom: 0, right: 0)
        }
    }

    func headerType() -> ReusableHeader.Type {
        switch self {
        case .customerInfo: return CustomerInfoHeader.self
        case .feed: return FeedHeader.self
        }
    }

    func sectionType() -> ReusableCell.Type {
        switch self {
        case .customerInfo: fatalError("this section does not hase a cell type")
        case .feed: return OrderPreviewCell.self
        }
    }
}

extension OrderCustomerProfileController: BindableView {

    private func createInput() -> OrderCustomerProfileViewModel.Input {

        let sourceSelectTrigger = self.sourceSelectTrigger.startWith(.actived).asDriverOnErrorJustComplete()
        let itemSelectTrigger = self.collectionView.rx.itemSelected.asDriver()

        return .init(
            backClickTrigger: backClickTrigger.asDriverOnErrorJustComplete()
                .debug("back click trigger", trimOutput: true),
            sourceSelectTrigger: sourceSelectTrigger.debug("source select trigger", trimOutput: true),
            itemSelectTrigger: itemSelectTrigger.debug("item select trigger", trimOutput: true)
        )
    }

    func bind(to viewModel: OrderCustomerProfileViewModel) {
        let input = createInput()
        let output = viewModel.transform(input: input)

        output.backClicked.drive().disposed(by: disposeBag)

        output.items
            .map { [.init(key: "emptySection", items: []), .init(key: "orderSection", items: $0)] }
            .drive(collectionView.rx.items(dataSource: createDataSource(viewModel)))
            .disposed(by: disposeBag)

        output.items.delay(.milliseconds(1)).withLatestFrom(input.sourceSelectTrigger) { items, type in
            return (items.isEmpty, type)
        }.drive(onNext: { (isEmpty, type) in
            if isEmpty {
                self.emptyLabel.text = type == .actived ? "Нет активных заказов" : "Нет завершенных заказов"
                self.emptyLabel.show(animated: true)
            } else {
                self.emptyLabel.hide(animated: true)
            }

        }).disposed(by: disposeBag)

        output.itemSelected.drive().disposed(by: disposeBag)

        output.activityIndicator.drive(onNext: { isActive in
            if isActive {
                self.activityIndicator.startAnimating()
                self.activityIndicator.show(animated: true)
            } else {
                self.activityIndicator.hide(animated: true) { _ in self.activityIndicator.stopAnimating() }
            }
        }).disposed(by: disposeBag)

        // TODO: Сделать обработку ошибок ui
        output.errors.drive(onNext: { _ in
        }).disposed(by: disposeBag)
    }
}

// MARK: datasource
extension OrderCustomerProfileController {
    private func createDataSource(_ viewModel: OrderCustomerProfileViewModel) -> RxCollectionViewSectionedAnimatedDataSource<CustomSectionModel<OrderPreview>> {
        return .init(
            configureCell: { _, cv, indexPath, item in
                let cell: OrderPreviewCell = cv.createCell(by: indexPath)
                cell.setup(with: item)
                return cell
            },
            configureSupplementaryView: { _, cv, _, indexPath in
                switch SectionInfo(rawValue: indexPath.section)! {
                case .customerInfo:
                    let header: CustomerInfoHeader = cv.createHeader(by: indexPath)
                    header.setup(with: viewModel.model)
                    return header
                case .feed:
                    let header: FeedHeader = cv.createHeader(by: indexPath)
                    header.selectFeedSourceTrigger.drive(self.sourceSelectTrigger).disposed(by: self.disposeBag)
                    return header
                }
            }
        )
    }
}
