//
//  ProfileRepository.swift
//  SpecialistPlatform
//
//  Created by alexander on 18.04.2023.
//

import Foundation
import RxSwift
import SpecialistDomain
import ZveronSupport

public class ProfileRepository: ProfileRepositoryProtocol {
    private let source: ProfileDataSourceProtocol
    private let cacheAnimal = Cache<Int, AnimalProfile>(entryLifetime: .minutes(value: 30))
    private let cacheCustomer = Cache<Int, CustomerProfile>(entryLifetime: .minutes(value: 10))

    public init(with source: ProfileDataSourceProtocol) { self.source = source }

    public func getAnimalProfile(by id: Int) -> Observable<AnimalProfile> {
        return cacheAnimal[id].flatMap { Observable.just($0) } ??
        source.getAnimalProfile(by: id).do(onNext: { self.cacheAnimal[id] = $0 })
    }

    public func getCustomerProfile(by id: Int) -> Observable<CustomerProfile> {
        return cacheCustomer[id].flatMap { Observable.just($0) } ??
        source.getCustomerProfile(by: id).do(onNext: { self.cacheCustomer[id] = $0 })
    }
}
