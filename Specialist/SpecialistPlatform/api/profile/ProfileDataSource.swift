//
//  ProfileDataSource.swift
//  SpecialistPlatform
//
//  Created by alexander on 18.04.2023.
//

import Foundation
import RxSwift
import SpecialistDomain
import ZveronNetwork
import ProfileGRPC
import OrderGRPC

public final class ProfileDataSource: ProfileDataSourceProtocol {
    private let api: Apigateway

    public init(with api: Apigateway) { self.api = api }

    public func getAnimalProfile(by id: Int) -> Observable<AnimalProfile> {
        let request: GetAnimalRequestExt = .with { $0.animalID = Int64(id) }

        return api
            .callWithRetry(returnType: GetAnimalResponseExt.self, requestBody: request, methodAlies: "profileGetAnimal")
            .parse()
    }

    public func getCustomerProfile(by id: Int) -> Observable<CustomerProfile> {
        let request: GetCustomerRequest = .with { $0.profileID = Int64(id) }

        return api
            .callWithRetry(returnType: GetCustomerResponse.self, requestBody: request, methodAlies: "")
            .parse()
    }
}

// MARK: MOCK
public final class ProfileDataSourceMock: ProfileDataSourceProtocol {
    public func getAnimalProfile(by id: Int) -> RxSwift.Observable<SpecialistDomain.AnimalProfile> {
        return Observable.create { observer in
            print("Started request: profileGetAnimal")

            observer.onNext(animalProfileCollection.first(where: { $0.id == id })!)
            print("Successful response: profileGetAnimal")

            return Disposables.create()
        }
    }

    public func getCustomerProfile(by id: Int) -> RxSwift.Observable<SpecialistDomain.CustomerProfile> {
        return Observable.create { observer in
            print("Started request: profileGetCustomer")

            observer.onNext(customerProfileCollection.first(where: { $0.id == id })!)
            print("Successful response: profileGetCustomer")

            return Disposables.create()
        }
    }

    public init () { }
}
