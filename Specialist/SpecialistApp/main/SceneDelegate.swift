//
//  SceneDelegate.swift
//  specialist
//
//  Created by alexander on 26.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: UIScreen.main.bounds)

        window?.windowScene = windowScene

        // MARK: сюда можно тыкать тестируемый контроллер сразу
        // let rootVC = OrderCardViewController()
        // rootVC.setup()

        let rootVC = TabBarViewController()

        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        window?.makeKeyAndVisible()
    }
}
