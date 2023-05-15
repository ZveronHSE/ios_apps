//
//  OrderFeedViewController.swift
//  specialist
//
//  Created by alexander on 27.03.2023.
//

import Foundation
import UIKit
import SpecialistDomain
import RxSwift
import RxCocoa
import RxDataSources

final class OrderFeedViewController: UIViewController {
    let disposeBag = DisposeBag()

    private lazy var searchBar: CustomSearchBar = {
        let view = CustomSearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let view = UICollectionViewFlowLayout()
        view.minimumLineSpacing = 16
        view.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return view
    }()

    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление ...")
        refreshControl.tintColor = .zvGray3
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        return refreshControl
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.backgroundColor = .clear
        view.register(OrderPreviewCell.self)
        view.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 10, right: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.refreshControl = self.refreshControl
        return view
    }()

    private var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hide(animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .zvBackground
        navigationController?.isNavigationBarHidden = true
        layout()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    private func layout() {
        let paddings = UIEdgeInsets(top: 60, left: 16, bottom: 0, right: -16)

        view.addSubview(collectionView)
        view.addSubview(searchBar)
        view.addSubview(activityIndicator)

        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: paddings.top).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: paddings.left).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: paddings.right).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true

        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension OrderFeedViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right)
        return CGSize(width: width, height: 130)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.select(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.unselect(animated: true)
    }
}

// MARK: bind viewcontroller to viewmodel
extension OrderFeedViewController: BindableView {
    typealias ViewModelType = OrderFeedViewModel

    func createInput() -> OrderFeedViewModel.Input {

        let viewDidLoad = rx.sentMessage(#selector(UIViewController.viewDidLoad))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let dataWillRetry = refreshControl.rx.controlEvent(.valueChanged)
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let initDataTrigger = Driver.merge(viewDidLoad, dataWillRetry)

        let fetchDataTrigger = collectionView.rx.willDisplayCell.asDriver().flatMap { (_, indexPathCurentOrder) in
            let idxCurrentOrder = indexPathCurentOrder.item
            let idxLastOrder = self.collectionView.numberOfItems(inSection: 0) - 1

            return Observable<Void>.create { observer in
                if idxCurrentOrder > idxLastOrder - 15 { observer.onNext(Void()) }
                return Disposables.create()
            }.mapToVoid().asDriverOnErrorJustComplete()
        }.throttle(.milliseconds(500), latest: false)

        let itemSelectTrigger = self.collectionView.rx.itemSelected.asDriver()

        return .init(
            initDataTrigger: initDataTrigger.debug("init data trigger", trimOutput: true),
            fetchDataTrigger: fetchDataTrigger.debug("fetch data trigger", trimOutput: true),
            itemSelectTrigger: itemSelectTrigger.debug("item select trigger", trimOutput: true)
        )
    }

    func bind(to viewModel: OrderFeedViewModel) {
        let input = createInput()
        let output = viewModel.transform(input: input)

        output.dataLoaded
            .drive(onNext: { self.refreshControl.endRefreshing() })
            .disposed(by: disposeBag)

        output.items.map { [CustomSectionModel(key: "orderSection", items: $0)] }
            .drive(collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)

        output.itemSelected.drive().disposed(by: disposeBag)

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
        }).disposed(by: disposeBag)
    }
}

// MARK: datasource
extension OrderFeedViewController {
    private func createDataSource() -> RxCollectionViewSectionedAnimatedDataSource<CustomSectionModel<OrderPreview>> {
        return .init(
// TODO: Необходимо продумать механизм определения отпускания экрана при обновлении, и сеттинге данных только после этого
            decideViewTransition: { _, _, _ in return .reload },
            configureCell: { _, cv, indexPath, item in
                let cell: OrderPreviewCell = cv.createCell(by: indexPath)
                cell.setup(with: item)
                return cell
            }
        )
    }
}
