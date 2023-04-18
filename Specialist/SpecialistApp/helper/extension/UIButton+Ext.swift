//
//  UIButton+Ext.swift
//  SpecialistApp
//
//  Created by alexander on 19.04.2023.
//

import Foundation
import UIKit
extension UIButton {
    func enable(animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = .zvRedMain
                self.setTitleColor(.zvWhite, for: .normal)
                self.isEnabled = true
            }
        } else {
            self.backgroundColor = .zvRedMain
            self.setTitleColor(.zvWhite, for: .normal)
            self.isEnabled = true
        }
    }

    func disable(animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = .zvRedDisabled
                self.setTitleColor(.zvWhite50, for: .normal)
                self.isEnabled = false
            }
        } else {
            self.backgroundColor = .zvRedDisabled
            self.setTitleColor(.zvWhite50, for: .normal)
            self.isEnabled = false
        }
    }
}
