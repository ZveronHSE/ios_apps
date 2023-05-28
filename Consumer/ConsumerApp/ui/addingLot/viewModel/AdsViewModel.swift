//
//  AdsViewModel.swift
//  iosapp
//
//  Created by Никита Ткаченко on 04.05.2022.
//

import Foundation
import RxSwift
import ConsumerDomain
import RxRelay
import CoreGRPC

class AdsViewModel: ViewModelType {

    let disposeBag = DisposeBag()
    private let lotUseCase: CreateLotUseCaseProtocol
    private let errorTracker = ErrorTracker()
    let ownLots: PublishSubject<[CoreGRPC.Lot]> = PublishSubject()
    let isLoadedOwnLots: PublishSubject<Bool> = PublishSubject()
    let isLoadedOwnLotsRefresh: PublishSubject<Bool> = PublishSubject()
    
    
    public init(_ lotUseCase: CreateLotUseCaseProtocol) {
        self.lotUseCase = lotUseCase
    }
    
    
    func getOwnLots() {
        lotUseCase.getOwnLots()
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                self.ownLots.onNext($0.0)
            })
            .disposed(by: disposeBag)
    }
}
