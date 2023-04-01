//
//  AuthUseCaseProtocol.swift
//  Domain
//
//  Created by alexander on 27.01.2023.
//

import Foundation
import RxSwift
import AuthGRPC

public protocol AuthUseCaseProtocol {

    // логин через соц сеть
    func loginBySocial(socialToken: String, provider: AuthProvider) -> Observable<Void>

    // логин по паролю и телефону
    func loginByPassword(phoneNumber: String, password: String) -> Observable<Void>

    // попытка логина только по телефону, начальный этап, высылаем запрос в сторонний сервис
    // на отправку смс/звонка для верификации
    func loginPhoneInit(phoneNumber: String) -> Observable<Void>

    // попытка логина только по телефону, второй этап, пробуем провалидировать пришедший код
    // если пользователь уже есть, возвращаем токены и флаг, что флоу логина
    func loginPhoneVerify(code: String) -> Observable<Bool>

    // последний шаг логина по телефону, если пользователя еще не существует и создаем новый аккаунт
    func registerByPhone(name: String, surname: String, password: String) -> Observable<Void>
}
