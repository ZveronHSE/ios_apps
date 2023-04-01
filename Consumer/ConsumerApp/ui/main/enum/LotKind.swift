//
//  LotType.swift
//  iosapp
//
//  Created by alexander on 15.05.2022.
//

import Foundation
import AVFAudio

public enum LotKind: String, CaseIterable {
    case sell = "Продажа"
    case sluchka = "На случку"
    case arenda = "В аренду"

    static func parseType(_ name: String) -> LotKind? {
        return LotKind.init(rawValue: name)
    }
}
