//
//  OrderCustomerProfileNavigator.swift
//  SpecialistApp
//
//  Created by alexander on 19.04.2023.
//

import Foundation
import UIKit
import Swinject
import SpecialistDomain

protocol OrderCustomerProfileNavigatorProtocol {
    func toBack()
    func toOrder(model: Order)
}

final class OrderCustomerProfileNavigator: OrderCustomerProfileNavigatorProtocol {
    private let resolver: Container
    private let navigationManager: NavigationManager

    init(resolver: Container, navigationManager: NavigationManager) {
        self.resolver = resolver
        self.navigationManager = navigationManager
    }

    func toBack() { navigationManager.popViewController(animated: true) }

    func toOrder(model: Order) {
        if navigationManager.getPreviousViewControllerIdentifier() == .order(id: model.id) { self.toBack(); return }

        let navigator = OrderCardNavigator(resolver: resolver, navigationManager: navigationManager)

        let vc = OrderCardViewController()
        let vm = OrderCardViewModel(with: <~resolver, and: <~resolver, and: navigator, and: model)
        vc.bind(to: vm)

        navigationManager.pushViewController(vc, identifier: .order(id: model.id), animated: true)
    }
}
