//
//  ObjectStorageDataSourceProtocol.swift
//  Domain
//
//  Created by alexander on 29.03.2023.
//

import Foundation
import ObjectstorageGRPC
import RxSwift

public protocol ObjectStorageDataSourceProtocol {
    func uploadImage(image: Data, type: MimeType) -> Observable<String>
}
