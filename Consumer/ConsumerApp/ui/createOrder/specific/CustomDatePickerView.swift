//
//  CustomDatePickerView.swift
//  ConsumerApp
//
//  Created by alexander on 22.05.2023.
//

import Foundation
import UIKit

class CustomDatePickerView: UIView {

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.textAlignment = .left
        textField.tintColor = .black
        
        textField.delegate = self
        return textField
    }()

    private lazy var datePicker: UIDatePicker = {
        let screenWidth = UIScreen.main.bounds.width - 32
        let datePicker = UIDatePicker()
        datePicker.tintColor = Color1.orange3
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.current
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        return datePicker
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = Color1.orange3.cgColor
        self.layer.borderWidth = 0.0
        layout()
        self.textField.setDatePicker(target: self, selector: #selector(donePressed), datePicker: datePicker)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupDates(startDate: Date, endDate: Date) {
        datePicker.minimumDate = startDate.onlyDate
        datePicker.maximumDate = endDate.onlyDate
    }

    private func layout() {

        backgroundColor = Color1.white
        layer.cornerRadius = 10
       addSubview(textField)

        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
    }

    var closure: ((Date?) -> ())?

    @objc func donePressed() {
        if let datePicker = self.textField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd/MM/yyyy"
            self.textField.text = dateformatter.string(from: datePicker.date)
            closure?(datePicker.date)
        }
        self.textField.resignFirstResponder()
    }
}

private extension UITextField {

    func setDatePicker(target: Any, selector: Selector, datePicker: UIDatePicker) {

        self.inputView = datePicker
        self.inputView?.backgroundColor = .white


        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        toolBar.tintColor = Color1.orange3
        toolBar.backgroundColor = .white
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // потом сделать не системные кнопки
        let cancel = UIBarButtonItem(title: "Отменить", style: .plain, target: nil, action: #selector(tapcancel))
        let barButton = UIBarButtonItem(title: "Выбрать", style: .done, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }

    @objc func tapcancel() {
        self.resignFirstResponder()
    }

}

extension CustomDatePickerView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        UIView.animate(withDuration: 0.2) {
            self.layer.borderWidth = 1.0
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.2) {
            self.layer.borderWidth = 0.0
        }
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.closure?(nil)
        return true
    }
}

extension Date {

    var onlyDate: Date? {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calender.date(from: dateComponents)
    }

    func onlyTime(hour: Int, minute: Int) -> Date {
        let calender = Calendar.current
        var dateComponents = calender.dateComponents([.hour, .minute], from: self)

        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.timeZone = NSTimeZone.system
        return calender.date(from: dateComponents)!
    }



}
