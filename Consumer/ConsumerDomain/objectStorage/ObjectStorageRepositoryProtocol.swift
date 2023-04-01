//
//  ObjectStorageRepositoryProtocol.swift
//  Domain
//
//  Created by alexander on 29.03.2023.
//

import Foundation
import RxSwift
import ObjectstorageGRPC

public protocol ObjectStorageRepositoryProtocol {
    func uploadImage(image: Data, type: MimeType) -> Observable<String>
}
