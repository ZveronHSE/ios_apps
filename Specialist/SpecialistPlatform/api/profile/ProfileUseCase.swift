//
//  ProfileUseCase.swift
//  SpecialistPlatform
//
//  Created by alexander on 18.04.2023.
//

import Foundation
import RxSwift
import SpecialistDomain

public final class ProfileUseCase: ProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    public init(with repository: ProfileRepositoryProtocol) { self.repository = repository }

    public func getAnimalProfile(by id: Int) -> Observable<AnimalProfile> {
        return repository.getAnimalProfile(by: id).mapErrors(default: ProfileError.getAnimalError)
    }

    public func getCustomerProfile(by id: Int) -> Observable<CustomerProfile> {
        return repository.getCustomerProfile(by: id).mapErrors(default: ProfileError.getProfileError)
    }
}
