//
//  ProfileUseCase.swift
//  Platform
//
//  Created by Nikita on 24.03.2023.
//

import Foundation
import RxSwift
import ConsumerDomain
//TODO: потом убрать ProfileGRPC после замены на entity
import ProfileGRPC

public final class ProfileUseCase: ProfileUseCaseProtocol {
    
    private let profileRepository: ProfileRepositoryProtocol

    public init(with profileRepository: ProfileRepositoryProtocol) {
        self.profileRepository = profileRepository
    }
    
    public func getProfilePage() -> Observable<Void> {
        fatalError("not implemented")
    }
    
    public func getProfileInfo() -> Observable<ProfileInfo> {
        return profileRepository.getProfileInfo()
            .mapErrors(default: ProfileError.failedLoadInfo)
    }
    
    public func setProfileInfo(with info: ProfileInfo) -> Observable<Void> {
        return profileRepository.setProfileInfo(with: info)
            .mapErrors(default: ProfileError.failedEditProfile)
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
        return profileRepository.deleteProfile()
            .mapErrors(default: ProfileError.failedDeleteProfile)
    }
    
 
}
