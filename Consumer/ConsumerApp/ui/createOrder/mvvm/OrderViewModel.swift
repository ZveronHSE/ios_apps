//
//  OrderViewModel.swift
//  ConsumerApp
//
//  Created by alexander on 12.05.2023.
//

import Foundation
import ConsumerDomain
import RxSwift

class OrderViewModel: ViewModelType {

    let disposeBag = DisposeBag()
    let usecase: OrderUseCaseProtocol
    let profileUseCase: ProfileUseCaseProtocol

    public init(_ usecase: OrderUseCaseProtocol, _ profileUseCase: ProfileUseCaseProtocol) {
        self.usecase = usecase
        self.profileUseCase = profileUseCase
    }
}
