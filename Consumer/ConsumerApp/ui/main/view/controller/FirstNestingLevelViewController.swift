//
//  MainViewController.swift
//  iosapp
//
//  Created by alexander on 30.04.2022.
//

import UIKit
import BottomSheet
import RxSwift
import RxCocoa
import Kingfisher
import RxDataSources
import ZveronRemoteDataService

class FirstNestingLevelViewController: UIViewControllerWithAuth {

    private let viewModel = ViewModelFactory.get(FirstNestingViewModel.self)

    private lazy var collectionView: LotCollectionView = {
        let collectionView = LotCollectionView(frame: view.frame)
        collectionView.backgroundColor = Color.backgroundScreen.color
        collectionView.setHeaderSize(size: CGSize(width: view.frame.width, height: 300))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var header: FirstNestingHeader = {
        let view = FirstNestingHeader(frame: view.frame)
        view.backgroundColor = Color.backgroundScreen.color
        view.setupAnchorView(navigationController?.navigationBar)
        view.safeArea = 60
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = "Поиск"
        searchBar.showsBookmarkButton = true
        let icon = #imageLiteral(resourceName: "settings_icon")
        searchBar.setImage(icon, for: .bookmark, state: .normal)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -10, vertical: 0), for: .clear)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .search)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -10, vertical: 0), for: .bookmark)
        searchBar.delegate = self
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStatusBar()
        configureScreen()
        bindViews()
        view.backgroundColor = Color.backgroundScreen.color
        navigationController?.navigationBar.backgroundColor = Color.backgroundScreen.color
        viewModel.filter.accept(FilterModel(sortingType: .popularity))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // viewModel.filter.accept(viewModel.filter.value)
    }

    private func configureStatusBar() {
        let statusBar = UIView()
        let height =  UIApplication.shared.statusBarFrame.height
        statusBar.frame = CGRect(x: 0, y: -height, width: view.frame.width, height: height)
        statusBar.backgroundColor = Color.backgroundScreen.color
        navigationController?.navigationBar.addSubview(statusBar)
    }

    private func configureScreen() {
        view.addSubview(collectionView)
        view.addSubview(header)
       // let height = view.frame.height - navigationController!.navigationBar.frame.height
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        header.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 300).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.titleView = searchBar
    }

    private func bindViews() {
        header.bindViews(viewModel)
        collectionView.bindViews(viewModel)

        viewModel.selectedCategory.bind(onNext: { category in
            let oldFilter = self.viewModel.filter.value!
            let newFilter = FilterModel(
                sortingType: oldFilter.sortingType,
                category: category
            )
            let toVC = SecondNestingLevelViewController()
            toVC.setupData(presentationMode: self.viewModel.presentationModeType.value, filter: newFilter)
            self.navigationController?.pushViewController(toVC, animated: true)
        }).disposed(by: disposeBag)

        viewModel.nonAutharizated.bind {_ in
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Вы неавторизованы",
                    message: "Для добавления объявления в избранное пройдите авторизацию",
                    preferredStyle: .alert
                )
                let okAlertAction = UIAlertAction(title: "ОК", style: .default, handler: {_ in
                    self.presentAutharization()
                })
                alert.addAction(okAlertAction)
                self.present(alert, animated: true)
            }
        }.disposed(by: disposeBag)

        viewModel.needShowMessage.bind { message in
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Произошла ошибка",
                    message: message,
                    preferredStyle: .alert
                )
                let okAlertAction = UIAlertAction(title: "ОК", style: .default)
                alert.addAction(okAlertAction)
                self.present(alert, animated: true)
            }
        }.disposed(by: disposeBag)

        viewModel.currentLot.bind {
            let toVC = CardLotViewController()
            toVC.setup(with: $0)
            let navVC = UINavigationController(rootViewController: toVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }.disposed(by: disposeBag)
    }

   override func didCompleteAuth(isSuccessAuth: Bool) {
       if isSuccessAuth {
           viewModel.filter.accept(viewModel.filter.value)
       }
    }

}

extension FirstNestingLevelViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let vc =  FilterViewController()
        vc.setup(presentMode: viewModel.presentationModeType.value, filter: viewModel.filter.value!)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}

extension FirstNestingLevelViewController: FilterViewDelegate {
    func willFinish(presentMode: PresentModeType, filter: FilterModel) {
        if filter.category == nil {
            viewModel.presentationModeType.accept(presentMode)
            viewModel.filter.accept(filter)
            viewModel.sortingType.accept(filter.sortingType)
        } else if filter.subCategory == nil {
            let toVC = SecondNestingLevelViewController()
            toVC.setupData(presentationMode: presentMode, filter: filter)
            navigationController?.pushViewController(toVC, animated: false)
        } else {
            let toVC = ThirdNestingLevelViewController()
            toVC.setupData(presentationMode: presentMode, filter: filter)
            navigationController?.pushViewController(toVC, animated: false)
        }
    }
}
