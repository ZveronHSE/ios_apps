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

final class OrderCustomerProfileController: UIViewController {

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

        // view.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 10, right: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        return view
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .zvBackground
        navigationItem.leftBarButtonItem = createNavigationButton(type: .back) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        navigationItem.rightBarButtonItem = createNavigationButton(type: .setting) { [weak self] in
        }

        layout()
        bindViews()
    }

    private func layout() {
        view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    public func setup() {
        navigationItem.title = "Профиль заказчика"
    }

    public func bindViews() {}
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

// TODO: Не забыть удалить когда будет подключение к беку
extension OrderCustomerProfileController: UICollectionViewDataSource {
    var testData: [OrderPreview] {
        return [
            OrderPreview(
                title: "Стрижка кота",
                price: "500 ₽",
                city: "г. Москва",
                metroStation: "Водный стадион",
                metroColor: "#1FBF2F",
                orderPeriod: "29 Дек. - 31 Дек. 2023",
                publishDate: "Cегодня 9:34",
                animalName: "Томас",
                animalDesciption: "Кот, Британец",
                animalImageLink: "https://klike.net/uploads/posts/2019-06/medium/1561011184_2.jpg"
            ),
            OrderPreview(
                title: "Стрижка cобаки",
                price: "1000 ₽",
                city: "г. Москва",
                metroStation: "Пражская",
                metroColor: "#808080",
                orderPeriod: "29 Дек. - 31 Дек. 2023",
                publishDate: "Cегодня 9:34",
                animalName: "Бобик",
                animalDesciption: "Собака, маленький зверенок",
                animalImageLink: "https://placepic.ru/wp-content/uploads/2019/06/7733.jpg"
            ),
            OrderPreview(
                title: "Стрижка пиписьки",
                price: "1000 ₽",
                city: "г. Москва",
                metroStation: "Пражская",
                metroColor: "#808080",
                orderPeriod: "29 Дек. - 31 Дек. 2023",
                publishDate: "Cегодня 9:34",
                animalName: "Сучка",
                animalDesciption: "Собака, реальная сучка",
                animalImageLink: "https://placepic.ru/wp-content/uploads/2019/06/7733.jpg"
            ),
            OrderPreview(
                title: "Стрижка собаки",
                price: "1000 ₽",
                city: "г. Москва",
                metroStation: "Пражская",
                metroColor: "#808080",
                orderPeriod: "29 Дек. - 31 Дек. 2023",
                publishDate: "Cегодня 9:34",
                animalName: "Сучка",
                animalDesciption: "Собака, реальная сучка",
                animalImageLink: "https://placepic.ru/wp-content/uploads/2019/06/7733.jpg"
            ),
            OrderPreview(
                title: "Стрижка собаки",
                price: "1000 ₽",
                city: "г. Москва",
                metroStation: "Пражская",
                metroColor: "#808080",
                orderPeriod: "29 Дек. - 31 Дек. 2023",
                publishDate: "Cегодня 9:34",
                animalName: "Сучка",
                animalDesciption: "Собака, реальная сучка",
                animalImageLink: "https://placepic.ru/wp-content/uploads/2019/06/7733.jpg"
            ),
            OrderPreview(
                title: "Стрижка собаки",
                price: "1000 ₽",
                city: "г. Москва",
                metroStation: "Пражская",
                metroColor: "#808080",
                orderPeriod: "29 Дек. - 31 Дек. 2023",
                publishDate: "Cегодня 9:34",
                animalName: "Сучка",
                animalDesciption: "Собака, реальная сучка",
                animalImageLink: "https://placepic.ru/wp-content/uploads/2019/06/7733.jpg"
            )
        ]
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 0
        case 1: return testData.count
        default: break
        }

        return testData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch SectionInfo(rawValue: indexPath.section)! {
        case .feed:
            let cell: OrderPreviewCell = collectionView.createCell(by: indexPath)
            cell.setup(with: testData[indexPath.item])
            return cell
        default: fatalError("")
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch SectionInfo(rawValue: indexPath.section)! {
        case .customerInfo:
            let header: CustomerInfoHeader = collectionView.createHeader(by: indexPath)
            header.setup()
            return header
        case .feed:
            let header: FeedHeader = collectionView.createHeader(by: indexPath)
            return header
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
        case .customerInfo: return EmptyCell.self
        case .feed: return OrderPreviewCell.self
        }
    }
}

final class EmptyCell: UICollectionViewCell, ReusableCell {
    static var reuseID: String = ""
    static var cellSize: CGSize = .zero
}
