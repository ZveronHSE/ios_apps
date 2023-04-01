//
//  ProfileRepository.swift
//  Platform
//
//  Created by alexander on 10.02.2023.
//

import Foundation
import ConsumerDomain
import RxSwift
//TODO: потом убрать ProfileGRPC после замены на entity
import ProfileGRPC

public final class ProfileRepository: ProfileRepositoryProtocol {
    
    private let remoteSource: ProfileDataSourceProtocol

    public init(remote: ProfileDataSourceProtocol) {
        self.remoteSource = remote
    }
    
    public func getProfilePage() -> Observable<Void> {
        fatalError("not implemented")
    }
    
    public func getProfileInfo() -> Observable<ProfileInfo> {
        return remoteSource.getProfileInfo()
    }
    
    public func setProfileInfo(with info: ProfileInfo) -> Observable<Void> {
        let request = SetProfileInfoRequest.with {
            $0.name = info.name
            $0.surname = info.surname
            $0.imageURL = info.imageUrl
            $0.address.town = info.address.town
            $0.address.region = info.address.region
            $0.address.latitude = info.address.latitude
            $0.address.longitude = info.address.longitude
        }
        return remoteSource.setProfileInfo(request: request)
    }
    
    public func getSettings() -> Observable<GetSettingsResponse> {
        fatalError("not implemented")
    }
    
    public func setSettings() -> Observable<Void> {
        fatalError("not implemented")
    }
    
    public func getChannelTypes() -> Observable<GetChannelTypesResponse> {
        fatalError("not implemented")
    }
    
    public func getLinks() -> Observable<Links> {
        fatalError("not implemented")
    }
    
    public func deleteProfile() -> Observable<Void> {
        return remoteSource.deleteProfile()
    }
    
    
}
