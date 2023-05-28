//
//  AdsViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 28.04.2022.
//

import UIKit
import BottomSheet
import RxSwift
import CoreGRPC


class AdsViewController: UIViewControllerWithAuth  {
    
    private let viewModel = ViewModelFactory.get(AdsViewModel.self)
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color1.background
        collectionView.showsHorizontalScrollIndicator = false
        // collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.register(AdsViewCell.self, forCellWithReuseIdentifier: "lotCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        //        refreshControl.attributedTitle = NSAttributedString(string: "Обновление ...")
        //        refreshControl.tintColor = .zvGray3
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        return refreshControl
    }()
    
    private let addLotBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let lots = [
//            Lot.with({
//                $0.title = "dsfdfsfdfs"
//                $0.price = "10000"
//                $0.status = .closed
//                $0.imageURL = "https://storage.yandexcloud.net/zveron-profile/229d880b-787f-440c-b077-5e72244ec788"
//            }),
//            Lot.with({
//                $0.title = "dsfdfsfdfs"
//                $0.price = "10000"
//                $0.status = .active
//                $0.imageURL = "https://storage.yandexcloud.net/zveron-profile/229d880b-787f-440c-b077-5e72244ec788"
//            }),
//            Lot.with({
//                $0.title = "dsfdfsfdfs"
//                $0.price = "10000"
//                $0.status = .canceled
//                $0.imageURL = "https://storage.yandexcloud.net/zveron-profile/229d880b-787f-440c-b077-5e72244ec788"
//            }),
//            Lot.with({
//                $0.title = "dsfdfsfdfs"
//                $0.price = "10000"
//                $0.imageURL = "https://storage.yandexcloud.net/zveron-profile/229d880b-787f-440c-b077-5e72244ec788"
//            }),
//            Lot.with({
//                $0.title = "dsfdfsfdfs"
//                $0.price = "10000"
//                $0.imageURL = "https://storage.yandexcloud.net/zveron-profile/229d880b-787f-440c-b077-5e72244ec788"
//            }),
//            Lot.with({
//                $0.title = "dsfdfsfdfs"
//                $0.price = "10000"
//                $0.status = .canceled
//                $0.imageURL = "https://storage.yandexcloud.net/zveron-profile/229d880b-787f-440c-b077-5e72244ec788"
//            }),
//            Lot.with({
//                $0.title = "dsfdfsfdfs"
//                $0.price = "10000"
//                $0.imageURL = "https://storage.yandexcloud.net/zveron-profile/229d880b-787f-440c-b077-5e72244ec788"
//            })
//
//        ]
//        LotManager.shared.setLots(lots)
//        collectionView.reloadData()
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Созданные объявления"
        definesPresentationContext = true
        collectionView.refreshControl = self.refreshControl
        
        
        layout()
        bindViews()
        
        self.viewModel.isLoadedOwnLots.onNext(false)
        viewModel.getOwnLots()
    }
    
    
    func layout() {
        view.addSubview(addLotBtn)
        addLotBtn.heightAnchor.constraint(equalToConstant: 52).isActive = true
        addLotBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16).isActive = true
        addLotBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        addLotBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        addLotBtn.layer.cornerRadius = Corner.mainButton.rawValue
        addLotBtn.setTitle("Добавить объявление", for: .normal)
        addLotBtn.contentHorizontalAlignment = .center
        addLotBtn.setTitleColor(.white, for: .normal)
        
        // Set the constraints for the collection view , constant: 16
        view.addSubview(collectionView)
        
        // Set the constraints for the collection view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: addLotBtn.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func bindViews() {
        
        viewModel.ownLots
            .subscribe(onNext: {
                print("ЛОТЫ ЗАГРУЖЕНЫ")
                LotManager.shared.setLots($0)
                self.collectionView.reloadData()
                self.viewModel.isLoadedOwnLots.onNext(true)
                self.viewModel.isLoadedOwnLotsRefresh.onNext(true)
            }).disposed(by: disposeBag)
        
        
        viewModel.isLoadedOwnLots
            .subscribe(onNext: { isLoadedInfo in
            if !isLoadedInfo {
                self.collectionView.isHidden = true
                self.activityIndicator.show()
                self.activityIndicator.startAnimating()
            } else {
                self.collectionView.isHidden = false
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hide()
            }
        }).disposed(by: disposeBag)
        
        viewModel.isLoadedOwnLotsRefresh
            .subscribe(onNext: { isLoadedOwnLotsRefresh in
            if isLoadedOwnLotsRefresh {
                self.refreshControl.endRefreshing()
            }
        }).disposed(by: disposeBag)
        
        // разобраться с тем как закрывать
        
        refreshControl.rx.controlEvent(.valueChanged)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                self.viewModel.isLoadedOwnLotsRefresh.onNext(false)
                self.viewModel.getOwnLots()
            })
        
        addLotBtn.rx.tap.subscribe { _ in
            let addingLotVC = ControllerFactory.get(AddingLotViewController.self)
            let navAddingLotVC = UINavigationController(rootViewController: addingLotVC)
            navAddingLotVC.modalPresentationStyle = .fullScreen
            self.present(navAddingLotVC, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
    }
    
    func setUp() {
        addLotBtn.layer.cornerRadius = Corner.mainButton.rawValue
        addLotBtn.setTitle("Добавить объявление", for: .normal)
        addLotBtn.contentHorizontalAlignment = .center
        addLotBtn.setTitleColor(.white, for: .normal)
        // self.view.backgroundColor = Color.backgroundScreen.color
        view.addSubview(addLotBtn)
        
        addLotBtn.heightAnchor.constraint(equalToConstant: 52).isActive = true
        addLotBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16).isActive = true
        addLotBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        addLotBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        addLotBtn.layoutIfNeeded()
        addLotBtn.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
    }
}


extension AdsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // вернуть количество ячеек
        return LotManager.shared.lots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // вернуть ячейку
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lotCell", for: indexPath) as! AdsViewCell
        
        // Set up the cell with chat data
        let lot: Lot = LotManager.shared.lots[indexPath.row]
        cell.titleLotLabel.text = lot.title
        cell.priceLotLabel.text = lot.price
        cell.imageLot.kf.setImage(with: URL(string: lot.imageURL))
        var strStatus: String
        switch lot.status {
        case .active:
            strStatus = "В продаже"
            cell.statusView.backgroundColor = .systemGreen
        case .canceled:
            strStatus = "Истек срок публикации"
            cell.statusView.backgroundColor = .systemOrange
        case .closed:
            strStatus = "Продано"
            cell.statusView.backgroundColor = .systemRed
        case .UNRECOGNIZED(_):
            strStatus = "Истек срок публикации"
            cell.statusView.backgroundColor = .systemOrange
        }
        
        
        cell.statusLotLabel.text = strStatus
        
        
//        cell.labelCountLikes.text = "10"
//        cell.labelCountWatches.text = "100"
        
        cell.labelLotDate.text = lot.publicationDate
        
        
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.backgroundColor = Color1.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 105)
    }
}
