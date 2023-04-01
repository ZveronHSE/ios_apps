//
//  Apigateway.swift
//
//
//  Created by alexander on 24.01.2023.
//

import Foundation
import NIOCore
import NIOPosix
import GRPC
import ApigatewayGRPC
import AuthGRPC
import NIOHPACK
import RxSwift
import SwiftProtobuf
import UIKit

public class Apigateway {
    public init() { }

    private let disposeBag = DisposeBag()
    private let backgroundQueue = DispatchQueue(label: "ru.zveron.api_queue", qos: .utility, attributes: .concurrent)

    private struct ConnectionConfig {
        fileprivate static let host = "zveron.ru"
        fileprivate static let port = 80
        fileprivate static let transportSecurity = GRPCChannelPool.Configuration.TransportSecurity.plaintext
        fileprivate static let timeoutSeconds: Int64 = 3
    }

    typealias Connection = (group: MultiThreadedEventLoopGroup, channel: GRPCChannel)

    // MARK: BASIC CALL TO APIGATEWAY
    private func call<T: Message, U: Message>(
        returnType: U.Type,
        requestBody: T,
        methodAlies: String,
        _ completion: @escaping (Result<U, NetworkError>) -> Void
    ) {

        backgroundQueue.async {

            do {
                print("Started request:\(methodAlies) with body:\n\(requestBody.debugDescription)")

                // try to open connection
                let (connection, client) = try self.openConnection()

                // try to create request to apigateway
                let request = try ApiGatewayRequest.with {
                    $0.requestBody = try requestBody.jsonUTF8Data()
                    $0.methodAlias = methodAlies
                }

                var headers: [(String, String)] = []

                // dont add access_token for renew tokens method
                if methodAlies != "authIssueNewTokens" {
                    TokenAcquisitionService.shared.getToken().flatMap {
                        headers.append(("access_token", $0.accessToken.token))
                    }
                }

                let options = CallOptions.init(
                    customMetadata: HPACKHeaders(headers),
                    timeLimit: .timeout(.seconds(ConnectionConfig.timeoutSeconds))
                )

                // call to apigateway and await response with metadata
                // makeCallApiGatewayCall(request, callOptions: options)
                let call = client.callApiGateway(request, callOptions: options)
                let response = try call.response.wait().responseBody

                // try to deserialization response
                let responseBody = try U.init(jsonUTF8Data: response)

                // try to close connection
                try self.closeConnection(connection)

                print("Complete response:\(methodAlies) with body:\n\(responseBody.debugDescription)")
                
                // call callback with response
                DispatchQueue.main.async { completion(.success(responseBody)) }
            } catch {
                DispatchQueue.main.async {
                    print("Failed response:\(methodAlies) with error:\(error.localizedDescription)")
                    let networkError = error.toNetworkError()
                    completion(.failure(networkError))
                }
            }
        }
    }

// MARK: REACTIVE CALL TO APIGATEWAY
    private func call<T: Message, U: Message>(
        returnType: U.Type,
        requestBody: T,
        methodAlies: String
    ) -> Observable<U> {
        return Observable.create { observer in
            self.call(returnType: returnType, requestBody: requestBody, methodAlies: methodAlies) {
                switch $0 {
                case .success(let response):
                    observer.onNext(response)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

/// Основной реактивный метод по вызову соответствующего ресурса у backend
///
/// - Parameters:
///     - returnType: Тип возвращаемого респонза от бекенда
///     - requestBody: Реквест соответствующий определенной ручке бекенда
///     - methodAlies: Строка идентификатор соответствующей ручки
///
///     - Returns: Наблюдаемый с типов значения returnType
    public func callWithRetry<T: Message, U: Message>(
        returnType: U.Type,
        requestBody: T,
        methodAlies: String
    ) -> Observable<U> {
        return call(returnType: returnType, requestBody: requestBody, methodAlies: methodAlies)
            .retry { errorObservable -> Observable<Void> in
            errorObservable.flatMap { error in
                guard let error = error as? NetworkError else { fatalError("this flow must only handle a Network error") }

                switch error {
                case .unauthenticated: return self.renewToken()
                default: return Observable.error(error)
                }
            }
        }
    }

/// Основной реактивный метод по вызову соответствующего ресурса у backend
/// Вызывается в случае пустого тела ответа
/// - Parameters:
///     - requestBody: Реквест соответствующий определенной ручке бекенда
///     - methodAlies: Строка идентификатор соответствующей ручки
///
///     - Returns: Наблюдаемый с пустым типом значения
    public func callWithRetry<T: Message>(
        requestBody: T,
        methodAlies: String
    ) -> Observable<Void> {
        return self.callWithRetry(
            returnType: Google_Protobuf_Empty.self,
            requestBody: requestBody,
            methodAlies: methodAlies
        ).map { _ in Void() }
    }

/// Основной реактивный метод по вызову соответствующего ресурса у backend
/// Вызывается в случае пустого тела запроса
///
/// - Parameters:
///     - returnType: Тип возвращаемого респонза от бекенда
///     - methodAlies: Строка идентификатор соответствующей ручки
///
///     - Returns: Наблюдаемый с типов значения returnType
    public func callWithRetry<U: Message>(
        returnType: U.Type,
        methodAlies: String
    ) -> Observable<U> {
        return self.callWithRetry(
            returnType: returnType,
            requestBody: Google_Protobuf_Empty(),
            methodAlies: methodAlies
        )
    }
    
    /// Основной реактивный метод по вызову соответствующего ресурса у backend
    /// Вызывается в случае пустого тела запроса и пустого ответа
    ///
    /// - Parameter methodAlies: Строка идентификатор соответствующей ручки
    /// - Returns: Наблюдаемый с пустым типом значения
    public func callWithRetry(
        methodAlies: String
    ) -> Observable<Void> {
        return self.callWithRetry(
            returnType: Google_Protobuf_Empty.self,
            requestBody: Google_Protobuf_Empty(),
            methodAlies: methodAlies
        ).map { _ in Void() }
    }

/// renewToken if response to endpoint return a .unauthenticated(16) state
    private func renewToken() -> Observable<Void> {
        // check for main thread that the process of updating was started early
        if TokenAcquisitionService.shared.isUpdating { return Observable.just(Void()) }

        // set updating state
        TokenAcquisitionService.shared.isUpdating = true

        // Lock the resource on main thread
        TokenAcquisitionService.shared.lock()

        let request = IssueNewTokensRequest.with {
            $0.refreshToken = TokenAcquisitionService.shared.getToken()?.refreshToken.token ?? "empty-token"
            $0.deviceFp = UIDevice.current.identifierForVendor!.uuidString
        }

        return self.call(returnType: MobileToken.self, requestBody: request, methodAlies: "authIssueNewTokens")
            .do(
            onNext: {
                TokenAcquisitionService.shared.isUpdating = false
                TokenAcquisitionService.shared.setToken(token: $0)
                TokenAcquisitionService.shared.unlock()
            },
            onError: { _ in
                TokenAcquisitionService.shared.isUpdating = false
                TokenAcquisitionService.shared.unlock()
            }
        ).map { _ in Void() }
    }

    private func openConnection() throws -> (Connection, ApigatewayServiceNIOClient) {
        do {
            let group = MultiThreadedEventLoopGroup(numberOfThreads: 3)
            let channel = try GRPCChannelPool.with(
                target: .hostAndPort(ConnectionConfig.host, ConnectionConfig.port),
                transportSecurity: ConnectionConfig.transportSecurity,
                eventLoopGroup: group
            )
            return ((group, channel), ApigatewayServiceNIOClient(channel: channel))
        } catch {
            throw NetworkError.connectionOpenFailed(cause: error)
        }
    }

    private func closeConnection(_ connection: Connection) throws {
        do {
            try connection.channel.close().wait()
            try connection.group.syncShutdownGracefully()
        } catch {
            throw NetworkError.connectionCloseFailed(cause: error)
        }
    }
}

private extension Error {
    func toNetworkError() -> NetworkError {
        // internal errors
        if let error = self as? NetworkError { return error }

        // server errors
        if let error = (self as? GRPCStatusTransformable)?.makeGRPCStatus() {
            print(error.message)
            switch error.code {
            case .cancelled: return NetworkError.cancelled
            case .unknown: return NetworkError.unknown
            case .invalidArgument: return NetworkError.invalidArgument
            case .deadlineExceeded: return NetworkError.timeout
            case .notFound: return NetworkError.notFound
            case .alreadyExists: return NetworkError.alreadyExists
            case .permissionDenied: return NetworkError.permissionDenied
            case .resourceExhausted: return NetworkError.resourceExhausted
            case .failedPrecondition: return NetworkError.failedPrecondition
            case .aborted: return NetworkError.aborted
            case .outOfRange: return NetworkError.outOfRange
            case .unimplemented: return NetworkError.unimplemented
            case .internalError: return NetworkError.internalError
            case .unavailable: return NetworkError.unavailable
            case .dataLoss: return NetworkError.dataLoss
            case .unauthenticated: return NetworkError.unauthenticated
            default: break
            }
        }

        // unexpected errors
        return NetworkError.unexpectedError(cause: self)
    }
}
