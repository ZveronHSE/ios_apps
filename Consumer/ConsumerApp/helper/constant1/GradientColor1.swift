//
//  GradientColor1.swift
//
//
//  Created by alexander on 08.02.2023.
//

import UIKit

public typealias CompositeColor = (start: UIColor, end: UIColor)
public struct GradientColor1 {

    public static let orange1: CompositeColor = (Color1.orange1, Color1.orange2)
    public static let orange2: CompositeColor = (Color1.orange3, Color1.orange2)

    public static let green: CompositeColor = (Color1.green1, Color1.green2)
}
