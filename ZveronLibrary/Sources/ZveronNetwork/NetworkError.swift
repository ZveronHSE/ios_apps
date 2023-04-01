//
//  File.swift
//
//
//  Created by alexander on 25.01.2023.
//

import Foundation
import GRPC

public enum NetworkError: Error {
    // network errors
    case cancelled
    case unknown
    case invalidArgument
    case timeout
    case notFound
    case alreadyExists
    case permissionDenied
    case resourceExhausted
    case failedPrecondition
    case aborted
    case outOfRange
    case unimplemented
    case internalError
    case unavailable
    case dataLoss
    case unauthenticated

    // logic errors
    case connectionOpenFailed(cause: Error)
    case connectionCloseFailed(cause: Error)
    case requestSerializationFailed(cause: Error)
    case responseDeserializationFailed(cause: Error)

    // other errors
    case unexpectedError(cause: Error)

    func code() -> Int {
        switch self {
        case .cancelled: return 0
        case .unknown: return 1
        case .invalidArgument: return 2
        case .timeout: return 3
        case .notFound: return 4
        case .alreadyExists: return 5
        case .permissionDenied: return 6
        case .resourceExhausted: return 7
        case .failedPrecondition: return 8
        case .aborted: return 9
        case .outOfRange: return 10
        case .unimplemented: return 11
        case .internalError: return 12
        case .unavailable: return 13
        case .dataLoss: return 14
        case .unauthenticated: return 15
        case .connectionOpenFailed: return 16
        case .connectionCloseFailed: return 17
        case .requestSerializationFailed: return 18
        case .responseDeserializationFailed: return 19
        case .unexpectedError: return 20
        }
    }
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.code() == rhs.code()
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .connectionOpenFailed(let cause):
            return NSLocalizedString("During openning connection, error has occurred: \(cause)", comment: "")
        case .connectionCloseFailed(let cause):
            return NSLocalizedString("During closing connection, error has occurred: \(cause)", comment: "")
        case .unauthenticated:
            return NSLocalizedString("Current user does not authenticated for server resource", comment: "")
        case .timeout:
            return NSLocalizedString("Connection was closed due to timeout", comment: "")
        case .requestSerializationFailed(let cause):
            return NSLocalizedString("serialization error has occurred: \(cause)", comment: "")
        case .responseDeserializationFailed(let cause):
            return NSLocalizedString("deserialization error has occurred: \(cause)", comment: "")
        case .unexpectedError(let cause):
            return NSLocalizedString("unexpected error has occurred: \(cause)", comment: "")
        default: return NSLocalizedString("", comment: "")
        }
    }
}
