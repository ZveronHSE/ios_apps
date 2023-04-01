//
//  Swinject+Prefix.swift
//  iosapp
//
//  Created by alexander on 12.02.2023.
//

import Swinject

prefix operator <?
prefix func <? <Service>(_ resolver: Resolver) -> Service? {
    return resolver.resolve(Service.self)
}

prefix operator <~
prefix func <~ <Service>(_ resolver: Resolver) -> Service {
    return (<?resolver)!
}
