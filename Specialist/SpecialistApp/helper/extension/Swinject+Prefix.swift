//
//  Swinject+Prefix.swift
//  SpecialistApp
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import Swinject

prefix operator <?
prefix func <? <Service>(_ resolver: Resolver) -> Service? {
    return resolver.resolve(Service.self)
}

prefix operator <~
prefix func <~ <Service>(_ resolver: Resolver) -> Service {
    return (<?resolver)!
}
