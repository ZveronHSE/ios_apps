//
//  AddingLotCategoryViewModel.swift
//  iosapp
//
//  Created by Никита Ткаченко on 08.05.2022.
//

import Foundation
import RxRelay
import RxSwift
import ZveronRemoteDataService
import ConsumerDomain
import ParameterGRPC

class CategoryTypeNestedViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    private let createLotUseCase: CreateLotUseCaseProtocol
    private let errorTracker = ErrorTracker()
    
    let isLoadedInfo: PublishSubject<Bool> = PublishSubject()
    let params: PublishSubject<[ParameterGRPC.Parameter]> = PublishSubject()

    
    public init(_ createLotUseCase: CreateLotUseCaseProtocol) {
        self.createLotUseCase = createLotUseCase
    }
    
    
    public func getParameters(categoryId: Int32, lotFormId: Int32) {
        createLotUseCase.getParameters(categoryId: categoryId, lotFormId: lotFormId)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                self.params.onNext($0)
            })
            .disposed(by: disposeBag)
    }
}
