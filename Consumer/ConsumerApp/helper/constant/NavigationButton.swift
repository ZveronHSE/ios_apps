//
//  NavigationItem.swift
//  iosapp
//
//  Created by Никита Ткаченко on 08.05.2022.
//

import UIKit

@available(*, deprecated, message: "Use the commented class under this class")
enum NavigationButton {
    case back
    case close
    case settings
    case share
    case edit

    private var closeButton: UIButton {
        let closeButton = UIButton(type: .system)
        let closeIcon = #imageLiteral(resourceName: "close_icon")
        closeButton.setImage(closeIcon, for: .normal)
        closeButton.tintColor = .black
        return closeButton
    }

    private var backButton: UIButton {
        let backButton = UIButton(type: .system)
        let backIcon = #imageLiteral(resourceName: "back_icon")
        backButton.setImage(backIcon, for: .normal)
        backButton.tintColor = .black
        return backButton
    }
    
    private var settingsButton: UIButton {
        let settingsButton = UIButton(type: .custom)
        let settingsImage = #imageLiteral(resourceName: "profile_settings")
        settingsButton.setImage(settingsImage, for: .normal)
        return settingsButton
    }
    
    private var shareButton: UIButton {
        let shareButton = UIButton(type: .custom)
        let shareImage = #imageLiteral(resourceName: "profile_share")
        shareButton.setImage(shareImage, for: .normal)
        return shareButton
    }
    
    private var editButton: UIButton {
        let editButton = UIButton(type: .custom)
        let editImage = #imageLiteral(resourceName: "profile_edit")
        editButton.setImage(editImage, for: .normal)
        return editButton
    }
    
    var button: UIButton {
        switch self {
        case .back: return backButton
        case .close: return closeButton
        case .settings: return settingsButton
        case .share: return shareButton
        case .edit: return editButton
        }
    }
}

//struct NavigationButton {
//    static var close: UIButton {
//        let closeButton = UIButton(type: .system)
//        closeButton.setImage(Icon.close, for: .normal)
//        closeButton.tintColor = ZveronConstant.Color.proto1
//        return closeButton
//    }
//
//    static var back: UIButton {
//        let backButton = UIButton(type: .system)
//        backButton.setImage(Icon.back, for: .normal)
//        backButton.tintColor = ZveronConstant.Color.proto1
//        return backButton
//    }
//}
