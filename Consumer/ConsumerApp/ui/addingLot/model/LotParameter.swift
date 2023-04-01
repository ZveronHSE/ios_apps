//
//  LotParameter.swift
//  iosapp
//
//  Created by Никита Ткаченко on 09.05.2022.
//

import Foundation
import ParameterGRPC
struct LotParameter {
    let id: Int32
    let name: String
    let type: TypeEnum
    let isRequired: Bool
    // пока что из за того что так отдает бек
    let values: [String]
    var choosenValues: [String]?
}
