//
//  AuthServiceProtocol.swift
//  iosapp
//
//  Created by alexander on 18.01.2023.
//

import Foundation
import RxSwift

protocol AuthServiceProtocol {
    func login() -> Observable<String>
}
