//
//  ChatError.swift
//  ConsumerDomain
//
//  Created by Nikita on 25.05.2023.
//

import Foundation

public enum ChatError: Error {
    case failedStreaming
}

extension ChatError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedStreaming: return NSLocalizedString("Ошибка в результате общения с сервером", comment: "")
        default: return NSLocalizedString("", comment: "")
        }
    }
}
