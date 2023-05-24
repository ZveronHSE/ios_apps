//
//  FavoriteViewHeader.swift
//  iosapp
//
//  Created by alexander on 09.05.2022.
//

import Foundation
import UIKit
import RxSwift

class FavoriteHeaderView: UIView {
    private let disposeBag = DisposeBag()
    private var isRendered = false

    let dataSourceWillSelect: PublishSubject<FavoriteSourceType> = PublishSubject()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        bindView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var favoriteTypesCellHeight: CGFloat {
        let pandingHeight = 12.0
        let text = FavoriteSourceType.vendor.getUIDesc()
        return text.height(constraintedWidth: 0, font: Font.robotoRegular12) + pandingHeight * 2
    }

    private var pageName: UILabel = {
        let label = UILabel()
        label.font = Font.robotoSemiBold28
        label.textColor = Color1.gray5
        label.text = "Избранное"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var settingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Icon.settings, for: .normal)
        button.tintColor = .black
        button.disable()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var favoriteTypes: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FavoriteTypeCell.self, forCellWithReuseIdentifier: FavoriteTypeCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.reloadData()
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)

        return collectionView
    }()

    private func layout() {
        addSubview(pageName)
        addSubview(settingButton)
        addSubview(favoriteTypes)

        pageName.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pageName.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true

        settingButton.centerYAnchor.constraint(equalTo: pageName.centerYAnchor).isActive = true
        settingButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true

        favoriteTypes.topAnchor.constraint(equalTo: pageName.bottomAnchor, constant: 24).isActive = true
        favoriteTypes.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        favoriteTypes.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        favoriteTypes.heightAnchor.constraint(equalToConstant: favoriteTypesCellHeight).isActive = true
        favoriteTypes.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    }

    func bindView() {
        favoriteTypes.rx.itemSelected
            .map { FavoriteSourceType.allCases[$0.item] }
            .bind(to: dataSourceWillSelect)
            .disposed(by: disposeBag)
    }

    func selectedSourceType() -> FavoriteSourceType {
        let idx = self.favoriteTypes.indexPathsForSelectedItems?.first?.item ?? 0
        return FavoriteSourceType.allCases[idx]
    }

    func rerenderCollectionViewItems() {
        if isRendered { return }

        for i in 1..<FavoriteSourceType.allCases.count {
            (self.favoriteTypes.cellForItem(at: IndexPath(item: i, section: 0)) as? FavoriteTypeCell)?.selected()
            (self.favoriteTypes.cellForItem(at: IndexPath(item: i, section: 0)) as? FavoriteTypeCell)?.unselected()
        }

        isRendered.toggle()
    }
}

extension FavoriteHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return FavoriteSourceType.allCases.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteTypeCell.reuseID, for: indexPath) as? FavoriteTypeCell else {
            fatalError("")
        }

        cell.label.text = FavoriteSourceType.allCases[indexPath.item].getUIDesc()
        if indexPath.item == 0 { cell.selected() } else { cell.unselected() }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.4) {
            cell?.alpha = 0.5
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.4) {
            cell?.alpha = 1.0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let pandingWidth = 24.0
        let text = FavoriteSourceType.allCases[indexPath.item].getUIDesc()
        let currentWidth = text.width(constraintedHeight: 0, font: Font.robotoRegular12) + pandingWidth * 2

        return CGSize(width: currentWidth, height: favoriteTypesCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FavoriteTypeCell else { return }
        cell.selected()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FavoriteTypeCell else { return }
        cell.unselected()
    }
}
