//
//  SetLotProtocol.swift
//  iosapp
//
//  Created by Никита Ткаченко on 10.05.2022.
//

import Foundation
import ConsumerDomain

protocol SetLotProtocol {
    func setLot(_ lot: CreateLot, parameters: [LotParameter])
}
