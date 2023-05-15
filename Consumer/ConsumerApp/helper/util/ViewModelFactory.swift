//
//  ModelViewFactory.swift
//  iosapp
//
//  Created by alexander on 17.04.2022.
//

import Foundation
import RxSwift
import ConsumerPlatform
import ZveronNetwork

struct ViewModelFactory {
    // BASE
    fileprivate static let apigateway = Apigateway()

    // REMOTE_DATA_SOURCES
    fileprivate static let authRemoteDataSource = AuthRemoteDataSource(apigateway: apigateway)
    fileprivate static let lotRemoteDataSource = LotRemoteDataSource(apigateway)
    fileprivate static let favoriteRemoteDataSource = FavoriteRemoteDataSource(apigateway: apigateway)
    fileprivate static let parameterRemoteDataSource = ParameterRemoteDataSource(with: apigateway)
    fileprivate static let profileRemoteDataSource = ProfileRemoteDataSource(apigateway)
    fileprivate static let objectStorageDataSource = ObjectStorageDataSource(api: apigateway)

    fileprivate static let orderDataSource =  OrderDataSourceMock(apigateway)
    // LOCAL_DATA_SOURCES

    
    // REPOSITORIES
    fileprivate static let authRepository = AuthRepository(remote: authRemoteDataSource)
    fileprivate static let lotRepository = LotRepository(remote: lotRemoteDataSource)
    fileprivate static let favoriteRepository = FavoriteRepository(remote: favoriteRemoteDataSource)
    fileprivate static let parameterRepository = ParameterRepository(with: parameterRemoteDataSource)
    fileprivate static let profileRepository = ProfileRepository(remote: profileRemoteDataSource)
    fileprivate static let objectStorageRepository = ObjectStorageRepository(data: objectStorageDataSource)
    fileprivate static let orderRepository = OrderRepository(ds: orderDataSource)

    
    // USE_CASES
    fileprivate static let authUseCase = AuthUseCase(authRepository: authRepository)
    fileprivate static let waterfallUseCase = WaterfallUseCase(with: lotRepository, and: favoriteRepository, and: parameterRepository)
    fileprivate static let favoriteUseCase = FavoriteUseCase(with: favoriteRepository, and: lotRepository)
    fileprivate static let profileUseCase = ProfileUseCase(with: profileRepository)
    fileprivate static let createLotUseCase = CreateLotUseCase(with: lotRepository, with: parameterRepository, and: objectStorageRepository)
    fileprivate static let orderUseCase = OrderUseCase(rep: orderRepository)

    // TODO: DEPRECATED

    public static func get<T: ViewModelType>(_ viewModelType: T.Type) -> T {
        switch viewModelType {
        case is ExternalAuthViewModel.Type: return(ExternalAuthViewModel(authUseCase) as? T)!
        case is PhonePickerViewModel.Type: return (PhonePickerViewModel(authUseCase) as? T)!
        case is CodePickerViewModel.Type: return (CodePickerViewModel(authUseCase) as? T)!
        case is NamePasswordPickerViewModel.Type: return (NamePasswordPickerViewModel(authUseCase) as? T)!
        case is PhonePasswordPickerViewModel.Type: return (PhonePasswordPickerViewModel(authUseCase) as? T)!

        case is FilterViewModel.Type: return (FilterViewModel(with: waterfallUseCase) as? T)!
        case is FirstNestingViewModel.Type: return (FirstNestingViewModel(with: waterfallUseCase) as? T)!
        case is SecondNestingViewModel.Type: return (SecondNestingViewModel(with: waterfallUseCase) as? T)!
        case is ThirdNestingViewModel.Type: return (ThirdNestingViewModel(with: waterfallUseCase) as? T)!

        case is FavoriteViewModel.Type: return (FavoriteViewModel(favoriteUseCase) as? T)!            
            
        case is ProfileViewModel.Type: return (ProfileViewModel(profileUseCase) as? T)!
        case is EditProfileViewModel.Type: return (EditProfileViewModel(profileUseCase) as? T)!
            
          
        case is AdsViewModel.Type: return (AdsViewModel() as? T)!
        case is AddingLotViewModel.Type: return (AddingLotViewModel(createLotUseCase) as? T)!
        case is AddingLotTypeViewModel.Type: return (AddingLotTypeViewModel(createLotUseCase) as? T)!
        case is CategoryTypeNestedViewModel.Type: return (CategoryTypeNestedViewModel(createLotUseCase) as? T)!
        case is ParametersViewModel.Type: return (ParametersViewModel(createLotUseCase) as? T)!

            
        case is AddingLotDescriptionViewModel.Type: return (AddingLotDescriptionViewModel() as? T)!
        case is AddingLotPriceViewModel.Type: return (AddingLotPriceViewModel() as? T)!
            
        case is AddingLotAddressViewModel.Type: return (AddingLotAddressViewModel(createLotUseCase) as? T)!

        case is OrderViewModel.Type: return (OrderViewModel(orderUseCase, profileUseCase) as? T)!
        
        default:
            fatalError("Not implemented")
        }
    }
}
