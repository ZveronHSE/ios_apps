//
//  CreateOrderLastViewController.swift
//  ConsumerApp
//
//  Created by alexander on 23.05.2023.
//

import Foundation
import UIKit
import RxSwift
import ConsumerDomain

class CreateOrderLastViewController: UIViewController {
    private let disposeBag = DisposeBag()
    let navBtn = NavigationButton.back.button

    private let submittedAnimalTrigger = BehaviorSubject<[Animal]>(value: [])
    private var idxSelectedAnimal: IndexPath?
    private let viewModel = ViewModelFactory.get(OrderViewModel.self)

    private let continueButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitleColor(.white, for: .normal)
        v.titleLabel?.font = Font.robotoRegular14
        v.backgroundColor = Color1.orange3
        v.layer.cornerRadius = 10
        v.setTitle("Создать заказ", for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let animalLabel: UILabel = {
        let v = UILabel()
        v.font = Font.robotoSemiBold20
        v.textColor = Color1.gray5
        v.text = "Питомец"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(AnimalCell.self, forCellWithReuseIdentifier: AnimalCell.reusableIdentifier)
        collectionView.delegate = self
        collectionView.backgroundColor = Color1.background
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    let descriptionLabel: UILabel = {
        let v = UILabel()
        v.font = Font.robotoSemiBold20
        v.textColor = Color1.gray5
        v.text = "Описание"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var textField: UITextView = {
        let v = UITextView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 10
        v.textColor = .lightGray
        v.text = "Опишите ваш запрос подробнее..."
        v.textAlignment = .left
        v.keyboardType = .default
        v.delegate = self
        v.font = Font.robotoRegular16
        v.layer.borderColor = Color1.orange3.cgColor
        v.tintColor = Color1.black
        v.autocapitalizationType = .sentences
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    var textCount: UILabel = {
        let v = UILabel()
        v.font = Font.robotoLight14
        v.textColor = .lightGray
        v.text = "Осталось символов: 200"
        v.textAlignment = .left
        v.hide(animated: false)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Color1.background
        navigationItem.title = "Новый заказ"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)

        layout()
        bind()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    private func layout() {
        let paddings = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)

        view.addSubview(animalLabel)
        view.addSubview(collectionView)
        view.addSubview(descriptionLabel)
        view.addSubview(textField)
        view.addSubview(textCount)
        view.addSubview(continueButton)


        animalLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 32).isActive = true
        animalLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: paddings.left).isActive = true

        collectionView.topAnchor.constraint(equalTo: animalLabel.bottomAnchor, constant: 16).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: AnimalCell.height + 8).isActive = true

        descriptionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 32).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: paddings.left).isActive = true

        textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16).isActive = true
        textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: paddings.left).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: paddings.right).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 105).isActive = true

        textCount.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 12).isActive = true
        textCount.leftAnchor.constraint(equalTo: view.leftAnchor, constant: paddings.left + 8).isActive = true

        continueButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        continueButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }

    private func bind() {
        navBtn.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)

        textField.rx.text.changed.asDriver().throttle(.milliseconds(500), latest: true).drive(onNext: { text in

            if text == "Опишите ваш запрос подробнее..." {
                self.textCount.text = "Осталось символов: 200"
            } else {
                self.textCount.text = "Осталось символов: \((200 - (text?.count ?? 0)))"
            }
        }).disposed(by: disposeBag)



        submittedAnimalTrigger.bind(to: collectionView.rx.items) { cv, index, animalModel in
            let indexPath = IndexPath(item: index, section: 0)

            guard let cell = cv.dequeueReusableCell(withReuseIdentifier: AnimalCell.reusableIdentifier, for: indexPath) as? AnimalCell else {
                fatalError("Невозможно создать ячейку")
            }
            cell.setup(animalModel)
            return cell
        }.disposed(by: disposeBag)

        collectionView.rx.itemSelected.bind(onNext: { index in
            if self.idxSelectedAnimal == index {
                self.idxSelectedAnimal = nil
                let cell = (self.collectionView.cellForItem(at: index) as? AnimalCell)
                cell?.unselect()
            } else {
                let cell = (self.collectionView.cellForItem(at: index) as? AnimalCell)
                cell?.select()

                guard let idxPrevious = self.idxSelectedAnimal else {
                    self.idxSelectedAnimal = index
                    return
                }

                let cell2 = (self.collectionView.cellForItem(at: idxPrevious) as? AnimalCell)

                cell2?.unselect()
                self.idxSelectedAnimal = index
            }
        }).disposed(by: disposeBag)

        continueButton.rx.tap.flatMap { _ in

            return Observable<Order>.create { sub in

                guard let idxSelectedAnimal = self.idxSelectedAnimal else {
                    self.presentAlert(title: "", message: "Питомец не выбран")
                    return Disposables.create()
                }

                guard let desc = self.textField.text else {
                    self.presentAlert(title: "", message: "Описание не заполнено")
                    return Disposables.create()
                }

                if desc == "Опишите ваш запрос подробнее..." || desc == "" {
                    self.presentAlert(title: "", message: "Описание не заполнено")
                    return Disposables.create()
                }

                if desc.count < 40 {
                    self.presentAlert(title: "", message: "Описание слишком короткое. Минимум 40 символов")
                    return Disposables.create()
                }

                let selectedAnimal = (try? self.submittedAnimalTrigger.value())![idxSelectedAnimal.item]

                let order = Order(
                    animalId: selectedAnimal.id,
                    title: self.titles!,
                    price: self.price!,
                    priceType: self.priceType!,
                    dateFrom: self.startDate!,
                    dateTo: self.endDate!,
                    timeFrom: Date().onlyTime(hour: 9, minute: 0),
                    timeTo: Date().onlyTime(hour: 18, minute: 0),
                    deliveryMethod: self.deliveryType!,
                    serviceType: self.serviceType!,
                    desc: desc
                )

                sub.onNext(order)

                return Disposables.create()
            }
        }.flatMap {
            return self.viewModel.usecase.createOrder($0).mapToVoid()
        }.subscribe(
            onNext: { _ in
                self.dismiss(animated: true)
            },
            onError: {
                if $0 as? BasicError == nil {
                    self.presentAlert(title: "", message: $0.localizedDescription)
                }
            }

        ).disposed(by: disposeBag)
    }

    private var serviceType: ServiceType?
    private var startDate: Date?
    private var endDate: Date?
    private var priceType: PriceType?
    private var price: Int?
    private var deliveryType: DeliveryType?
    private var phoneEnabled: Bool?
    private var chatEnabled: Bool?
    private var titles: String?

    func setup(
        title: String,
        serviceType: ServiceType,
        startDate: Date,
        endDate: Date,
        priceType: PriceType,
        price: Int,
        deliveryType: DeliveryType,
        phoneEnabled: Bool,
        chatEnabled: Bool,
        animals: [Animal]
    ) {
        self.titles = title
        self.submittedAnimalTrigger.onNext(animals)
        self.serviceType = serviceType
        self.startDate = startDate
        self.endDate = endDate
        self.priceType = priceType
        self.price = price
        self.deliveryType = deliveryType
        self.phoneEnabled = phoneEnabled
        self.chatEnabled = chatEnabled
    }
}

extension CreateOrderLastViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        UIView.animate(withDuration: 0.2) {
            textView.layer.borderWidth = 1.0
        }

        textCount.show(animated: true)
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray && textView.isFirstResponder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        UIView.animate(withDuration: 0.2) {
            textView.layer.borderWidth = 0.0
        }

        textCount.hide(animated: true)
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            textView.text = "Опишите ваш запрос подробнее..."
            textView.textColor = .lightGray
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 200
    }
}

extension CreateOrderLastViewController: UICollectionViewDelegateFlowLayout {

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
        return CGSize(width: AnimalCell.width, height: AnimalCell.height)
    }
}
