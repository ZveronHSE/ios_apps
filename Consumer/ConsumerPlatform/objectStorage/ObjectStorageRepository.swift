//
//  ObjectStorageRepository.swift
//  Platform
//
//  Created by alexander on 29.03.2023.
//

import Foundation
import ConsumerDomain
import RxSwift
import ObjectstorageGRPC

public class ObjectStorageRepository: ObjectStorageRepositoryProtocol {
    public func uploadImage(image: Data, type: ObjectstorageGRPC.MimeType) -> RxSwift.Observable<String> {
        return data.uploadImage(image: image, type: type)
    }

    let data: ObjectStorageDataSourceProtocol

    public init(data: ObjectStorageDataSourceProtocol) {
        self.data = data
    }
}
