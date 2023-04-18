//
//  ProfileRepositoryProtocol.swift
//  SpecialistDomain
//
//  Created by alexander on 18.04.2023.
//

import Foundation
import RxSwift

public protocol ProfileRepositoryProtocol {

    func getAnimalProfile(by id: Int) -> Observable<AnimalProfile>

    func getCustomerProfile(by id: Int) -> Observable<CustomerProfile>
}
