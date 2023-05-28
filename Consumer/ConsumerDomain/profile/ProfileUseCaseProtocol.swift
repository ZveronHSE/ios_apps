//
//  ProfileUseCaseProtocol.swift
//  Domain
//
//  Created by Nikita on 24.03.2023.
//

import Foundation
import RxSwift
//TODO: потом убрать ProfileGRPC после замены на entity
import ProfileGRPC
import ObjectstorageGRPC

// MARK: Класс взаимодействий на экране профиля
public protocol ProfileUseCaseProtocol {
    
    // Получение профиля, как страницы в маркетплейсе (агрегируем данные из разных источников)
    func getProfilePage() -> Observable<Void>
    
    // Получение профиля, как страницы в маркетплейсе, для его владельца
    func getProfileInfo() -> Observable<ProfileInfo>
    
    // Редактирование профиля, как страницы в маркетплейсе, владельцем
    func setProfileInfo(with info: ProfileInfo) -> Observable<Void>
    
    // Получение настроек профиля
    func getSettings() -> Observable<GetSettingsResponse>
    
    // Изменение настроект профиля
    func setSettings() -> Observable<Void>
    
    // Получение предпочительных способов связи (для создания объявлений)
    func getChannelTypes() -> Observable<GetChannelTypesResponse>
    
    // Получение способов связи, привязанных к профилю. Доступно для владельца профиля
    func getLinks() -> Observable<Links>
    
    // Полное удаление профиля без возможности восстановления
    func deleteProfile() -> Observable<Void>

    // полный перечень животных
    func getAnimalsByProfile() -> Observable<[Animal]>
    
    func uploadImageProfile(image: Data, type: ObjectstorageGRPC.MimeType) -> Observable<String>
}
