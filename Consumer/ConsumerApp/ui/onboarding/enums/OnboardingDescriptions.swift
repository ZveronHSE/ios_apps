//
//  OnboardingDescriptions.swift
//  iosapp
//
//  Created by Никита Ткаченко on 18.04.2022.
//

import Foundation
import UIKit
enum OnboardingDescriptions: String {
    case onboarding1 = "Просто укажите номер и введите присланный код, чтобы пользоваться всеми функциями приложения"
    case onboarding2 = "Покупатели больше доверяют продавцам с заполненным профилем"
    case onboarding3 = "При поиске пользуйтесь фильтром, который позволит найти нужного вам питомца по уникальным параметрам"
    case onboarding4 = "Избранное будет разделено по категориям для вашего удобства"
    case onboarding5 = "Просматривайте подробную информацию о питомце, перейдя на его карточку с ленты"
    
    
    static func getDescription(_ idx: Int) -> String {
        switch idx {
        case 0: return self.onboarding1.rawValue
        case 1: return self.onboarding2.rawValue
        case 2: return self.onboarding3.rawValue
        case 3: return self.onboarding4.rawValue
        case 4: return self.onboarding5.rawValue
        default: return ""
        }
    }
    
}
