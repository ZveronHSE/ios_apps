//
//  OrderCardNavigator.swift
//  SpecialistApp
//
//  Created by alexander on 18.04.2023.
//

import Foundation
import UIKit
import Swinject
import SpecialistDomain

protocol OrderCardNavigatorProtocol {
    func toBack()
    func toAnimalProfile(model: AnimalProfile)
    func toCustomerProfile(model: CustomerProfile)
    func toSimilarOrder(model: Order)
}

final class OrderCardNavigator: OrderCardNavigatorProtocol {
    private let resolver: Container
    private let navigationManager: NavigationManager

    init(resolver: Container, navigationManager: NavigationManager) {
        self.resolver = resolver
        self.navigationManager = navigationManager
    }

    func toBack() { navigationManager.popViewController(animated: true) }

    func toAnimalProfile(model: AnimalProfile) {
        let navigator = OrderAnimalProfileNavigator(navigationManager: navigationManager)

        let vc = OrderAnimalProfileController()
        let vm = OrderAnimalProfileViewModel(with: navigator, and: model)
        vc.bind(to: vm)

        navigationManager.pushViewController(vc, identifier: .animalProfile(id: model.id), animated: true)
    }

    func toCustomerProfile(model: CustomerProfile) {
        if navigationManager.getPreviousViewControllerIdentifier() == .customerProfile(id: model.id) { self.toBack(); return }

        let navigator = OrderCustomerProfileNavigator(resolver: resolver, navigationManager: navigationManager)

        let vc = OrderCustomerProfileController()
        let vm = OrderCustomerProfileViewModel(with: <~resolver, and: navigator, and: model)
        vc.bind(to: vm)

        navigationManager.pushViewController(vc, identifier: .customerProfile(id: model.id), animated: true)
    }

    func toSimilarOrder(model: Order) {
        if navigationManager.getPreviousViewControllerIdentifier() == .order(id: model.id) { self.toBack(); return }

        let navigator = OrderCardNavigator(resolver: resolver, navigationManager: navigationManager)

        let vc = OrderCardViewController()
        let vm = OrderCardViewModel(with: <~resolver, and: <~resolver, and: navigator, and: model)
        vc.bind(to: vm)

        navigationManager.pushViewController(vc, identifier: .order(id: model.id), animated: true)
    }
}
