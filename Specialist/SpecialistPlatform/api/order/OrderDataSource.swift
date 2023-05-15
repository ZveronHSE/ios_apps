//
//  OrderDataSource.swift
//  SpecialistPlatform
//
//  Created by alexander on 17.04.2023.
//

import Foundation
import SpecialistDomain
import RxSwift
import ZveronNetwork
import OrderGRPC

public final class OrderDataSource: OrderDataSourceProtocol {
    private let api: Apigateway

    public init(with api: Apigateway) { self.api = api }

    public func getWaterfall(
        size: Int,
        lastOrderId: Int?,
        filters: [OrderFilter],
        sort: OrderSortingType
    ) -> Observable<[OrderPreview]> {
        let request: GetWaterfallRequest = .with { requestBody in
            requestBody.pageSize = Int32(size)
            lastOrderId.flatMap { requestBody.lastOrderID = Int64($0) }
            requestBody.filters = filters.map { _ in Filter() }
            requestBody.sort = Sort.with {
                $0.sortBy = SortBy(rawValue: sort.rawValue)!
                $0.sortDir = SortDir(rawValue: OrderSortingTypeDir.desc.rawValue)!
            }
        }

        return api
            .callWithRetry(returnType: GetWaterfallResponse.self, requestBody: request, methodAlies: "orderGetWaterfall")
            .parse()
    }

    public func getOrder(by id: Int) -> Observable<Order> {
        let request: GetOrderRequest = .with { $0.id = Int64(id) }

        return api
            .callWithRetry(returnType: GetOrderResponse.self, requestBody: request, methodAlies: "orderGetOrder")
            .parse()
    }
}

// MARK: MOCK
public final class OrderDataSourceMock: OrderDataSourceProtocol {

    public init () {}

    public func getWaterfall(size: Int, lastOrderId: Int?, filters: [SpecialistDomain.OrderFilter], sort: SpecialistDomain.OrderSortingType) -> RxSwift.Observable<[SpecialistDomain.OrderPreview]> {
        return Observable.create { observer in
            print("Started request: orderGetWaterfall")

            if lastOrderId == nil {
                let ordersToEmits = Array(orderPreviewCollection[0..<size])
                observer.onNext(ordersToEmits)
            } else {

                let idx = orderPreviewCollection.firstIndex(where: {$0.id == lastOrderId })!.advanced(by: 1)
                let endIdx = idx.advanced(by: size - 1)

                let ordersToEmits: [OrderPreview]

                if endIdx > orderPreviewCollection.count {
                    if lastOrderId == 45 {
                        ordersToEmits = []
                    } else {
                        ordersToEmits = Array(orderPreviewCollection[idx..<orderPreviewCollection.count])
                    }
                } else {

                    ordersToEmits = Array(orderPreviewCollection[idx...endIdx])
                }
                observer.onNext(ordersToEmits)
            }


            print("Successful response: orderGetWaterfall")


            return Disposables.create()
        }
    }

    public func getOrder(by id: Int) -> RxSwift.Observable<SpecialistDomain.Order> {
        return Observable.create { observer in
            print("Started request: orderGetOrder")

            observer.onNext(fullOrderCollection.first(where: { $0.id == id })!)
            print("Successful response: orderGetOrder")

            return Disposables.create()
        }
    }
}


let orderPreviewCollection: [OrderPreview] = [
        .init(
        id: 1,
        animal: animalPreviewCollection.first(where: { $0.id == 1 })!,
        title: "Стрижка кошки",
        price: "500 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 15:36"
    ),
        .init(
        id: 2,
        animal: animalPreviewCollection.first(where: { $0.id == 2 })!,
        title: "Выгул собаки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),

        .init(
        id: 3,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),

        .init(
        id: 4,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),

            .init(
            id: 5,
            animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
            title: "Обработка кожи кошки",
            price: "250 Р",
            address: .init(
                town: "Москва",
                station: "Пражская",
                color: "#BEBEBE"
            ),
            serviceDate: "15.12.2023",
            createdDate: "Вчера 12:55"
        ),
        .init(
        id: 6,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 7,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 8,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 9,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 10,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 11,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 12,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 13,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 14,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 15,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 16,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 17,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 18,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 19,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 20,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 21,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 22,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 23,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 24,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 25,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 26,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 27,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 28,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 29,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 30,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 31,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 32,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 33,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 34,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 35,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 36,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 37,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 38,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),
        .init(
        id: 39,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ), .init(
        id: 40,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),.init(
        id: 41,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),.init(
        id: 42,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),.init(
        id: 43,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),.init(
        id: 44,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),.init(
        id: 45,
        animal: animalPreviewCollection.first(where: { $0.id == 3 })!,
        title: "Обработка кожи кошки",
        price: "250 Р",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        createdDate: "Вчера 12:55"
    ),

]

let fullOrderCollection: [Order] = [
        .init(
        id: 1,
        customerPreview: customerPreviewCollection.first(where: { $0.id == 1 })!,
        animalPreview: animalPreviewCollection.first(where: { $0.id == 1 })!,
        title: "Стрижка кошки",
        price: "500 Р",
        createdDate: "Вчера 15:36",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        serviceTime: "12:00 - 13:00",
        description: "Моей милой кошечке надо постричься!",
        similarOrders: [
            orderPreviewCollection.first(where: {$0.id == 3})!,
            orderPreviewCollection.first(where: {$0.id == 4})!
        ],
        availableResponse: false
    ),
        .init(
        id: 2,
        customerPreview: customerPreviewCollection.first(where: { $0.id == 1 })!,
        animalPreview: animalPreviewCollection.first(where: { $0.id == 2 })!,
        title: "Выгул собаки",
        price: "250 Р",
        createdDate: "Вчера 12:55",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        serviceTime: "12:00 - 13:00",
        description: "Гулять не с кем(",
        similarOrders:  [
            orderPreviewCollection.first(where: {$0.id == 3})!,
            orderPreviewCollection.first(where: {$0.id == 4})!
        ],
        availableResponse: false
    ),

            .init(
            id: 3,
            customerPreview: customerPreviewCollection.first(where: { $0.id == 1 })!,
            animalPreview: animalPreviewCollection.first(where: { $0.id == 2 })!,
            title: "Выгул собаки",
            price: "250 Р",
            createdDate: "Вчера 12:55",
            address: .init(
                town: "Москва",
                station: "Пражская",
                color: "#BEBEBE"
            ),
            serviceDate: "15.12.2023",
            serviceTime: "12:00 - 13:00",
            description: "Гулять не с кем(",
            similarOrders:  [
                orderPreviewCollection.first(where: {$0.id == 3})!,
                orderPreviewCollection.first(where: {$0.id == 4})!
            ],
            availableResponse: false
        ),
        .init(
        id: 4,
        customerPreview: customerPreviewCollection.first(where: { $0.id == 1 })!,
        animalPreview: animalPreviewCollection.first(where: { $0.id == 2 })!,
        title: "Выгул собаки",
        price: "250 Р",
        createdDate: "Вчера 12:55",
        address: .init(
            town: "Москва",
            station: "Пражская",
            color: "#BEBEBE"
        ),
        serviceDate: "15.12.2023",
        serviceTime: "12:00 - 13:00",
        description: "Гулять не с кем(",
        similarOrders:  [
            orderPreviewCollection.first(where: {$0.id == 3})!,
            orderPreviewCollection.first(where: {$0.id == 4})!
        ],
        availableResponse: false
    )
]

let animalPreviewCollection: [OrderAnimalPreview] = [
        .init(
        id: 1,
        name: "Алиса",
        breed: "Кошка",
        species: "Шотландская-вислоухая",
        imageUrl: URL(string: "https://koshka.top/uploads/posts/2021-12/thumbs/1638915447_1-koshka-top-p-visloukhaya-shotlandka-1.jpg")!
    ),
        .init(
        id: 2,
        name: "Платон",
        breed: "Собака",
        species: "Чихуа-хуа",
        imageUrl: URL(string: "https://lapkins.ru/upload/iblock/49c/49cd241c27d90c0ce9bd82c950cd4a76.jpg")!
    ),


        .init(
        id: 3,
        name: "Афина",
        breed: "Котенок",
        species: "Сфинкс",
        imageUrl: URL(string: "https://cdn.lifehacker.ru/wp-content/uploads/2019/12/Depositphotos_3356904_l-2015_1576231437-e1576231612655-1600x800.jpg")!
    )
]

let animalProfileCollection: [AnimalProfile] = [
        .init(
        id: 1,
        name: "Алиса",
        breed: "Кошка",
        species: "Шотландская-вислоухая",
        age: "13 лет",
        imageUrls: [
            URL(string: "https://koshka.top/uploads/posts/2021-12/thumbs/1638915447_1-koshka-top-p-visloukhaya-shotlandka-1.jpg")!,
            URL(string: "https://resizer.mail.ru/p/01aa4d92-092e-5cb3-bfa3-7e82d7f8842b/AQAO5qEfU1nUGVFoU50hCaNp496Q1pm6moEeouwF0_4DEAPJ0hi5RdDWRF4499zW4EwDPWlCQe7du6tXI1Lb0fYqIPk.jpg")!,
            URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Adult_Scottish_Fold.jpg/548px-Adult_Scottish_Fold.jpg")!
        ],
        documents: [
                .init(
                name: "Привика1.pdf",
                url: URL(string: "https://storage.yandexcloud.net/zveron-document/SSRN-id908444.pdf")!
            ),
                .init(
                name: "Привика2.pdf",
                url: URL(string: "https://storage.yandexcloud.net/zveron-document/SSRN-id908444.pdf")!
            ),
                .init(
                name: "Привика3.pdf",
                url: URL(string: "https://storage.yandexcloud.net/zveron-document/SSRN-id908444.pdf")!
            ),
                .init(
                name: "Привика4.pdf",
                url: URL(string: "https://storage.yandexcloud.net/zveron-document/SSRN-id908444.pdf")!
            )
        ]
    ),
        .init(
        id: 2,
        name: "Платон",
        breed: "Собака",
        species: "Чихуа-хуа",
        age: "2 года",
        imageUrls: [
            URL(string: "https://lapkins.ru/upload/iblock/49c/49cd241c27d90c0ce9bd82c950cd4a76.jpg")!
        ],
        documents: []
    )
]

let customerPreviewCollection: [OrderCustomerPreview] = [
        .init(
        id: 1,
        name: "Илон",
        imageUrl: URL(string: "https://www.ixbt.com/img/x780/n1/news/2023/0/2/1200_large.jpg")!,
        rating: 4.7
    )
]

let customerProfileCollection: [CustomerProfile] = [
        .init(
        id: 1,
        fullname: "Илон Маск",
        imageUrl: URL(string: "https://www.ixbt.com/img/x780/n1/news/2023/0/2/1200_large.jpg")!,
        rating: 4.7,
        activeOrders: [
            orderPreviewCollection.first(where: { $0.id == 1 })!,
            orderPreviewCollection.first(where: { $0.id == 2 })!
        ],
        closedOrders: []
    )
]
