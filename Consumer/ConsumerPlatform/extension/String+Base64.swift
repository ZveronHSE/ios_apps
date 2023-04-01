//
//  String+Base64.swift
//  iosapp
//
//  Created by alexander on 17.02.2023.
//

import Foundation

internal extension String {
    func toBase64() -> Data {
        return Data(self.utf8).base64EncodedData()
    }
}
