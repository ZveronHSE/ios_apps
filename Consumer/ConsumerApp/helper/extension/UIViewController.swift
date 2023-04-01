//
//  UIViewController.swift
//  iosapp
//
//  Created by alexander on 19.01.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            let okAlertAction = UIAlertAction(title: "ОК", style: .default)
            alert.addAction(okAlertAction)
            self.present(alert, animated: true)
        }
    }
}

