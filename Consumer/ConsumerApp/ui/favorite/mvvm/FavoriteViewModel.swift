//
//  FavoriteViewModel.swift
//  iosapp
//
//  Created by alexander on 09.05.2022.
//

import Foundation
import RxSwift
import ConsumerDomain
import RxCocoa
import FavoritesGRPC
import LotGRPC
import ZveronNetwork
import CoreGRPC

public class FavoriteViewModel: ViewModelType {
    let disposeBag: DisposeBag = DisposeBag()

    private let animalItems: BehaviorRelay<[CoreGRPC.Lot]?> = BehaviorRelay(value: nil)
    private let goodsItems: BehaviorRelay<[CoreGRPC.Lot]?> = BehaviorRelay(value: nil)
    private let profileItems: BehaviorRelay<[FavoritesGRPC.ProfileSummary]?> = BehaviorRelay(value: nil)
    private let items: PublishSubject<FavoriteSectionModel> = PublishSubject()

    public struct Input {
        let dataWillRetry: Driver<Void>
        let favoriteTypeTrigger: Driver<FavoriteSourceType>
        let loadDataTrigger: Driver<Void>
        let removeItemTrigger: Driver<Int64>
        let settingsTrigger: Driver<FavoriteViewController.SettingMode>
        let itemSelectTrigger: Driver<IndexPath>
    }

    public struct Output {
        let itemsLoaded: Driver<Void>
        let sourceSelected: Driver<Void>
        let itemRemoved: Driver<Void>
        let items: Driver<FavoriteSectionModel>
        let errors: Driver<Error>
        let settings: Driver<Void>
        let lotSelected: Driver<CardLot>
        let profileSelected: Driver<Void>
        let isLoading: Driver<Bool>
    }

    private let favoriteUseCase: FavoriteUseCaseProtocol
    public init(_ favoriteUseCase: FavoriteUseCaseProtocol) {
        self.favoriteUseCase = favoriteUseCase
    }

    public func transform(input: Input) -> Output {

        let errorTracker = ErrorTracker()

        let itemsLoaded: Driver<Void> = input.loadDataTrigger.flatMap { _ in
            Observable.zip(
                self.favoriteUseCase.getLotsByCategory(categoryId: FavoriteSourceType.animal.getCategoryId()),
                self.favoriteUseCase.getLotsByCategory(categoryId: FavoriteSourceType.goods.getCategoryId()),
                self.favoriteUseCase.getProfiles()
            ) { ($0, $1, $2) }
                .trackError(errorTracker)
                .do(onNext: { (animal, goods, profile) in
                self.animalItems.accept(animal)
                self.goodsItems.accept(goods)
                self.profileItems.accept(profile)
            }).mapToVoid().asDriver(onErrorJustReturn: Void())
        }


        let animalSourceSelected = Driver<FavoriteSourceType>.combineLatest(
            input.favoriteTypeTrigger,
            self.animalItems.asDriver()
        ) { type, _ in return type }.do(onNext: { type in
            guard type == FavoriteSourceType.animal else { return }
            guard let items = self.animalItems.value else { return }
            let itemsToPublish = items.map { FavoriteSectionItem.LotItem(item: $0) }
            self.items.onNext(FavoriteSectionModel.FavoriteSection(type: .animal, items: itemsToPublish))
        })

        let goodsSourceSelected = Driver<FavoriteSourceType>.combineLatest(
            input.favoriteTypeTrigger,
            self.goodsItems.asDriver()
        ) { type, _ in type }.do(onNext: { type in
            guard type == FavoriteSourceType.goods else { return }
            guard let items = self.goodsItems.value else { return }
            let itemsToPublish = items.map { FavoriteSectionItem.LotItem(item: $0) }
            self.items.onNext(FavoriteSectionModel.FavoriteSection(type: .goods, items: itemsToPublish))
        })

        let profileSourceSelected = Driver<FavoriteSourceType>.combineLatest(
            input.favoriteTypeTrigger,
            self.profileItems.asDriver()
        ) { type, _ in type }.do(onNext: { type in
            guard type == FavoriteSourceType.vendor else { return }
            guard let items = self.profileItems.value else { return }
            let itemsToPublish = items.map { FavoriteSectionItem.ProfileItem(item: $0) }
            self.items.onNext(FavoriteSectionModel.FavoriteSection(type: .vendor, items: itemsToPublish))
        })

        let sourceSelected = Driver.merge(animalSourceSelected, goodsSourceSelected, profileSourceSelected)
            .mapToVoid()

        let itemRemoved: Driver<Void> = input.removeItemTrigger.withLatestFrom(input.favoriteTypeTrigger) { (itemId: $0, type: $1) }
            .flatMap { (itemId, type) -> Driver<Void> in

            let removeObservable: Observable<Void>

            switch type {
            case .animal: removeObservable = self.favoriteUseCase.removeLot(with: itemId)
                    .do(onNext: {
                    var items = self.animalItems.value!
                    items.removeAll(where: { $0.id == itemId })
                    self.animalItems.accept(items)
                })
            case .goods: removeObservable = self.favoriteUseCase.removeLot(with: itemId)
                    .do(onNext: {
                    var items = self.goodsItems.value!
                    items.removeAll(where: { $0.id == itemId })
                    self.goodsItems.accept(items)
                })
            case .vendor: removeObservable = self.favoriteUseCase.removeProfile(with: itemId)
                    .do(onNext: {
                    var items = self.profileItems.value!
                    items.removeAll(where: { $0.id == itemId })
                    self.profileItems.accept(items)
                })
            }

            return removeObservable.trackError(errorTracker).asDriverOnErrorJustComplete()
        }

        let errors = errorTracker.withLatestFrom(input.favoriteTypeTrigger) { (error: $0, type: $1) }
            .do { (error, type) in
            guard let error = error as? FavoriteError else { return }
            switch error { 
            case .failedLoad:
                self.animalItems.accept(nil)
                self.goodsItems.accept(nil)
                self.profileItems.accept(nil)
                self.items.onNext(FavoriteSectionModel.FavoriteSection(type: .animal, items: []))
            default: break
            }
        }.map { $0.error }
            .asDriver()

        let settings: Driver<Void> = input.settingsTrigger.withLatestFrom(input.favoriteTypeTrigger) { ($0, $1) }.flatMap { (settingMode, type) -> Driver<Void> in

            let observable: Observable<Void>
            let publisher: BehaviorRelay<[CoreGRPC.Lot]?>

            switch type {
            case .animal: publisher = self.animalItems
            case .goods: publisher = self.goodsItems
            default: fatalError("this logic must be run only for .animal and .goods datasource types")
            }

            switch settingMode {
            case .deleteUnactive: observable = self.favoriteUseCase.deleteCosedLotsByCategory(categoryId: type.getCategoryId()).do(onNext: {
                    var items = publisher.value!
                    items.removeAll(where: { $0.status == .closed })
                    publisher.accept(items)
                })

            case .deleteAll: observable = self.favoriteUseCase.deleteAllLotsByCategory(categoryId: type.getCategoryId()).do(onNext: {
                    publisher.accept([])
                })
            }

            return observable.trackError(errorTracker).asDriverOnErrorJustComplete()
        }

        let lotSelected: Driver<CardLot> = input.itemSelectTrigger.withLatestFrom(input.favoriteTypeTrigger) { ($0, $1) }
            .flatMap { (itemIdx, type) in
            let lotId: Int64

            switch type {
            case .animal: lotId = self.animalItems.value![itemIdx.item].id
            case .goods: lotId = self.goodsItems.value![itemIdx.item].id
            default: return Driver.empty()
            }
            return self.favoriteUseCase.getCardLot(lotId: lotId).trackError(errorTracker).asDriverOnErrorJustComplete()
        }

        //TODO: Доделать
        let profileSelected: Driver<Void> = input.itemSelectTrigger.withLatestFrom(input.favoriteTypeTrigger) { ($0, $1) }
            .flatMap { (itemIdx, type) in
            if type != .vendor { return Driver.empty() }

            let profileId = self.profileItems.value![itemIdx.item].id
            return Driver.just(Void())
        }

        let isLoadingWithDebounce = Driver.merge(
            input.loadDataTrigger.map { _ in true },
            input.removeItemTrigger.map { _ in true },
            input.itemSelectTrigger.map { _ in true },
            input.settingsTrigger.map { _ in true },

            itemsLoaded.map { _ in false },
            itemRemoved.map { _ in false },
            settings.map { _ in false },
            lotSelected.map { _ in false },
            errors.map { _ in false }
        )
            .debounce(.milliseconds(500))

        let isLoadingWithoutDebounce = Driver.merge(
            input.dataWillRetry.map{ _ in true},
            itemsLoaded.map { _ in false },
            itemRemoved.map { _ in false },
            settings.map { _ in false },
            lotSelected.map { _ in false },
            errors.map { _ in false }
        )

        let isLoading = Driver.merge(isLoadingWithDebounce, isLoadingWithoutDebounce)
            .distinctUntilChanged()

        return Output(
            itemsLoaded: itemsLoaded,
            sourceSelected: sourceSelected,
            itemRemoved: itemRemoved,
            items: items.asDriverOnErrorJustComplete(),
            errors: errors,
            settings: settings,
            lotSelected: lotSelected,
            profileSelected: profileSelected,
            isLoading: isLoading
        )
    }
}
