//
//  AddingLotTypeViewModel.swift
//  iosapp
//
//  Created by Никита Ткаченко on 09.05.2022.
//

import Foundation
import RxRelay
import RxSwift
import ZveronRemoteDataService
import ConsumerDomain
import ParameterGRPC

class AddingLotTypeViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    private let createLotUseCase: CreateLotUseCaseProtocol
    private let errorTracker = ErrorTracker()
    
    let categories: PublishSubject<[ParameterGRPC.Category]> = PublishSubject()

    
    public init(_ createLotUseCase: CreateLotUseCaseProtocol) {
        self.createLotUseCase = createLotUseCase
    }
    
    public func getChildren(categoryId: Int32) {
        createLotUseCase.getChildren(categoryId: categoryId)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                self.categories.onNext($0)
            })
            .disposed(by: disposeBag)
    }
}
