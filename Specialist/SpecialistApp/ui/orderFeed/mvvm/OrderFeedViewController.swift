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
import RxDataSources

final class OrderFeedViewController: UIViewController {
    private let dis = DisposeBag()

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

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.backgroundColor = .clear
        view.register(OrderCell.self, forCellWithReuseIdentifier: OrderCell.reuseID)
        view.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 10, right: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        return view
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bindView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    private func layout() {
        let paddings = UIEdgeInsets(top: 60, left: 16, bottom: 0, right: -16)

        navigationController?.isNavigationBarHidden = true

        view.addSubview(collectionView)
        view.addSubview(searchBar)

        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: paddings.top).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: paddings.left).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: paddings.right).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true

        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func bindView() {
        collectionView.rx.itemSelected.subscribe(onNext: { _ in
            let vc = OrderCardViewController()
            // vc.setup(with: <#T##Order#>)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }).disposed(by: dis)
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

// TODO: Не забыть удалить когда будет подключение к беку
extension OrderFeedViewController: UICollectionViewDataSource {
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
        return testData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderCell.reuseID, for: indexPath) as? OrderCell else { fatalError("") }

        cell.setup(with: testData[indexPath.item])

        return cell
    }
}
