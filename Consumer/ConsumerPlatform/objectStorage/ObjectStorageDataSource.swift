//
//  ObjectStorageDataSource.swift
//  Platform
//
//  Created by alexander on 29.03.2023.
//

import Foundation
import ConsumerDomain
import ZveronNetwork
import RxSwift
import ObjectstorageGRPC


public class ObjectStorageDataSource: ObjectStorageDataSourceProtocol {
    let api: Apigateway

    public init(api: Apigateway) {
        self.api = api
    }
    
    public func uploadImage(image: Data, type: ObjectstorageGRPC.MimeType) -> RxSwift.Observable<String> {
        let request = UploadImageRequest.with {
            $0.body = image
            $0.mimeType = type
            $0.flowSource = .lot
        }

        return api.callWithRetry(returnType: UploadImageResponse.self, requestBody: request, methodAlies: "objectStorageUploadImage").map { $0.imageURL }
    }

    public func uploadImageProfile(image: Data, type: ObjectstorageGRPC.MimeType) -> RxSwift.Observable<String> {
        let request = UploadImageRequest.with {
            $0.body = image
            $0.mimeType = type
            $0.flowSource = .profile
        }

        return api.callWithRetry(returnType: UploadImageResponse.self, requestBody: request, methodAlies: "objectStorageUploadImage").map { $0.imageURL }
    }
}
