//
//  BindableView.swift
//  iosapp
//
//  Created by alexander on 18.02.2023.
//

import Foundation
import RxSwift

protocol BindableView {
    associatedtype ViewModelType

    var disposeBag: DisposeBag { get }

    func bind(to viewModel: ViewModelType)
}
