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
    case chatSettings
    case chatPhone
    case chatSettingsBlack

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
    
    private var chatSettingsButton: UIButton {
        let chatSettingsButton = UIButton(type: .custom)
        let chatSettingsImage = #imageLiteral(resourceName: "chat_settings")
        chatSettingsButton.setImage(chatSettingsImage, for: .normal)
        return chatSettingsButton
    }
    
    private var chatPhoneButton: UIButton {
        let chatPhoneButton = UIButton(type: .system)
        let chatPhoneImage = UIImage(systemName: "phone")
        chatPhoneButton.setImage(chatPhoneImage, for: .normal)
        chatPhoneButton.tintColor = Color1.black
        return chatPhoneButton
    }
    
    private var chatSettingsBlackButton: UIButton {
        let chatSettingsBlackButton = UIButton(type: .system)
        let chatSettingsImage = UIImage(systemName: "ellipsis")!
        let chatSettingsImage2 = UIImage(cgImage: chatSettingsImage.cgImage!, scale: chatSettingsImage.scale, orientation: .right)
        chatSettingsBlackButton.setImage(chatSettingsImage2, for: .normal)
        chatSettingsBlackButton.tintColor = Color1.black
        return chatSettingsBlackButton
    }
    
    var button: UIButton {
        switch self {
        case .back: return backButton
        case .close: return closeButton
        case .settings: return settingsButton
        case .share: return shareButton
        case .edit: return editButton
        case .chatSettings: return chatSettingsButton
        case .chatPhone: return chatPhoneButton
        case .chatSettingsBlack: return chatSettingsBlackButton
        }
    }
}
