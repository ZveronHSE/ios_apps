//
//  OrderAnimalProfileNavigator.swift
//  SpecialistApp
//
//  Created by alexander on 18.04.2023.
//

import Foundation
import UIKit
import SpecialistDomain

protocol OrderAnimalProfileNavigatorProtocol {
    func toBack()
    func presentDocument(document: URL)
}

final class OrderAnimalProfileNavigator: OrderAnimalProfileNavigatorProtocol {
    private let navigationManager: NavigationManager

    init(navigationManager: NavigationManager) {
        self.navigationManager = navigationManager
    }

    func toBack() { navigationManager.popViewController(animated: true) }

    func presentDocument(document: URL) {
        let vc = PDFViewController(pdfUrl: document)
        vc.modalPresentationStyle = .fullScreen

        navigationManager.present(vc, animated: true)
    }
}
