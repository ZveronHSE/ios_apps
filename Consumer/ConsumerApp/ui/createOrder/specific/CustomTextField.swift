//
//  CustomTextField.swift
//  ConsumerApp
//
//  Created by alexander on 13.05.2023.
//

import Foundation
import RxSwift
import RxCocoa
import InputMask
import UIKit

class CustomTextField: UIView {
    private let disposeBag = DisposeBag()
    // MARK: число должно представлять из себя цифру на примере 1000 10000 и тд
    var upperPriceBound: String = "" {
        didSet {
            addMasks()
        }
    }

    private var textFieldTapGesture: UITapGestureRecognizer?

    var font: UIFont? {
        didSet {
            label.font = font
            textField.font = font
        }
    }

    private var label: UILabel = {
        let label = UILabel()
        label.text = " ₽"
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = priceMask
        textField.placeholder = "₽"
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var priceMask: NotifyingMaskedTextFieldDelegate = {
        let mask = NotifyingMaskedTextFieldDelegate()
        mask.affinityCalculationStrategy = .capacity
        mask.affineFormats = [
            "[0]",
            "[00]",
            "[000]",
            "[0] [000]",
            "[00] [000]",
            "[000] [000]",
            "[0] [000] [000]",
            "[00] [000] [000]",
        ]
        mask.editingListener = self
        return mask
    }()

    private func addMasks() {
        let countNumbers = upperPriceBound.replacingOccurrences(of: " ", with: "").count
        var masks: [String] = []
        for i in 1...countNumbers {
            var curMask = pow(10, i).formattedWithSeparator
            curMask = curMask.replacingOccurrences(of: "1", with: "").trimmingCharacters(in: CharacterSet.whitespaces).split(separator: " ").map { "[\($0)]" }.joined(separator: " ")

            masks.append(curMask)
        }
        priceMask.affineFormats = masks
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        textFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTap))
        addGestureRecognizer(textFieldTapGesture!)
        textField.tintColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func textFieldTap() {
        textField.becomeFirstResponder()
    }

    deinit {
        textFieldTapGesture = nil
    }

    private func configureView() {
        addSubview(textField)
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true

        self.addSubview(label)
        label.leftAnchor.constraint(equalTo: textField.rightAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: textField.heightAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true

        widthAnchor.constraint(equalToConstant: 222).isActive = true
        backgroundColor = .white
        layer.cornerRadius = 10
    }

    private var field: BehaviorRelay<Int?>?
    func bindView(field: BehaviorRelay<Int?>) {
        self.field = field
        field.map { $0?.formattedWithSeparator }.bind { value in
            guard let text = value else { return }
            self.textField.text = text
            self.label.alpha = 1
        }.disposed(by: disposeBag)
    }

    override func endEditing(_ force: Bool) -> Bool {
        self.layer.borderWidth = 0
        return super.endEditing(force)
    }
}

extension CustomTextField: NotifyingMaskedTextFieldDelegateListener {
    func onEditingChanged(inTextField: UITextField, range: NSRange?) {
        self.layer.borderColor = Color1.orange3.cgColor

        UIView.animate(withDuration: 0.2) {
            self.layer.borderWidth = 1.0
        }

        // означает что идет попытка ввода числа, которое превосходит максимально-допустимое число
        if inTextField.text?.count == 0, range?.length == 0 {
            textField.text = upperPriceBound
            endEditing(true)
        }

        label.alpha = inTextField.text?.count == 0 ? 0 : 1

        let text = textField.text!.replacingOccurrences(of: " ", with: "")
        field?.accept(text.count == 0 ? nil : Int(text))
    }
}
