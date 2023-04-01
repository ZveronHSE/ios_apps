//
//  NotifyingMaskedTextFieldDelegate.swift
//  iosapp
//
//  Created by alexander on 11.03.2022.
//

import Foundation
import UIKit
import InputMask

class NotifyingMaskedTextFieldDelegate: MaskedTextFieldDelegate {
    weak var editingListener: NotifyingMaskedTextFieldDelegateListener?
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        self.editingListener?.onEditingChanged(inTextField: textField, range: nil)
    }

    override func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        defer {
            self.editingListener?.onEditingChanged(inTextField: textField, range: range)
        }
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}

protocol NotifyingMaskedTextFieldDelegateListener: AnyObject {
    func onEditingChanged(inTextField: UITextField, range: NSRange?)
}
