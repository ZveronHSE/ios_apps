//
//  ViewModelType.swift
//  iosapp
//
//  Created by alexander on 18.02.2023.
//

import Foundation
import RxSwift

protocol ViewModelType: AnyObject {
    // TODO: uncomment this when second todo will be done
//    associatedtype ViewModelInput
//    associatedtype ViewModelOutput
//
//    func transform(input: ViewModelInput) -> ViewModelOutput

    // TODO: Remove this, when all viewmodels will be maken correctly
    var disposeBag: DisposeBag { get }
}
