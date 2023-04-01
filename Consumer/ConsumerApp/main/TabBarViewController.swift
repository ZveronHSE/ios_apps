//
//  TabBarViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 25.04.2022.
//

import UIKit
import Swinject
import ZveronNetwork
import ConsumerPlatform

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    //    let container = Container { container in
    //        // APIGATEWAY
    //        container.register(Apigateway.self) { _ in Apigateway() }
    //
    //        // REMOTE_DATA_SOURCE
    //        container.register(Platform.AuthRemoteDataSource.self) { Platform.AuthRemoteDataSource(apigateway: <~$0) }
    //
    //        // LOCAL_DATA_SOURCE
    //
    //        // REPOSITORY
    //        container.register(Platform.AuthRepository.self) { Platform.AuthRepository(remote: <~$0) }
    //
    //        // USE_CASE
    //        container.register(Platform.AuthUseCase.self) { Platform.AuthUseCase(authRepository: <~$0) }
    //    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.barTintColor = Color.tabBarBarTintColor.color
        tabBar.tintColor = Color.tabBarTintColor.color
        tabBar.layer.cornerRadius = 10
        tabBar.backgroundColor = .white

        let mainVC = FirstNestingLevelViewController()
        // let mainVC = createTabBarItem(tabBarTitle: "Главная", tabBarImage: #imageLiteral(resourceName: "home_icon"))
        // let mainNavigator = MainNavigator(resolver: container, navigationController: mainVC)

        let favoriteVC = FavoriteViewController()
        let addVC = AdsViewController()
        let chatVC = ChatViewController()
        let profileVC = ProfileViewController()
        viewControllers = [
            //   mainVC,
            createTabBarItem(tabBarTitle: "Главная", tabBarImage: #imageLiteral(resourceName: "home_icon"), viewController: mainVC),
            createTabBarItem(tabBarTitle: "Избранное", tabBarImage: #imageLiteral(resourceName: "favorite_icon"), viewController: favoriteVC),
            createTabBarItem(tabBarTitle: "Объявления", tabBarImage: #imageLiteral(resourceName: "plusGradient"), viewController: addVC),
            createTabBarItem(tabBarTitle: "Сообщения", tabBarImage: #imageLiteral(resourceName: "chat_icon"), viewController: chatVC),
            createTabBarItem(tabBarTitle: "Профиль", tabBarImage: #imageLiteral(resourceName: "profile_icon"), viewController: profileVC)
        ]

        //  mainNavigator.toMain()
    }

    func createTabBarItem(
        tabBarTitle: String,
        tabBarImage: UIImage,
        viewController: UIViewController
    ) -> UINavigationController {
        let navCont = UINavigationController(rootViewController: viewController)
        navCont.tabBarItem.title = tabBarTitle
        navCont.tabBarItem.image = tabBarImage
        return navCont
    }

    func createTabBarItem(
        tabBarTitle: String,
        tabBarImage: UIImage
    ) -> UINavigationController {
        let navCont = UINavigationController()
        navCont.tabBarItem.title = tabBarTitle
        navCont.tabBarItem.image = tabBarImage
        return navCont
    }


    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        switch viewController.children.first {
        case is FavoriteViewController: break
        case is AdsViewController: break
        case is ChatViewController: break
        case is ProfileViewController: break
        default:
            return true
        }
        guard let currentVC = tabBarController.selectedViewController?.children.first as? UIViewControllerWithAuth else { fatalError("каждый базовый контроллер с таб бара должен быть унаследован от UIViewControllerWithAuth!") }

        switch TokenAcquisitionService.shared.authState {
        case .authorized, .needUpdateAccess: return true
        case .notAuthorized, .logout:
            currentVC.presentAuthorizationWithAlert(message: "Для просмотра необходимо авторизоваться")
            return false
        }
    }
}
