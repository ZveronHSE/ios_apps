//
//  TabBarViewController.swift
//  specialist
//
//  Created by alexander on 26.03.2023.
//

import Foundation
import UIKit
import Swinject
import SpecialistDomain
import SpecialistPlatform
import ZveronNetwork

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let resolver = Container { container in
        // MARK: APIGATEWAY
        container.register(Apigateway.self) { _ in Apigateway() }.inObjectScope(.container)

        // MARK: DATA_SOURCE
         container.register(OrderDataSourceProtocol.self) { OrderDataSource(with: <~$0) }.inObjectScope(.container)
         container.register(ProfileDataSourceProtocol.self) { ProfileDataSource(with: <~$0) }.inObjectScope(.container)

//        container.register(OrderDataSourceProtocol.self) { _ in OrderDataSourceMock() }.inObjectScope(.container)
//        container.register(ProfileDataSourceProtocol.self) { _ in ProfileDataSourceMock() }.inObjectScope(.container)

        // MARK: REPOSITORY
        container.register(OrderRepositoryProtocol.self) { OrderRepository(with: <~$0) }.inObjectScope(.container)
        container.register(ProfileRepositoryProtocol.self) { ProfileRepository(with: <~$0) }.inObjectScope(.container)

        // MARK: USE_CASE
        container.register(OrderUseCaseProtocol.self) { OrderUseCase(with: <~$0) }.inObjectScope(.container)
        container.register(ProfileUseCaseProtocol.self) { ProfileUseCase(with: <~$0) }.inObjectScope(.container)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.barTintColor = .zvGray3
        tabBar.tintColor = .zvRedMain
        tabBar.backgroundColor = .zvWhite
        tabBar.layer.cornerRadius = 10

        let orderFeedVC = createTabBarItem(tabBarTitle: "Главная", tabBarImage: .zvSearch)
        let orderFeedNavigator = OrderFeedNavigator(resolver: resolver, navigationManager: .init(manage: orderFeedVC))

        viewControllers = [
            orderFeedVC
        ]

        orderFeedNavigator.toFeeds()
    }

    private func createTabBarItem(
        tabBarTitle: String,
        tabBarImage: UIImage
    ) -> UINavigationController {
        let navVC = UINavigationController()
        navVC.tabBarItem.title = tabBarTitle
        navVC.tabBarItem.image = tabBarImage
        navVC.navigationBar.backgroundColor = .zvBackground
        return navVC
    }
}
