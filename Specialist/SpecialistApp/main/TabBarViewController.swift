//
//  TabBarViewController.swift
//  specialist
//
//  Created by alexander on 26.03.2023.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.barTintColor = .zvGray3
        tabBar.tintColor = .zvRedMain
        tabBar.backgroundColor = .zvWhite
        tabBar.layer.cornerRadius = 10

        let orderFeedVC = OrderFeedViewController()

        viewControllers = [
            createTabBarItem(tabBarTitle: "Главная", tabBarImage: .zvSearch, viewController: orderFeedVC)
        ]
    }

    private func createTabBarItem(
        tabBarTitle: String,
        tabBarImage: UIImage,
        viewController: UIViewController
    ) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.tabBarItem.title = tabBarTitle
        navVC.tabBarItem.image = tabBarImage

        navVC.navigationBar.backgroundColor = .zvBackground
        viewController.view.backgroundColor = .zvBackground

        return navVC
    }
}
