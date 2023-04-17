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
    private let disposeBag = DisposeBag()
    private let pdfLoadedTirgger = PublishSubject<URL>()

    private lazy var headerLabel: UILabel = createLabel(with: .zvBlack, and: .zvMediumTitle2)
    private lazy var kindView: HeaderAndTitleView = createView()
    private lazy var porodaView: HeaderAndTitleView = createView()
    private lazy var nameView: HeaderAndTitleView = createView()
    private lazy var ageView: HeaderAndTitleView = createView()
    private let photosView: PhotosView = createView()
    private let documetsView: DocumentsView = createView()

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
        let paddings = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: -16)

        view.addSubview(headerLabel)
        view.addSubview(kindView)
        view.addSubview(porodaView)
        view.addSubview(nameView)
        view.addSubview(ageView)
        view.addSubview(photosView)
        view.addSubview(documetsView)

        headerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: paddings.top).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: paddings.left).isActive = true

        kindView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16).isActive = true
        kindView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: paddings.left).isActive = true
        kindView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: paddings.right).isActive = true

        porodaView.topAnchor.constraint(equalTo: kindView.bottomAnchor, constant: 16).isActive = true
        porodaView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: paddings.left).isActive = true
        porodaView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: paddings.right).isActive = true

        nameView.topAnchor.constraint(equalTo: porodaView.bottomAnchor, constant: 16).isActive = true
        nameView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: paddings.left).isActive = true
        nameView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: paddings.right).isActive = true

        ageView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 16).isActive = true
        ageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: paddings.left).isActive = true
        ageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: paddings.right).isActive = true

        photosView.topAnchor.constraint(equalTo: ageView.bottomAnchor, constant: 28).isActive = true
        photosView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        photosView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        documetsView.topAnchor.constraint(equalTo: photosView.bottomAnchor, constant: 28).isActive = true
        documetsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        documetsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    public func setup() {
        navigationItem.title = "Профиль питомца"
        headerLabel.text = "Данные о животном"
        kindView.setup(with: "Вид животного", and: "Кот")
        porodaView.setup(with: "Порода", and: "Британец")
        nameView.setup(with: "Имя", and: "Томас")
        ageView.setup(with: "Возраст", and: "2 года")
        photosView.setup(with: [
            URL(string: "https://oir.mobi/uploads/posts/2022-09/1662230018_1-oir-mobi-p-zhirnii-britanskii-kot-instagram-4.jpg")!,
            URL(string: "https://phonoteka.org/uploads/posts/2021-07/1625230752_10-phonoteka-org-p-britanskie-oboi-oboi-krasivo-10.jpg")!
        ])
        documetsView.setup(with: [
            "privivka.PDF",
            "privivka2.PDF",
            "privivka3.PDF",
            "privivka4.PDF"
        ])
    }

    public func bindViews() {

        self.documetsView.documentClickedTrigger.flatMap { index in
            return PDFLoadService.shared.loadPdf(from: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf")
        }.bind(onNext: { documentUrl in
            let nextVC = PDFViewController(pdfUrl: documentUrl)
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
        }).disposed(by: disposeBag)
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
