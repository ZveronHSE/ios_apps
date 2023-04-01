//
//  UIViewController+Alert.swift
//  iosapp
//
//  Created by alexander on 06.03.2023.
//

import Foundation
import UIKit

public extension UIViewController {
    struct AlertButton {
        let title: String
        let style: UIAlertAction.Style
        let handler: ((UIAlertAction) -> Void)?
    }

    func presentAlert(title: String? = nil, message: String? = nil, style: UIAlertController.Style, actions: [AlertButton]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        actions.forEach { actionModel in
            let action = UIAlertAction(title: actionModel.title, style: actionModel.style, handler: actionModel.handler)
            alert.addAction(action)
        }

        self.present(alert, animated: true, completion: nil)
    }
}
