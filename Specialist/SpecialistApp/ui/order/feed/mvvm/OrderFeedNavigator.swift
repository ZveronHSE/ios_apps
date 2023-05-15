//
//  OrderFeedNavigator.swift
//  SpecialistApp
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import Swinject
import UIKit
import SpecialistDomain

protocol OrderFeedNavigatorProtocol {
    func toFeeds()
    func toOrder(model: Order)
}

final class OrderFeedNavigator: OrderFeedNavigatorProtocol {
    private let resolver: Container
    private let navigationManager: NavigationManager

    init(resolver: Container, navigationManager: NavigationManager) {
        self.resolver = resolver
        self.navigationManager = navigationManager
    }

    func toFeeds() {
        let vc = OrderFeedViewController()
        let vm = OrderFeedViewModel(with: <~resolver, and: self)
        vc.bind(to: vm)
        navigationManager.pushViewController(vc, identifier: .orderFeeds, animated: true)
    }

    func toOrder(model: Order) {
        let newNavigationManager: NavigationManager = .init(manage: rootNavVC())
        let navigator = OrderCardNavigator(resolver: resolver, navigationManager: newNavigationManager)

        let vc = OrderCardViewController()
        let vm = OrderCardViewModel(with: <~resolver, and: <~resolver, and: navigator, and: model)
        vc.bind(to: vm)

        newNavigationManager.pushViewController(vc, identifier: .order(id: model.id), animated: true)
    }
}
