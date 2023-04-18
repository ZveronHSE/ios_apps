//
//  BindableView.swift
//  SpecialistApp
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import RxSwift

protocol BindableView {
    associatedtype ViewModelType

    var disposeBag: DisposeBag { get }

    func bind(to viewModel: ViewModelType)
}
