//
//  AddingLotAddressViewModel.swift
//  iosapp
//
//  Created by Никита Ткаченко on 10.05.2022.
//

import Foundation
import RxRelay
import RxSwift
import ZveronRemoteDataService
import ConsumerDomain
import LotGRPC

class AddingLotAddressViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    private let createLotUseCase: CreateLotUseCaseProtocol
    private let errorTracker = ErrorTracker()
    
    let addressLot = BehaviorRelay<String?>(value: "")
    let continueBtn = PublishRelay<Bool>()
    let alert = PublishRelay<AlertModel?>()
    let isPhone = BehaviorRelay<Bool>(value: false)
    let isChat = BehaviorRelay<Bool>(value: false)
    
    let cardLot: PublishSubject<LotGRPC.CardLot> = PublishSubject()
    
    
    private var isValidAddress: Observable<Bool> {
        return addressLot.map {
            guard let value = $0 else { return false }
            return value.count > 3 && value.count < 50
        }
    }
    
    private var isValidForm: Observable<Bool> {
        return Observable.combineLatest(isValidAddress, isPhone, isChat) { $0 && ($1 || $2) }
    }
    

    public init(_ createLotUseCase: CreateLotUseCaseProtocol) {
        self.createLotUseCase = createLotUseCase
        bindViews()
    }
    
    func bindViews() {
        isValidForm.bind(to: continueBtn).disposed(by: disposeBag)
        
        isValidAddress.bind(onNext: { valid in
            if valid {
                self.alert.accept(nil)
            } else {
                guard let value = self.addressLot.value else { return }
                if value.count <= 3 {
                    self.alert.accept(AlertModel(
                        message: "Название города слишком короткое",
                        mode: .warning))
                }
                else {
                    self.alert.accept(AlertModel(
                        message: "Название города слишком длинное",
                        mode: .warning))
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    public func createLot(lot: CreateLot) {
        createLotUseCase.createLot(lot: lot)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                self.cardLot.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    
}
