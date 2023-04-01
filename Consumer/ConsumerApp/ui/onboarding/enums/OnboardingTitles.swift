//
//  OnboardingTitles.swift
//  iosapp
//
//  Created by Никита Ткаченко on 18.04.2022.
//

import Foundation
import UIKit
enum OnboardingTitles: String {
    case onboarding1 = "Регистрация в два шага"
    case onboarding2 = "Заполняйте профиль"
    case onboarding3 = "Ищите животных удобнее чем обычно"
    case onboarding4 = "Раздельное избранное по товарам и животным"
    case onboarding5 = "Карточка питомца"
    
    static func getTitle(_ idx: Int) -> String {
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
