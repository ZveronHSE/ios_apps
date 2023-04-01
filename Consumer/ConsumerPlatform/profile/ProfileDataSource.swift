//
//  ProfileDatasource.swift
//  Platform
//
//  Created by alexander on 10.02.2023.
//

import Foundation
import RxSwift
import ProfileGRPC
import ConsumerDomain
import ZveronNetwork

public final class ProfileRemoteDataSource: ProfileDataSourceProtocol {
    
    private let apigateway: Apigateway

    public init(_ apigateway: Apigateway) {
        self.apigateway = apigateway
    }
    
    
    public func getProfilePage(request: GetProfilePageRequest) -> Observable<Void> {
        apigateway.callWithRetry(requestBody: request, methodAlies: "profileGetPage")
    }
    
    public func getProfileInfo() -> Observable<ProfileInfo> {
        return apigateway.callWithRetry(returnType: GetProfileInfoResponse.self, methodAlies: "profileGetInfo")
            .map {
                ProfileInfo.init(
                    id: $0.id,
                    name: $0.name,
                    surname: $0.surname,
                    imageUrl: $0.imageURL,
                    rating: $0.rating,
                    address: ConsumerDomain.Address.init(
                        region: $0.address.region,
                        town: $0.address.town,
                        longitude: $0.address.longitude,
                        latitude: $0.address.latitude
                    )
                )
            }
    }
    
    public func setProfileInfo(request: SetProfileInfoRequest) -> Observable<Void> {
        apigateway.callWithRetry(requestBody: request, methodAlies: "profileSetInfo")
    }
    
    public func getSettings() -> Observable<GetSettingsResponse> {
        return apigateway.callWithRetry(returnType: GetSettingsResponse.self, methodAlies: "profileGetSettings")
    }
    
    public func setSettings(request: SetSettingsRequest) -> Observable<Void> {
        return apigateway.callWithRetry(requestBody: request, methodAlies: "profileSetSettings")
    }
    
    public func getChannelTypes() -> Observable<GetChannelTypesResponse> {
        return apigateway.callWithRetry(returnType: GetChannelTypesResponse.self, methodAlies: "profileGetChannelTypes")
    }
    
    public func getLinks() -> Observable<Links> {
        return apigateway.callWithRetry(returnType: Links.self, methodAlies: "profileGetLinks")
    }
    
    public func deleteProfile() -> Observable<Void> {
        apigateway.callWithRetry(methodAlies: "profileDelete")
    }
    

}
