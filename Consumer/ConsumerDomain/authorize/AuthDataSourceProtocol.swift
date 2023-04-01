//
//  AuthDataSourceProtocol.swift
//  Domain
//
//  Created by alexander on 27.01.2023.
//

import Foundation
import RxSwift
import AuthGRPC

public protocol AuthDataSourceProtocol {

    // логин через соц сеть
    func loginBySocial(request: LoginBySocialRequest) -> Observable<MobileToken>

    // логин по паролю и телефону
    func loginByPassword(request: LoginByPasswordRequest) -> Observable<MobileToken>

    // попытка логина только по телефону, начальный этап, высылаем запрос в сторонний сервис
    // на отправку смс/звонка для верификации
    func loginPhoneInit(request: PhoneLoginInitRequest) -> Observable<PhoneLoginInitResponse>

    // попытка логина только по телефону, второй этап, пробуем провалидировать пришедший код
    // если пользователь уже есть, возвращаем токены и флаг, что флоу логина
    func loginPhoneVerify(request: PhoneLoginVerifyRequest) -> Observable<PhoneLoginVerifyResponse>

    // последний шаг логина по телефону, если пользователя еще не существует и создаем новый аккаунт
    func registerByPhone(request: PhoneRegisterRequest) -> Observable<MobileToken>
}
