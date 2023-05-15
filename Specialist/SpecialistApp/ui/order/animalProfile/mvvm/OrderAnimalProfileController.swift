//
//  OrderAnimalProfileController.swift
//  SpecialistApp
//
//  Created by alexander on 12.04.2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SpecialistDomain

final class OrderAnimalProfileController: UIViewController {
    let disposeBag = DisposeBag()
    private let pdfLoadedTirgger = PublishSubject<URL>()
    private let backClickTrigger = PublishSubject<Void>()

    private let scrollView: UIScrollView = createView()

    private let contentView: UIView = createView()

    private let headerLabel: UILabel = createLabel(with: .zvBlack, and: .zvMediumTitle2)
    private let kindView: HeaderAndTitleView = createView()
    private let porodaView: HeaderAndTitleView = createView()
    private let nameView: HeaderAndTitleView = createView()
    private let ageView: HeaderAndTitleView = createView()
    private let photosView: PhotosView = createView()
    private let documetsView: DocumentsView = createView()
    private let activityIndicator: UIActivityIndicatorView = createActivityIndicator()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .zvBackground
        navigationItem.leftBarButtonItem = createNavigationButton(type: .back) { [weak self] in
            self?.backClickTrigger.onNext(Void())
        }

        layoutScrollView()
        layoutContentView()
    }

    private func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(activityIndicator)

        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func layoutContentView() {
        let paddings = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: -16)

        contentView.addSubview(headerLabel)
        contentView.addSubview(kindView)
        contentView.addSubview(porodaView)
        contentView.addSubview(nameView)
        contentView.addSubview(ageView)
        contentView.addSubview(photosView)
        contentView.addSubview(documetsView)

        headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddings.top).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left).isActive = true

        kindView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16).isActive = true
        kindView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left).isActive = true
        kindView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right).isActive = true

        porodaView.topAnchor.constraint(equalTo: kindView.bottomAnchor, constant: 16).isActive = true
        porodaView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left).isActive = true
        porodaView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right).isActive = true

        nameView.topAnchor.constraint(equalTo: porodaView.bottomAnchor, constant: 16).isActive = true
        nameView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left).isActive = true
        nameView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right).isActive = true

        ageView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 16).isActive = true
        ageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left).isActive = true
        ageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right).isActive = true

        photosView.topAnchor.constraint(equalTo: ageView.bottomAnchor, constant: 28).isActive = true
        photosView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        photosView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        documetsView.topAnchor.constraint(equalTo: photosView.bottomAnchor, constant: 28).isActive = true
        documetsView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        documetsView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        documetsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    public func setup(with model: AnimalProfile) {
        navigationItem.title = "Профиль питомца"
        headerLabel.text = "Данные о животном"

        kindView.setup(with: "Вид животного", and: model.breed)
        porodaView.setup(with: "Порода", and: model.species)
        nameView.setup(with: "Имя", and: model.name)
        ageView.setup(with: "Возраст", and: model.age)
        photosView.setup(with: model.imageUrls)
        documetsView.setup(with: model.documents.map { $0.name })
    }
}

fileprivate final class PhotosView: UIView {
    private let disposeBag = DisposeBag()
    private let submittedPhotos = PublishRelay<[URL]>()

    private lazy var titleLabel: UILabel = createLabel(with: .zvBlack, and: .zvMediumTitle2)

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(AnimalPhotoCell.self)
        collectionView.delegate = self
        collectionView.backgroundColor = .zvBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override init(frame: CGRect) { super.init(frame: frame); layout(); bindView() }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public func layout() {
        addSubview(titleLabel)
        addSubview(collectionView)

        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true

        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: AnimalPhotoCell.cellSize.height).isActive = true
    }

    private func bindView() {
        submittedPhotos.bind(to: collectionView.rx.items) { cv, index, photoUrl in
            let cell: AnimalPhotoCell = cv.createCell(by: index)
            cell.setup(with: photoUrl)
            return cell
        }.disposed(by: disposeBag)
    }

    public func setup(with photos: [URL]) {
        self.titleLabel.text = "Фотографии"
        self.submittedPhotos.accept(photos)
    }
}

extension PhotosView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return AnimalPhotoCell.cellSize
    }
}

fileprivate final class DocumentsView: UIView {
    private let disposeBag = DisposeBag()
    private let submittedPhotos = PublishRelay<[String]>()
    let documentClickedTrigger = PublishRelay<IndexPath>()

    private lazy var titleLabel: UILabel = createLabel(with: .zvBlack, and: .zvMediumTitle2)

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(AnimalDocumentCell.self)
        collectionView.delegate = self
        collectionView.backgroundColor = .zvBackground
        collectionView.isUserInteractionEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override init(frame: CGRect) { super.init(frame: frame); layout(); bindView() }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public func layout() {
        addSubview(titleLabel)
        addSubview(collectionView)

        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true

        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: AnimalDocumentCell.cellSize.height).isActive = true
    }

    private func bindView() {
        submittedPhotos.bind(to: collectionView.rx.items) { cv, index, documentName in
            let cell: AnimalDocumentCell = cv.createCell(by: index)
            cell.setup(with: documentName)
            return cell
        }.disposed(by: disposeBag)

        collectionView.rx.itemSelected.bind(to: documentClickedTrigger).disposed(by: disposeBag)
    }

    public func setup(with documents: [String]) {
        self.titleLabel.text = "Документы"
        self.submittedPhotos.accept(documents)
    }
}

extension DocumentsView: UICollectionViewDelegateFlowLayout {
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
        return AnimalDocumentCell.cellSize
    }
}

extension OrderAnimalProfileController: BindableView {

    private func createInput() -> OrderAnimalProfileViewModel.Input {

        let documentClickTrigger = documetsView.documentClickedTrigger.asDriverOnErrorJustComplete()

        return .init(
            backClickTrigger: backClickTrigger.asDriverOnErrorJustComplete()
                .debug("back click trigger", trimOutput: true),
            documentClickTrigger: documentClickTrigger.debug("document click trigger", trimOutput: true)
        )
    }

    func bind(to viewModel: OrderAnimalProfileViewModel) {
        self.setup(with: viewModel.model)
        let input = createInput()
        let output = viewModel.transform(input: input)

        output.backClicked.drive().disposed(by: disposeBag)
        output.documentClicked.drive().disposed(by: disposeBag)

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
            print("Ошибка при загрузке документа")
        }).disposed(by: disposeBag)
    }
}
