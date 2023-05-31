//
//  CreateOrderFirstViewController.swift
//  ConsumerApp
//
//  Created by alexander on 12.05.2023.
//

import Foundation
import UIKit
import RxSwift
import ConsumerDomain


class ConverterDel: Converter {
    func allValues() -> [String] {
        return DeliveryType.allCases.map { $0.rawValue }
    }

    func convertToResult(_ value: String) -> DeliveryType {
        return DeliveryType.init(rawValue: value)!
    }

    typealias Value = DeliveryType
}

class CreateOrderFirstViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var serviceTypePicked: ServiceType?
    private var startDate: Date?
    private var endDate: Date?
    let navBtn = NavigationButton.close.button
    private let viewModel = ViewModelFactory.get(OrderViewModel.self)


    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.alwaysBounceVertical = true
        v.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let continueButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitleColor(.white, for: .normal)
        v.titleLabel?.font = Font.robotoRegular14
        v.backgroundColor = Color1.orange3
        v.layer.cornerRadius = 10
        v.setTitle("Далее", for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let serviceLabel: UILabel = {
        let v = UILabel()
        v.font = Font.robotoSemiBold20
        v.textColor = Color1.gray5
        v.text = "Выберите услугу"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var serviceTypeButton: CustomButtonView = {
        let v = CustomButtonView()
        v.setup(text: "Не указано")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let periodLabel: UILabel = {
        let v = UILabel()
        v.font = Font.robotoSemiBold20
        v.textColor = Color1.gray5
        v.text = "Сроки"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private var startPeriodPicker: CustomDatePickerView = {
        let v = CustomDatePickerView()
        v.textField.placeholder = "Дата с"
        v.setupDates(startDate: Date(), endDate: Date().advanced(by: 365 * 24 * 60 * 60))
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private var endPeriodPicker: CustomDatePickerView = {
        let v = CustomDatePickerView()
        v.textField.placeholder = "Дата по"
        v.setupDates(startDate: Date(), endDate: Date().advanced(by: 365 * 24 * 60 * 60))
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let moneyLabel: UILabel = {
        let v = UILabel()
        v.font = Font.robotoSemiBold20
        v.textColor = Color1.gray5
        v.text = "Бюджет"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var priceTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.upperPriceBound = "99 999 999"
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let priceSelector: PriceDropDown = {
        let v = PriceDropDown()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let priceUnknown: CheckBoxView = {
        let v = CheckBoxView()
        v.isUserInteractionEnabled = true
        v.setup(text: "Договорная")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let typeDeliveryLabel: UILabel = {
        let v = UILabel()
        v.font = Font.robotoSemiBold20
        v.textColor = Color1.gray5
        v.text = "Выезд домой"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let deliveryButtons: RadioButtonGroup = {
        let v = RadioButtonGroup(converter: ConverterDel())
        v.isUserInteractionEnabled = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let typeConnectionLabel: UILabel = {
        let v = UILabel()
        v.font = Font.robotoSemiBold20
        v.textColor = Color1.gray5
        v.text = "Способ связи"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let phoneType: CheckBoxView = {
        let v = CheckBoxView()
        v.isUserInteractionEnabled = true
        v.setup(text: "По телефону")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let messageType: CheckBoxView = {
        let v = CheckBoxView()
        v.isUserInteractionEnabled = true
        v.setup(text: "В сообщениях")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let nameLabel: UILabel = {
        let v = UILabel()
        v.font = Font.robotoSemiBold20
        v.textColor = Color1.gray5
        v.text = "Название"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var textField: UITextView = {
        let v = UITextView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 10
        v.textColor = .lightGray
        v.text = "Опишите кратко заказ..."
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

   lazy var textCount: UILabel = {
        let v = UILabel()
        v.font = Font.robotoLight14
        v.textColor = .lightGray
        v.text = "Осталось символов: \(maxTextCount)"
        v.textAlignment = .left
        v.hide(animated: false)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    var maxTextCount = 40


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Новый заказ"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)

        let touch = UITapGestureRecognizer(target: self, action: #selector(singleTapGestureCaptured))
        scrollView.addGestureRecognizer(touch)

        layoutScrollView()
        layoutContentView()
        bind()
    }

    @objc func singleTapGestureCaptured(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.priceTextField.endEditing(true)
    }

    private func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(continueButton)

        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        continueButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        continueButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }

    private func layoutContentView() {
        let paddings = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)

        contentView.addSubview(nameLabel)
        contentView.addSubview(textField)
        contentView.addSubview(textCount)

        contentView.addSubview(serviceLabel)
        contentView.addSubview(serviceTypeButton)

        contentView.addSubview(periodLabel)
        contentView.addSubview(startPeriodPicker)
        contentView.addSubview(endPeriodPicker)

        contentView.addSubview(moneyLabel)
        contentView.addSubview(priceTextField)
        contentView.addSubview(priceSelector)
        contentView.addSubview(priceUnknown)

        contentView.addSubview(typeDeliveryLabel)
        contentView.addSubview(deliveryButtons)

        contentView.addSubview(typeConnectionLabel)
        contentView.addSubview(phoneType)
        contentView.addSubview(messageType)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),

            textField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            textField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),
            textField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right),
            textField.heightAnchor.constraint(equalToConstant: 50),

            textCount.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            textCount.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left + 8),

            serviceLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 32),
            serviceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),

            serviceTypeButton.topAnchor.constraint(equalTo: serviceLabel.bottomAnchor, constant: 16),
            serviceTypeButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),
            serviceTypeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right),

            periodLabel.topAnchor.constraint(equalTo: serviceTypeButton.bottomAnchor, constant: 32),
            periodLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),

            startPeriodPicker.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 16),
            startPeriodPicker.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),
            startPeriodPicker.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - (paddings.left + abs(paddings.right) + 4)) / 2),

            endPeriodPicker.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 16),
            endPeriodPicker.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: paddings.right),
            endPeriodPicker.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - (paddings.left + abs(paddings.right) + 4)) / 2),

            moneyLabel.topAnchor.constraint(equalTo: startPeriodPicker.bottomAnchor, constant: 32),
            moneyLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),

            priceTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),
            priceTextField.topAnchor.constraint(equalTo: moneyLabel.bottomAnchor, constant: 16),

            priceSelector.leftAnchor.constraint(equalTo: priceTextField.rightAnchor, constant: 8),
            priceSelector.centerYAnchor.constraint(equalTo: priceTextField.centerYAnchor),

            priceUnknown.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),
            priceUnknown.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 16),

            typeDeliveryLabel.topAnchor.constraint(equalTo: priceUnknown.bottomAnchor, constant: 32),
            typeDeliveryLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),

            deliveryButtons.topAnchor.constraint(equalTo: typeDeliveryLabel.bottomAnchor, constant: 16),
            deliveryButtons.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),

            typeConnectionLabel.topAnchor.constraint(equalTo: deliveryButtons.bottomAnchor, constant: 32),
            typeConnectionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),

            phoneType.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),
            phoneType.topAnchor.constraint(equalTo: typeConnectionLabel.bottomAnchor, constant: 24),

            messageType.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: paddings.left),
            messageType.topAnchor.constraint(equalTo: phoneType.bottomAnchor, constant: 24),

            messageType.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func bind() {

        startPeriodPicker.closure = { date in
            self.startDate = date
            let updatedDate = date ?? Date()
            self.endPeriodPicker.setupDates(startDate: updatedDate, endDate: Date().advanced(by: 365 * 24 * 60 * 60))
        }

        endPeriodPicker.closure = { date in
            self.endDate = date
            let updatedDate = date ?? Date().advanced(by: 365 * 24 * 60 * 60)
            self.startPeriodPicker.setupDates(startDate: Date(), endDate: updatedDate)
        }

        serviceTypeButton.closure = { [weak self] in
            let nextVC = ServiceTypePickerViewController()
            nextVC.delegate = self
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }

        navBtn.rx.tap.bind(onNext: {
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)

        priceUnknown.closure = { [weak self] isSelected in
            if isSelected {
                self?.priceTextField.endEditing(true)
                self?.priceTextField.isUserInteractionEnabled = false
                self?.priceSelector.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.2) {
                    self?.priceTextField.alpha = 0.5
                    self?.priceSelector.alpha = 0.5
                }
            } else {
                self?.priceTextField.isUserInteractionEnabled = true
                self?.priceSelector.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.2) {
                    self?.priceTextField.alpha = 1.0
                    self?.priceSelector.alpha = 1.0
                }
            }
        }



        continueButton.rx.tap.asObservable().flatMap {
            return self.viewModel.profileUseCase.getAnimalsByProfile()
        }.subscribe(
            onNext: {

                guard let desc = self.textField.text else {
                    self.presentAlert(title: "", message: "Название не заполнено")
                    return
                }

                if desc == "Опишите кратко заказ..." || desc == "" {
                    self.presentAlert(title: "", message: "Название не заполнено")
                    return
                }

                if desc.count < 10 {
                    self.presentAlert(title: "", message: "Название слишком короткое. Минимум 10 символов")
                    return
                }

                guard let serviceType = self.serviceTypePicked else {
                    self.presentAlert(title: "", message: "Тип услуги не указан")
                    return
                }
                guard let startDate = self.startDate else {
                    self.presentAlert(title: "", message: "Дата оказания услуги не заполнена")
                    return
                }

                guard let endDate = self.endDate else {
                    self.presentAlert(title: "", message: "Дата оказания услуги не заполнена")
                    return
                }

                let priceType = self.priceSelector.selectedType!
                var price: Int = 0
                if !self.priceUnknown.isSelected {
                    let textPrice = self.priceTextField.textField.text!.replacingOccurrences(of: " ", with: "")
                    if textPrice.count == 0 {
                        self.presentAlert(title: "", message: "Цена услуги не указана")
                        return
                    }

                    price = Int(textPrice)!
                }

                let deliveryType = (self.deliveryButtons.getSelectedValue() as? DeliveryType)!

                let phoneCommunication = self.phoneType.isSelected
                let chatCommunication = self.messageType.isSelected

                let vc = CreateOrderLastViewController()

                vc.setup(
                    title: desc,
                    serviceType: serviceType,
                    startDate: startDate.onlyDate!,
                    endDate: endDate.onlyDate!,
                    priceType: priceType,
                    price: price,
                    deliveryType: deliveryType,
                    phoneEnabled: phoneCommunication,
                    chatEnabled: chatCommunication,
                    animals: $0
                )
                self.navigationController?.pushViewController(vc, animated: true)
            },
            onError: {
                self.presentAlert(title: "", message: $0.localizedDescription)
            }
        ).disposed(by: disposeBag)

        textField.rx.text.changed.asDriver().throttle(.milliseconds(500), latest: true).drive(onNext: { text in

            if text == "Опишите кратко заказ..." {
                self.textCount.text = "Осталось символов: \(self.maxTextCount)"
            } else {
                self.textCount.text = "Осталось символов: \((self.maxTextCount - (text?.count ?? 0)))"
            }
        }).disposed(by: disposeBag)
    }
}

extension CreateOrderFirstViewController: ServiceTypePickerDelegate {
    func picked(value: ServiceType) {
        self.serviceTypeButton.setup(text: value.rawValue)
        self.serviceTypePicked = value
    }
}

extension CreateOrderFirstViewController: UITextViewDelegate {
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
            textView.text = "Опишите кратко заказ..."
            textView.textColor = .lightGray
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= maxTextCount
    }
}
