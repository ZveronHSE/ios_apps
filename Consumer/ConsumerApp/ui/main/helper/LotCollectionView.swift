//
//  LotCollectionView.swift
//  iosapp
//
//  Created by alexander on 02.05.2022.
//

import Foundation
import UIKit
import RxDataSources
import RxSwift
import CoreGRPC
import ZveronNetwork

class LotCollectionView: UIView, UICollectionViewDelegateFlowLayout {


    let favoriteTrigger = PublishSubject<IndexPath>()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление ...")
        refreshControl.tintColor = Color.tabBarTintColor.color
        return refreshControl
    }()

    private var layout: UICollectionViewFlowLayout = {
        let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = sectionInsets
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.backgroundScreen.color
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.register(
            LotCell.self,
            forCellWithReuseIdentifier: LotCell.reusableIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.refreshControl = refresh
        return collectionView
    }()

    private func setupViews() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.delegate = self
    }

    private var presentMode: PresentModeType?
    private weak var privateViewModel: NestingViewModelCollectionView?
    internal func bindViews(_ viewModel: NestingViewModelCollectionView) {

        favoriteTrigger.subscribe(onNext: {
            viewModel.updateFavoriteState(by: $0)
        }).disposed(by: viewModel.disposeBag)

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CoreGRPC.Lot>> { _, collectionView, indexPath, lot in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LotCell.reusableIdentifier,
                for: indexPath) as? LotCell
                else {
                fatalError("")
            }

            cell.setup(with: lot)
            cell.favoriteButton.rx.tap.mapToVoid()
                .subscribe(onNext: {
                    if TokenAcquisitionService.shared.authState == .authorized || TokenAcquisitionService.shared.authState == .needUpdateAccess {
                        cell.isFavorite.toggle()
                    }

                    self.favoriteTrigger.onNext(indexPath)
                })
                .disposed(by: cell.disposeBag)
            return cell
        }
        // Мапинг данных из вью-модел на дата сет
        viewModel.lots.map { lot in
            return [SectionModel(model: "", items: lot)]
        }.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: viewModel.disposeBag)

        // Привязка рефреш-вью к обновлению ленты
        refresh.rx.controlEvent(.valueChanged).bind(onNext: {
            viewModel.updateLots()
        }).disposed(by: viewModel.disposeBag)

        // Привязка окончания обновления ленты к концу показа рефреш-вью
        viewModel.endLoadData.bind(onNext: { _ in
            self.refresh.endRefreshing()
        }).disposed(by: viewModel.disposeBag)

        // привязка изменения состояния показа на рефреш всей даты
        viewModel.presentationModeType.bind(onNext: { _ in
            self.collectionView.performBatchUpdates { self.collectionView.reloadData() }
        }).disposed(by: viewModel.disposeBag)

        // Привязка нажатия на ячейку на модель
        collectionView.rx.itemSelected.bind(onNext: { index in
            viewModel.getCurrentLot(index: index.item)
        }).disposed(by: viewModel.disposeBag)

        // Обработка события о текущей видимой ячейки
        collectionView.rx.willDisplayCell.bind(onNext: { pair in
            guard viewModel.fetchAllLots.value == false else { return }
            let currentLot = pair.at.row
            let lastLot = self.collectionView.numberOfItems(inSection: 0)
            if currentLot > lastLot - 10 { viewModel.fetchLots() }
        }).disposed(by: viewModel.disposeBag)

        // создание события на скроллинг ленты
        collectionView.rx.didScroll.map {
            self.collectionView.contentOffset.y
        }.bind(to: viewModel.currentOffset).disposed(by: viewModel.disposeBag)

        viewModel.needToDisplayTop.bind { _ in
            self.collectionView.contentOffset = CGPoint(x: 0, y: 0)
        }.disposed(by: viewModel.disposeBag)

        // Вынужденный костыль
        privateViewModel = viewModel
    }

    func setHeaderSize(size: CGSize = CGSize(width: 0, height: 0)) {
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = size
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: size.height, left: 4, bottom: 0, right: -4)
    }

    // Вынужденный костыль
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let isTable = privateViewModel?.presentationModeType.value ?? .grid == .table
        let numerColumns = isTable ? 1.0 : 2.0
        let padding = layout.sectionInset.left + layout.sectionInset.right + (numerColumns - 1.0) * layout.minimumInteritemSpacing
        let cellWidth = (self.collectionView.frame.width - padding) / numerColumns
        let cellHeight = isTable ? CellHeight.lotTableCell.height : CellHeight.lotCell.height
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
