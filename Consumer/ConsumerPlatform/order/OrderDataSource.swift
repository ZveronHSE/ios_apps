//
//  OrderDataSource.swift
//  ConsumerPlatform
//
//  Created by alexander on 12.05.2023.
//

import Foundation
import RxSwift
import ConsumerDomain
import OrderGRPC
import ZveronNetwork

public class OrderDataSourceMock: OrderDataSourceProtocol {

    private let apigateway: Apigateway

    public init(_ apigateway: Apigateway) {
        self.apigateway = apigateway
    }

    public func getCreatedOrders(type: OrderType) -> RxSwift.Observable<[ConsumerDomain.OrderPreview]> {
        return apigateway.callWithRetry(returnType: GetOrdersByProfileResponse.self, methodAlies: "orderGetByProfile").map { res in
            switch type {
            case .active:
                return res.activeOrders.map {
                    return OrderPreview(
                        id: Int($0.id),
                        title: $0.title,
                        price: $0.price,
                        createdAt: $0.createdAt,
                        imageUrl: URL(string: $0.animal.imageURL)!
                    )
                }
            case .closed:
                return res.completedOrders.map {
                    return OrderPreview(
                        id: Int($0.id),
                        title: $0.title,
                        price: $0.price,
                        createdAt: $0.createdAt,
                        imageUrl: URL(string: $0.animal.imageURL)!
                    )
                }
            }
        }
    }

    public func getCreatedOrder(by id: Int) -> RxSwift.Observable<ConsumerDomain.Order> {
        fatalError("")
    }

    public func createOrder(_ order: ConsumerDomain.Order) -> RxSwift.Observable<Void> {
        let request: OrderGRPC.CreateOrderRequest = .with { req in
            req.paymentType = order.priceType == .service ? .flat : .perHour
            req.animalID = Int64(order.animalId)
            req.title = order.title
            req.price = Int64(order.price)
            req.subwayStationID = Int32(10)

            req.serviceDateFrom = order.dateFrom.convertToGoogleDate()
            req.serviceDateTo = order.dateTo.convertToGoogleDate()
            req.serviceTimeFrom = order.timeFrom.convertToGoogleTime()
            req.serviceTimeTo = order.timeTo.convertToGoogleTime()

            req.description_p = order.desc
            req.deliveryMethod = order.deliveryMethod.convert()
            req.serviceType = order.serviceType.convert()
        }

        return apigateway.callWithRetry(returnType: CreateOrderResponse.self, requestBody: request, methodAlies: "orderCreateOrder").map {_ in Void() }
    }
}


extension Date {
    func convertToGoogleDate() -> Google_Type_Date {
        let calender = Calendar.current
        var dateComponents = calender.dateComponents([.year, .month, .day], from: self)

        return .with {
            $0.year = Int32(dateComponents.year!)
            $0.month = Int32(dateComponents.month!)
            $0.day = Int32(dateComponents.day!)
        }
    }

    func convertToGoogleTime() -> Google_Type_TimeOfDay {
        let calender = Calendar.current
        var dateComponents = calender.dateComponents([.hour, .minute], from: self)

        return .with {
            $0.hours = Int32(dateComponents.hour!)
            $0.minutes = Int32(dateComponents.minute!)
            $0.seconds = 0
            $0.nanos = 0
        }
    }
}

extension DeliveryType {
    func convert() -> OrderGRPC.ServiceDeliveryMethod {
        switch self {
        case .home: return .inPerson
        case .notHome: return .remote
        case .unnecessary: return .remote
        }
    }
}

extension ConsumerDomain.ServiceType {
    func convert() -> OrderGRPC.ServiceType {
        switch self {
        case .walk: return .walk
        case .grooming: return .grooming
        case .training: return .training
        case .boarding: return .boarding
        case .sitting: return .sitting
        case .other: return .other
        }
    }
}
