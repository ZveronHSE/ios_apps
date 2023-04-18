//
//  UIViewController+Root.swift
//  SpecialistApp
//
//  Created by alexander on 10.04.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func pushToRoot(vc: UIViewController, animated: Bool = true) {
        rootNavVC().pushViewController(vc, animated: animated)
    }

    func popFromRoot(animated: Bool = true) {
        rootNavVC().popViewController(animated: animated)
    }
}

internal func rootNavVC() -> UINavigationController {
    guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) else { fatalError("not found active scene") }

    guard let window = (scene as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow }) else { fatalError("not found key window in active scene") }

    guard let rootNavVC = (window.rootViewController as? UINavigationController) else { fatalError("root controller does not UINavigationViewController") }

    return rootNavVC
}

extension UIViewController {
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
