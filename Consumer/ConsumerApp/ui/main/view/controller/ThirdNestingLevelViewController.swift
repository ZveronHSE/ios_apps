//
//  ThirdNestingLevelViewController.swift
//  iosapp
//
//  Created by alexander on 03.05.2022.
//

import Foundation
import BottomSheet
import RxSwift
import RxCocoa
import Kingfisher
import RxDataSources
import ZveronRemoteDataService
import UIKit

class ThirdNestingLevelViewController: UIViewControllerWithAuth {

    private let viewModel = ViewModelFactory.get(ThirdNestingViewModel.self)
   

    private lazy var collectionView: LotCollectionView = {
        let collectionView = LotCollectionView(frame: view.frame)
        collectionView.backgroundColor = Color.backgroundScreen.color
        collectionView.setHeaderSize(size: CGSize(width: view.frame.width, height: 180))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var header: ThirdNestingHeader = {
        let view = ThirdNestingHeader(frame: view.frame)
        view.backgroundColor = Color.backgroundScreen.color
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

    private lazy var backButton: UIBarButtonItem = {
        let backButton = UIButton(type: .system)
        backButton.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        let backIcon = #imageLiteral(resourceName: "back_icon")
        backButton.setImage(backIcon, for: .normal)
        backButton.tintColor = .black
        return UIBarButtonItem(customView: backButton)
    }()

    override func viewDidLayoutSubviews() {
        header.setupAnchorView(navigationController?.navigationBar)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStatusBar()
        configureScreen()
        bindViews()
        view.backgroundColor = Color.backgroundScreen.color
        navigationController?.navigationBar.backgroundColor = Color.backgroundScreen.color
    }

    private func configureStatusBar() {
        let statusBar = UIView()
        let height =  UIApplication.shared.statusBarFrame.height
        statusBar.frame = CGRect(x: 0, y: -height, width: view.frame.width, height: height)
        statusBar.backgroundColor = Color.backgroundScreen.color
        navigationController?.navigationBar.addSubview(statusBar)
    }

    private func configureScreen() {
        navigationItem.leftBarButtonItem = backButton
        view.addSubview(collectionView)
        view.addSubview(header)

        header.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 180).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.titleView = searchBar
    }

    private func bindViews() {
        collectionView.bindViews(viewModel)
        header.bindViews(viewModel)

        viewModel.selectedParameter.bind(onNext: { parameter in
            let toVC = MultiPickerViewController(isBackButton: false)
            toVC.setup(parameter: parameter)
            toVC.delegate = self
            let navVC = UINavigationController(rootViewController: toVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
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


    func setupData(presentationMode: PresentModeType, filter: FilterModel) {
        viewModel.filter.accept(filter)
        viewModel.sortingType.accept(filter.sortingType)
        viewModel.presentationModeType.accept(presentationMode)
        if filter.parameters.isEmpty {
        viewModel.getParameters(subCategory: filter.subCategory!)
        }
    }
}

extension ThirdNestingLevelViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let vc =  FilterViewController()
        vc.setup(presentMode: viewModel.presentationModeType.value, filter: viewModel.filter.value!)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}

extension ThirdNestingLevelViewController: FilterViewDelegate {
    func willFinish(presentMode: PresentModeType, filter: FilterModel) {
        // go to previousScreen
        if filter.subCategory == nil {
            guard   let viewControllers: [UIViewController] = navigationController?.viewControllers else { return }
          guard  let secondNestingController = viewControllers[1] as?  SecondNestingLevelViewController else {
              let toVC = SecondNestingLevelViewController()
              toVC.setupData(presentationMode: presentMode, filter: filter)
              var viewControllersUpdate = viewControllers
              viewControllersUpdate.removeLast()
              viewControllersUpdate.append(toVC)
              navigationController?.setViewControllers(viewControllersUpdate, animated: false)
              return
          }
            secondNestingController.setupData(presentationMode: presentMode, filter: filter)
            navigationController?.popToViewController(secondNestingController, animated: false)
        } else {
            viewModel.presentationModeType.accept(presentMode)
            viewModel.sortingType.accept(filter.sortingType)
            viewModel.filter.accept(filter)
        }
    }
}

extension ThirdNestingLevelViewController: MultiPickerDelegate {
    func willFinish(parameter: LotParameter) {
        let oldFilter = viewModel.filter.value!
        var updateParameters = oldFilter.parameters
        let index = updateParameters.firstIndex(where: { $0.name == parameter.name })!
        updateParameters.remove(at: index)
        updateParameters.insert(parameter, at: index)
        let newFilter = oldFilter.updateFields(parameters: updateParameters)
        viewModel.filter.accept(newFilter)
    }
}
