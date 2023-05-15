//
//  ViewModelType.swift
//  SpecialistApp
//
//  Created by alexander on 17.04.2023.
//

import Foundation

protocol ViewModelType: AnyObject {
    associatedtype ViewModelInput
    associatedtype ViewModelOutput

    func transform(input: ViewModelInput) -> ViewModelOutput
}
