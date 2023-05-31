//
//  ProfileDataSourceProtocol.swift
//  Domain
//
//  Created by alexander on 10.02.2023.
//

import Foundation
import RxSwift
//TODO: потом убрать ProfileGRPC после замены на entity
import ProfileGRPC

public protocol ProfileDataSourceProtocol {

    // Получение профиля, как страницы в маркетплейсе (агрегируем данные из разных источников)
    func getProfilePage(request: GetProfilePageRequest) -> Observable<Void>

    // Получение профиля, как страницы в маркетплейсе, для его владельца
    func getProfileInfo() -> Observable<ProfileInfo>

    // Редактирование профиля, как страницы в маркетплейсе, владельцем
    func setProfileInfo(request: SetProfileInfoRequest) -> Observable<Void>

    // Получение настроек профиля
    func getSettings() -> Observable<GetSettingsResponse>

    // Изменение настроект профиля
    func setSettings(request: SetSettingsRequest) -> Observable<Void>

    // Получение предпочительных способов связи (для создания объявлений)
    func getChannelTypes() -> Observable<GetChannelTypesResponse>

    // Получение способов связи, привязанных к профилю. Доступно для владельца профиля
    func getLinks() -> Observable<Links>

    // Полное удаление профиля без возможности восстановления
    func deleteProfile() -> Observable<Void>

    // полный перечень животных
    func getAnimalsByProfile() -> Observable<[Animal]>
}
