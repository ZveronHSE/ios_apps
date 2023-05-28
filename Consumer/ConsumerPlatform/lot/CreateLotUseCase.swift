//
//  CreateLotUseCase.swift
//  Platform
//
//  Created by Nikita on 27.03.2023.
//

import Foundation
//TODO: потом убрать LotGRPC после замены на entity
import LotGRPC
import ParameterGRPC
import ConsumerDomain
import RxSwift
import ObjectstorageGRPC
import CoreGRPC

public final class CreateLotUseCase: CreateLotUseCaseProtocol {
    private let objectRepository: ObjectStorageRepositoryProtocol
    private let lotRepository: LotRepositoryProtocol
    private let parameterRepository: ParameterRepositoryProtocol

    public init(with lotRepository: LotRepositoryProtocol,
                with parameterRepository: ParameterRepositoryProtocol,
                and objectRepository: ObjectStorageRepositoryProtocol) {
        self.lotRepository = lotRepository
        self.parameterRepository = parameterRepository
        self.objectRepository = objectRepository
    }


    public func createLot(lot: CreateLot) -> Observable<CardLot> {
        return lotRepository.createLot(lot: lot)
            .mapErrors(default: LotError.failedCreateLot)
    }
    
    public func getLotForms(categoryId: Int32) -> Observable<[LotForm]> {
        return parameterRepository.getLotForms(categoryId: categoryId)
            .mapErrors(default: ParameterError.failedGetLotForms)
    }
    
    public func getChildren(categoryId: Int32) -> Observable<[ParameterGRPC.Category]> {
        return parameterRepository.getChildren(categoryId: categoryId)
            .mapErrors(default: ParameterError.failedGetChildren)
    }
    
    public func getParameters(categoryId: Int32, lotFormId: Int32) -> Observable<[ParameterGRPC.Parameter]> {
        return parameterRepository.getParameters(categoryId: categoryId, lotFormId: lotFormId)
            .mapErrors(default: ParameterError.failedGetParameters)
    }

    public func uploadImage(image: Data, type: ObjectstorageGRPC.MimeType) -> RxSwift.Observable<String> {
        return objectRepository.uploadImage(image: image, type: type)
    }
    
    public func getOwnLots() -> Observable<([CoreGRPC.Lot], LotGRPC.LastLot)> {
        return lotRepository.getOwnLots()
            .mapErrors(default: LotError.failedGetOwnLots)

    }
    
}
