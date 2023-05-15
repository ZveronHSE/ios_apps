//
//  NavigationManager.swift
//  SpecialistApp
//
//  Created by alexander on 22.04.2023.
//

import Foundation
import UIKit

final class NavigationManager {
    public enum UIControllerIdentifier: Equatable {
        case orderFeeds
        case order(id: Int)
        case animalProfile(id: Int)
        case customerProfile(id: Int)
        case other
    }

    private let navigationController: UINavigationController
    private var identifiers: [UIControllerIdentifier] = []

    init(manage navigationController: UINavigationController) {
        self.navigationController = navigationController
        for _ in 0..<navigationController.viewControllers.count {
            identifiers.append(.other)
        }
    }

    func pushViewController(_ viewController: UIViewController, identifier: UIControllerIdentifier, animated: Bool) {
        self.identifiers.append(identifier)
        self.navigationController.pushViewController(viewController, animated: animated)
    }

    func popViewController(animated: Bool) {
        self.navigationController.popViewController(animated: animated)
        self.identifiers.removeLast()
    }

    func getPreviousViewControllerIdentifier() -> UIControllerIdentifier {
        let idx = self.identifiers.count - 2

        guard idx >= 0 else { fatalError("unexpected previous controller") }

        return self.identifiers[idx]
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        self.navigationController.present(viewController, animated: animated)
    }
}
