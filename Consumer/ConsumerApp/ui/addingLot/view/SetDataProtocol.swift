//
//  SetDataProtocol.swift
//  iosapp
//
//  Created by Никита Ткаченко on 08.05.2022.
//

import Foundation
import ConsumerDomain

protocol SetDataProtocol {
    func setUpData(data: [TableInfo], lot: CreateLot)
}
