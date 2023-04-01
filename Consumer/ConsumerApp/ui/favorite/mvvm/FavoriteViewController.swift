//
//  FavoriteViewController.swift
//  iosapp
//
//  Created by alexander on 30.04.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ConsumerDomain

public class FavoriteViewController: UIViewControllerWithAuth {
    public enum SettingMode {
        case deleteUnactive
        case deleteAll
    }

    private let viewModel = ViewModelFactory.get(FavoriteViewModel.self)

    // MARK: Reactive triggers
    private let cellWillRemove: PublishSubject<Int64> = PublishSubject()
    private let retryTrigger: PublishSubject<Void> = PublishSubject()

    lazy var header: FavoriteHeaderView = {
        let header = FavoriteHeaderView()
        // header.delegate = self
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private lazy var collectionView: FavoriteCollectionView = {
        let view = FavoriteCollectionView()
        view.hide()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backgroundView: UIBackgroundView = {
        let view = UIBackgroundView()
        view.hide()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var createRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление ...")
        refreshControl.tintColor = Color1.gray3
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        return refreshControl
    }()

    private var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureStatusBar()
        configureScreen()
        bind(to: viewModel)

        view.backgroundColor = Color1.background
        navigationController?.navigationBar.backgroundColor = Color1.background
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.header.rerenderCollectionViewItems()
    }

    private func configureStatusBar() {
        let statusBar = UIView()
        let height = UIApplication.shared.statusBarFrame.height
        statusBar.frame = CGRect(x: 0, y: -height, width: view.frame.width, height: height)
        statusBar.backgroundColor = Color1.background
        navigationController?.navigationBar.addSubview(statusBar)
    }

    private func configureScreen() {
        view.addSubview(header)
        view.addSubview(collectionView)
        view.addSubview(backgroundView)
        view.addSubview(spinner)

        header.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        collectionView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        backgroundView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 100).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalToConstant: 160).isActive = true

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: Binding view to viewModel
public extension FavoriteViewController {

    override func didCompleteAuth(isSuccessAuth: Bool) {
        if isSuccessAuth { retryTrigger.onNext(Void()) }
    }

    private func createInput() -> FavoriteViewModel.Input {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let dataWillRetry = retryTrigger.asDriverOnErrorJustComplete().do(onNext: { self.backgroundView.hide() })

        let loadDataTrigger = Driver.merge(viewWillAppear, dataWillRetry)

        let favoriteTypeTrigger = header.dataSourceWillSelect.startWith(.animal).asDriverOnErrorJustComplete()

        let removeItemTrigger = cellWillRemove
            .flatMap { itemId in
            return Observable<Int64>.create { observer in
                self.presentAlert(
                    message: "Вы точно хотите удалить выбранное объявление?\nОтменить данное действие будет невозможно.",
                    style: .actionSheet,
                    actions: [
                        AlertButton(
                            title: "Удалить объявление",
                            style: .destructive,
                            handler: { _ in observer.onNext(itemId) }
                        ),
                        AlertButton(
                            title: "Отмена",
                            style: .cancel,
                            handler: nil
                        )
                    ]
                )
                return Disposables.create()
            }
        }.asDriverOnErrorJustComplete()

        let settingsTrigger = header.settingButton.rx.tap
            .flatMap { _ in
            return Observable<SettingMode>.create { observer in

                self.presentAlert(
                    style: .actionSheet,
                    actions: [
                        AlertButton(
                            title: "Удалить неактивные",
                            style: .default,
                            handler: { _ in observer.onNext(.deleteUnactive) }
                        ),
                        AlertButton(
                            title: "Удалить все",
                            style: .destructive,
                            handler: { _ in observer.onNext(.deleteAll) }
                        ),
                        AlertButton(
                            title: "Отмена",
                            style: .cancel,
                            handler: nil
                        ),
                    ]
                )
                return Disposables.create()
            }
        }.asDriverOnErrorJustComplete()

        let itemSelectTrigger = self.collectionView.collectionView.rx.itemSelected.asDriver()

        return FavoriteViewModel.Input(
            dataWillRetry: dataWillRetry,
            favoriteTypeTrigger: favoriteTypeTrigger,
            loadDataTrigger: loadDataTrigger,
            removeItemTrigger: removeItemTrigger,
            settingsTrigger: settingsTrigger,
            itemSelectTrigger: itemSelectTrigger
        )
    }

    func bind(to vm: FavoriteViewModel) {
        let input = createInput()
        let output = vm.transform(input: input)

        let collectionViewDataSource1 = RxCollectionViewSectionedAnimatedDataSource<FavoriteSectionModel>(
            configureCell: { source, cv, indexPath, item in

                switch source[indexPath] {
                case .LotItem(let item):
                    guard let cell = cv.dequeueReusableCell(withReuseIdentifier: FavoriteLotCell.reusableIdentifier, for: indexPath) as? FavoriteLotCell else { fatalError("") }
                    cell.setUp(with: item)
                    cell.favoriteButton.rx.tap
                        .map { _ in Int64(item.id) }
                        .bind(to: self.cellWillRemove)
                        .disposed(by: cell.disposeBag)
                    return cell
                case .ProfileItem(let item):
                    guard let cell = cv.dequeueReusableCell(withReuseIdentifier: FavoriteProfileCell.reusableIdentifier, for: indexPath) as? FavoriteProfileCell else { fatalError("") }
                    cell.setUp(with: item)
                    cell.favoriteButton.rx.tap
                        .map { _ in Int64(item.id) }
                        .bind(to: self.cellWillRemove)
                        .disposed(by: cell.disposeBag)
                    return cell
                }
            }
        )

        output.items.do(onNext: {

            if $0.items.isEmpty {
                self.backgroundView.configure(
                    icon: Icon.favoriteUnselected,
                    mainText: "В избранном пока что пусто"
                )

                if self.collectionView.collectionView.numberOfSections != 0 && self.collectionView.collectionView.numberOfItems(inSection: 0) != 0 {
                    self.collectionView.hide(animated: true)
                    self.backgroundView.show(animated: true)
                } else {
                    self.collectionView.hide()
                    self.backgroundView.show()
                }

                self.header.settingButton.disable()
                return
            }

            if $0.type == .vendor {
                self.collectionView.setStyle(.profiles)
                self.header.settingButton.disable()
            } else {
                self.collectionView.setStyle(.lots)
                self.header.settingButton.enable()
            }

            self.collectionView.show(animated: true)
            self.backgroundView.hide(animated: true)
        }).map { [$0] }
            .drive(collectionView.collectionView.rx.items(dataSource: collectionViewDataSource1))
            .disposed(by: disposeBag)

        output.settings.drive().disposed(by: disposeBag)

        output.errors.drive(onNext: { error in
            guard let error = error as? FavoriteError else { fatalError("missmatch error in favorite block") }
            switch error {
            case .failedLoad:
                self.backgroundView.configure(
                    icon: Icon.error,
                    mainText: "Не удалось загрузить избранное",
                    buttonIsDisplayed: true,
                    buttonText: "Попробовать еще раз",
                    buttonClickTrigger: { self.retryTrigger.onNext(Void()) }
                )
                self.collectionView.hide()
                self.backgroundView.show()
                self.header.settingButton.disable()
            case .failedRemoveItem:
                self.presentAlert(
                    message: "При удалении объявления произошла ошибка",
                    style: .alert,
                    actions: [AlertButton(title: "Ок", style: .cancel, handler: nil)]
                )
            case .failedRemoveAllItems:
                self.presentAlert(
                    message: "При удалении объявлений произошла ошибка",
                    style: .alert,
                    actions: [AlertButton(title: "Ок", style: .cancel, handler: nil)]
                )
            case .failedRemoveClosedItems:
                self.presentAlert(
                    message: "При удалении неактивных объявлений произошла ошибка",
                    style: .alert,
                    actions: [AlertButton(title: "Ок", style: .cancel, handler: nil)]
                )
            case .failedLoadCurrentLot:
                self.presentAlert(
                    message: "Не удалось открыть объявление",
                    style: .alert,
                    actions: [AlertButton(title: "Ок", style: .cancel, handler: nil)]
                )
            }
        }).disposed(by: disposeBag)

        output.itemsLoaded.drive().disposed(by: disposeBag)

        output.sourceSelected.drive().disposed(by: disposeBag)
        output.itemRemoved.drive().disposed(by: disposeBag)

        output.lotSelected.drive(onNext: {
            let toVC = CardLotViewController()
            toVC.setup(with: $0)
            let navVC = UINavigationController(rootViewController: toVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }).disposed(by: disposeBag)

        output.profileSelected.drive(onNext: {
            fatalError("not implemented")
        }).disposed(by: disposeBag)

        output.isLoading.drive(onNext: {
            if $0 {
                self.spinner.show()
                self.spinner.startAnimating()
            } else {
                self.spinner.hide()
                self.spinner.stopAnimating()
            }
        }).disposed(by: disposeBag)
    }
}
