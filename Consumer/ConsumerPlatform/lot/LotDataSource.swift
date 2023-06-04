//
//  LotDataSource.swift
//  Platform
//
//  Created by alexander on 15.02.2023.
//

import Foundation
import ConsumerDomain
import RxSwift
import LotGRPC
import ZveronNetwork

public final class LotRemoteDataSource: LotDataSourceProtocol {

    private let apigateway: Apigateway

    public init(_ apigateway: Apigateway) {
        self.apigateway = apigateway
    }

    public func getWaterfall(request: WaterfallRequest) -> Observable<WaterfallResponse> {
        return apigateway.callWithRetry(returnType: WaterfallResponse.self, requestBody: request, methodAlies: "waterfallGet")
    }

    public func createLot(lot: CreateLot) -> Observable<CardLot> {
        let communicationChannels = lot.communication_channel.map({ LotGRPC.CommunicationChannel.init(rawValue: $0.rawValue)! })
        let photosLot = lot.photos.map { photo in
            LotGRPC.Photo.with {
                $0.url = photo.url
                $0.order = photo.order
            }
        }
        let request = CreateLotRequest.with { body in
            body.title = lot.title
            body.photos = photosLot
            body.parameters = lot.parameters
            body.price = lot.price
            body.description_p = lot.description
            body.communicationChannel = communicationChannels
            lot.gender.flatMap{ body.gender = LotGRPC.Gender(rawValue: $0.rawValue)! }
            lot.address.town.flatMap{body.address.town = $0}
            lot.address.region.flatMap{body.address.region = $0}
            lot.address.district.flatMap{body.address.district = $0}
            lot.address.street.flatMap{body.address.street = $0}
            body.address.longitude = lot.address.longitude
            body.address.latitude = lot.address.latitude
            body.lotFormID = lot.lot_form_id
            body.categoryID = lot.category_id

        }

        return apigateway.callWithRetry(returnType: CardLot.self, requestBody: request, methodAlies: "lotCreate")
    }

    public func editLot(request: EditLotRequest) -> Observable<CardLot> {
        fatalError("not implemented")
    }

    public func closeLot(request: CloseLotRequest) -> Observable<Void> {
        fatalError("not implemented")
    }

    public func getCardLot(request: CardLotRequest) -> Observable<CardLot> {
        return apigateway.callWithRetry(returnType: CardLot.self, requestBody: request, methodAlies: "cardLotGet")
    }
    
    public func getOwnLots(request: GetOwnLotsRequest) -> Observable<WaterfallResponse> {
        return apigateway.callWithRetry(returnType: WaterfallResponse.self, requestBody: request, methodAlies: "lotGetOwns")
    }
}
