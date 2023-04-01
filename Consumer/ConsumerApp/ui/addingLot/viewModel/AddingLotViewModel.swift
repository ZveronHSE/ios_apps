//
//  AddingLotViewModel.swift
//  iosapp
//
//  Created by Никита Ткаченко on 03.05.2022.
//

import Foundation
import RxRelay
import RxSwift
import ZveronRemoteDataService
import UIKit
import ConsumerDomain
import ParameterGRPC

class AddingLotViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    private let createLotUseCase: CreateLotUseCaseProtocol
    private let errorTracker = ErrorTracker()
    let alert = PublishRelay<AlertModel?>()

    let isAnimalType = BehaviorRelay<Bool>(value: false)
    let nameLot = BehaviorRelay<String?>(value: "")
    let continueBtn = PublishRelay<Bool>()
    let lotForms: PublishSubject<[ParameterGRPC.LotForm]> = PublishSubject()
    
    var photoLot: [Photo] = []
    let imagesLot = BehaviorRelay<[UIImage]>(value: [])

    public init(_ createLotUseCase: CreateLotUseCaseProtocol) {
        self.createLotUseCase = createLotUseCase
        bind()
    }


    private var isValidNameLot: Observable<Bool> {
        return nameLot.map {
            guard let value = $0 else { return false }
            return value.cyrillicCharactersWithSpaceOnly && value.count >= 3 && value.count <= 40
        }
    }
    
    private var isValidImages: Observable<Bool> {
        return imagesLot.map {
            return $0.count >= 1
        }
    }
    
    private var isValidForm: Observable<Bool> {
        return Observable.combineLatest(isValidNameLot, isValidImages) { $0 && $1 }
    }

    private func bind() {
        isValidForm.bind(to: continueBtn).disposed(by: disposeBag)
        isValidNameLot.bind(onNext: { valid in
            if valid {
                self.alert.accept(nil)
            } else {
                guard let value = self.nameLot.value else { return }
                if value.count > 40 {
                    self.alert.accept(AlertModel(
                        message: "Название содержит много символов",
                        mode: .warning))
                }
                else if value.count < 3 {
                    self.alert.accept(AlertModel(
                        message: "Название содержит мало символов",
                        mode: .warning))
                }
                else {
                    self.alert.accept(AlertModel(
                        message: "Название содержит некорректные символы",
                        mode: .warning))
                }
            }
        }).disposed(by: disposeBag)
    }
    

    
    // получение видов продажи для товаров или животных
    public func getLotForms(categoryId: Int32) {
        createLotUseCase.getLotForms(categoryId: categoryId)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                self.lotForms.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    
//    func uploadImage() {
//        let image = self.imagesLot.value[self.imagesLot.value.endIndex - 1]
//        self.lotRepository.uploadImageLot(image: image, callback: { res in
//            guard let response = res as? SuccessResponse<PhotoId> else {
//                return
//            }
//            let order = self.photoLot.count
//            let photo = Photo(id: response.data.id, order: order)
//            self.photoLot.append(photo)
//        })
//    }


    func uploadImage(image: Data) -> Observable<String> {
       return self.createLotUseCase.uploadImage(image: image, type: .imageJpeg)
    }
}

