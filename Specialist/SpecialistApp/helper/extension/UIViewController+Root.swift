//
//  UIViewController+Root.swift
//  SpecialistApp
//
//  Created by alexander on 10.04.2023.
//

import Foundation
import UIKit

extension UIViewController {

    private func rootNavVC() -> UINavigationController {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) else { fatalError("not found active scene") }

        guard let window = (scene as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow }) else { fatalError("not found key window in active scene") }

        guard let rootNavVC = (window.rootViewController as? UINavigationController) else { fatalError("root controller does not UINavigationViewController") }

        return rootNavVC
    }

    func pushToRoot(vc: UIViewController, animated: Bool = true) {
        rootNavVC().pushViewController(vc, animated: animated)
    }

    func popFromRoot(animated: Bool = true) {
        rootNavVC().popViewController(animated: animated)
    }
}
