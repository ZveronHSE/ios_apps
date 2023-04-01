//
//  AuthDataSource.swift
//  Platform
//
//  Created by alexander on 27.01.2023.
//

import Foundation
import RxSwift
import AuthGRPC
import ConsumerDomain
import ZveronNetwork
import GRPC

public final class AuthRemoteDataSource: AuthDataSourceProtocol {
    private let apigateway: Apigateway

    public init(apigateway: ZveronNetwork.Apigateway) {
        self.apigateway = apigateway
    }

    public func loginBySocial(request: LoginBySocialRequest) -> Observable<MobileToken> {
        return apigateway.callWithRetry(returnType: MobileToken.self, requestBody: request, methodAlies: "authLoginBySocialMedia")
    }

    public func loginByPassword(request: LoginByPasswordRequest) ->Observable<MobileToken> {
        return apigateway.callWithRetry(returnType: MobileToken.self, requestBody: request, methodAlies: "authLoginByPassword")
    }

    public func loginPhoneInit(request: PhoneLoginInitRequest) -> Observable<PhoneLoginInitResponse> {
        return apigateway.callWithRetry(
            returnType: PhoneLoginInitResponse.self,
            requestBody: request,
            methodAlies: "authPhoneLoginInit"
        ).mapErrors()
    }

    public func loginPhoneVerify(request: PhoneLoginVerifyRequest) -> Observable<PhoneLoginVerifyResponse> {
        return apigateway.callWithRetry(
            returnType: PhoneLoginVerifyResponse.self,
            requestBody: request,
            methodAlies: "authPhoneLoginVerify"
        ).mapErrors(
            with: [
                (.invalidArgument, AuthError.notValidCode)
            ]
        )
    }

    public func registerByPhone(request: PhoneRegisterRequest) -> Observable<MobileToken> {
        return apigateway.callWithRetry(
            returnType: MobileToken.self,
            requestBody: request,
            methodAlies: "authRegisterByPhone"
        ).mapErrors()
    }
}
