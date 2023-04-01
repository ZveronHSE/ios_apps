//
// Created by alexander on 20.02.2023.
//

import Foundation
import RxSwift
import ConsumerDomain
import FavoritesGRPC
import ZveronNetwork
import SwiftProtobuf
import CoreGRPC

public final class FavoriteRemoteDataSource: FavoriteDataSourceProtocol {
    private let apigateway: Apigateway

    public init(apigateway: Apigateway) {
        self.apigateway = apigateway
    }

    public func addLot(request: AddLotToFavoritesRequest) -> Observable<Void> { 
        return apigateway
            .callWithRetry(requestBody: request, methodAlies: "lotFavoritesAdd")
    }

    public func removeLot(request: RemoveLotFromFavoritesRequest) -> Observable<Void> {
        return apigateway
            .callWithRetry(requestBody: request, methodAlies: "lotFavoritesDelete")
    }

    public func getLotsByCategory(request: GetFavoriteLotsRequest) -> Observable<GetFavoriteLotsResponse> {
        return apigateway
            .callWithRetry(returnType: GetFavoriteLotsResponse.self, requestBody: request, methodAlies: "lotFavoritesGet")
    }

    public func addProfile(request: AddProfileToFavoritesRequest) -> Observable<Void> {
        return apigateway
            .callWithRetry(requestBody: request, methodAlies: "profileFavoriteAdd")
    }

    public func removeProfile(request: RemoveProfileFromFavoritesRequest) -> Observable<Void> {
        return apigateway
            .callWithRetry(requestBody: request, methodAlies: "profileFavoriteRemove")
    }
    
    public func getProfiles() -> Observable<GetFavoriteProfilesResponse> {
        return apigateway
            .callWithRetry(returnType: GetFavoriteProfilesResponse.self, methodAlies: "profileFavoriteGet")
    }

    public func deleteLotsByStatusAndCategory(request: DeleteAllByStatusAndCategoryRequest) -> Observable<Void> {
        return apigateway
            .callWithRetry(requestBody: request, methodAlies: "lotFavoritesDeleteByStatusAndCategory")
    }

    public func deleteAllLotsByCategory(request: DeleteAllByCategoryRequest) -> Observable<Void> {
        return apigateway
            .callWithRetry(requestBody: request, methodAlies: "lotFavoritesDeleteByCategory")
    }
}
