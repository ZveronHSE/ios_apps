//
//  KeychainHelper.swift
//
//
//  Created by alexander on 04.02.2023.
//

import Foundation
import Security

public final class KeychainHelper {
    public static let shared = KeychainHelper()

    private init() { }

    public func save<T>(_ item: T, service: String, account: String) where T: Codable {

        do {
            // Encode as JSON data and save in keychain
            let data = try JSONEncoder().encode(item)
            save(data, service: service, account: account)

        } catch {
            assertionFailure("Fail to encode item for keychain: \(error)")
        }
    }

    public func save(_ data: Data, service: String, account: String) {

        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary

        // Add data in query to keychain
        let status = SecItemAdd(query, nil)

        if status == errSecDuplicateItem {
            // Item already exist, thus update it.
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            // Update existing item
            SecItemUpdate(query, attributesToUpdate)
            return
        }

        if status != errSecSuccess {
            // Print out the error
            print("Error: \(status)")
        }
    }

    public func read<T>(service: String, account: String, type: T.Type) -> T? where T: Codable {

        // Read item data from keychain
        guard let data = read(service: service, account: account) else {
            return nil
        }

        // Decode JSON data to object
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }

    public func read(service: String, account: String) -> Data? {

        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)

        return (result as? Data)
    }

    public func delete(service: String, account: String) {

        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        SecItemDelete(query)
    }
}
