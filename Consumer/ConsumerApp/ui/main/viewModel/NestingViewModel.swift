//
//  SecondNestingViewModel.swift
//  iosapp
//
//  Created by alexander on 07.05.2022.
//

import Foundation
import RxSwift
import RxRelay
import ConsumerDomain
import LotGRPC
import CoreGRPC
import ZveronNetwork

protocol NestingViewModelBase: ViewModelType {
    var sortingType: BehaviorRelay<SortingType?> { get }
    var presentationModeType: BehaviorRelay<PresentModeType> { get }
    var currentOffset: PublishRelay<CGFloat> { get }
    var filter: BehaviorRelay<FilterModel?> { get }
}

protocol NestingViewModelCollectionView: NestingViewModelBase {
    var endLoadData: PublishRelay<Void?> { get }
    var selectedLot: PublishRelay<Void?> { get }

    var lots: BehaviorRelay<[CoreGRPC.Lot]> { get }
    var currentLot: PublishRelay<CardLot> { get }
    var nonAutharizated: PublishRelay<Void?> { get }
    var needShowMessage: PublishRelay<String> { get }
    var fetchAllLots: BehaviorRelay<Bool> { get }
    var needToDisplayTop: PublishRelay<Void?> { get }

    func updateLots()
    func fetchLots()
    func getCurrentLot(index: Int)
    func updateFavoriteState(by: IndexPath)
}

class NestingViewModel: NestingViewModelCollectionView {
    let endLoadData = PublishRelay<Void?>()
    let fetchAllLots = BehaviorRelay<Bool>(value: false)

    let selectedLot = PublishRelay<Void?>()

    let currentLot = PublishRelay<CardLot>()

    let lots = BehaviorRelay<[CoreGRPC.Lot]>(value: [])

    let nonAutharizated = PublishRelay<Void?>()
    let needShowMessage = PublishRelay<String>()
    let currentOffset = PublishRelay<CGFloat>()

    let sortingType = BehaviorRelay<SortingType?>(value: nil)

    let presentationModeType = BehaviorRelay<PresentModeType>(value: .grid)

    let disposeBag: DisposeBag = DisposeBag()

    let filter = BehaviorRelay<FilterModel?>(value: nil)

    let needToDisplayTop = PublishRelay<Void?>()

    var lastLotData: LastLot?

    internal let useCase: WaterfallUseCaseProtocol
    init(with useCase: WaterfallUseCaseProtocol) {
        self.useCase = useCase

        filter.bind { _ in
            self.needToDisplayTop.accept(nil)
            self.currentOffset.accept(0)
            self.updateLots()
        }.disposed(by: disposeBag)

        sortingType.bind(onNext: { mode in
            guard self.filter.value != nil else { return }
            guard mode != nil, self.filter.value!.sortingType != mode else { return }
            let oldFilter = self.filter.value!
            self.filter.accept(oldFilter.updateFields(sortingType: mode))
        }).disposed(by: disposeBag)
    }

    func getCurrentLot(index: Int) {
        let id = lots.value[index].id
        print(lots.value[index])

        useCase.getCardLot(byId: Int64(id))
            .bind(to: currentLot)
            .disposed(by: disposeBag)
    }

    func updateLots() {
        guard filter.value != nil else { return }
        let filterModel = filter.value!

        let sort = LotGRPC.Sort.with {
            switch filterModel.sortingType {
            case .popularity:
                $0.sortBy = .date
                $0.typeSort = .desc
            case .expensive:
                $0.sortBy = .price
                $0.typeSort = .desc
            case .cheap:
                $0.sortBy = .price
                $0.typeSort = .asc
            default: fatalError("not implemented sorting mode for \(filterModel.sortingType)")
            }
        }

        var filters: [Filter] = []

        filterModel.lotKind.flatMap { value in
            filters.append(
                Filter.with {
                    $0.field = .lotFormID
                    $0.operation = .equality
                    $0.value = String(value.id)
                }
            )
        }

        filterModel.minPrice.flatMap { value in
            filters.append(
                Filter.with {
                    $0.field = .price
                    $0.operation = .greaterThanEquality
                    $0.value = String(value)
                }
            )
        }

        filterModel.maxPrice.flatMap { value in
            filters.append(
                Filter.with {
                    $0.field = .price
                    $0.operation = .lessThanEquality
                    $0.value = String(value)
                }
            )
        }

        print("sortMOde applying: \(sort.sortBy) and \(sort.typeSort)")

        let params = Array(
            filterModel.parameters.map { parameter in
                parameter.choosenValues!.map { choosenValue in
                    LotGRPC.Parameter.with {
                        $0.id = parameter.id
                        $0.name = parameter.name
                        $0.value = choosenValue
                    }
                }
            }.joined()
        )

        useCase.getWaterfall(
            pageSize: 20,
            query: nil,
            categoryId: filterModel.subCategory.flatMap { Int32($0.id) } ?? filterModel.category.flatMap { Int32($0.id) },
            filters: filters,
            modelParameters: params,
            sortingMode: sort
        ).do(onNext: { _ in
            self.endLoadData.accept(nil)
            self.fetchAllLots.accept(false)
        }).subscribe(
            onNext: { (lots, lastLotData) in
                self.lastLotData = lastLotData
                self.lots.accept(lots)
            }
        )
            .disposed(by: disposeBag)
    }

    var fetchLotsInProccess: Bool = false

    func fetchLots() {
        guard fetchLotsInProccess == false else { return }
        fetchLotsInProccess.toggle()
        let filterModel = filter.value!

        let sort = LotGRPC.Sort.with { sortModel in
            switch filterModel.sortingType {
            case .popularity:
                sortModel.sortBy = .date
                sortModel.typeSort = .desc
            case .expensive:
                sortModel.sortBy = .price
                sortModel.typeSort = .desc
            case .cheap:
                sortModel.sortBy = .price
                sortModel.typeSort = .asc
            default: fatalError("not implemented sorting mode for \(filterModel.sortingType)")
            }
            self.lastLotData.flatMap { sortModel.lastLot = $0 }
        }

        var filters: [Filter] = []

        filterModel.lotKind.flatMap { value in
            filters.append(
                Filter.with {
                    $0.field = .lotFormID
                    $0.operation = .equality
                    $0.value = String(value.id)
                }
            )
        }

        filterModel.minPrice.flatMap { value in
            filters.append(
                Filter.with {
                    $0.field = .price
                    $0.operation = .greaterThanEquality
                    $0.value = String(value)
                }
            )
        }

        filterModel.maxPrice.flatMap { value in
            filters.append(
                Filter.with {
                    $0.field = .price
                    $0.operation = .lessThanEquality
                    $0.value = String(value)
                }
            )
        }

        let params = Array(
            filterModel.parameters.map { parameter in
                parameter.choosenValues!.map { choosenValue in
                    LotGRPC.Parameter.with {
                        $0.id = parameter.id
                        $0.name = parameter.name
                        $0.value = choosenValue
                    }
                }
            }.joined()
        )

        print("sortMOde applying: \(sort.sortBy) and \(sort.typeSort)")

        useCase.getWaterfall(
            pageSize: 20,
            query: nil,
            categoryId: filterModel.subCategory.flatMap { Int32($0.id) } ?? filterModel.category.flatMap { Int32($0.id) },
            filters: filters,
            modelParameters: params,
            sortingMode: sort
        ).do(
            onNext: { (lots, lastLotData) in
                self.fetchLotsInProccess.toggle()
                let newLots = lots
                if newLots.isEmpty { self.fetchAllLots.accept(true) }
                var updatedLots = self.lots.value
                updatedLots.append(contentsOf: newLots)
                self.lots.accept(updatedLots)
                self.lastLotData = lastLotData
            },
            onError: { _ in
                self.fetchLotsInProccess.toggle()
            }
        ).subscribe(
            onNext: { _ in }
        )
            .disposed(by: disposeBag)
    }

    func updateFavoriteState(by: IndexPath) {
        if TokenAcquisitionService.shared.authState == .logout || TokenAcquisitionService.shared.authState == .notAuthorized {
            self.nonAutharizated.accept(Void())
            return
        }

        let lotData = lots.value[by.item]
        let isFavoriteNow = !lotData.favorite

        if isFavoriteNow {
            self.useCase.addLot(with: lotData.id).subscribe(
                onNext: {
                    self.updateItemInData(index: by.item, oldItem: lotData, isFavorite: isFavoriteNow)
                },
                onError: { _ in
                    self.needShowMessage.accept("Произошла неизвестная ошибка")
                }
            ).disposed(by: disposeBag)
        } else {
            self.useCase.removeLot(with: lotData.id).subscribe(
                onNext: {
                    self.updateItemInData(index: by.item, oldItem: lotData, isFavorite: isFavoriteNow)
                },
                onError: { _ in
                    self.needShowMessage.accept("Произошла неизвестная ошибка")
                }
            ).disposed(by: disposeBag)
        }
    }

    private func updateItemInData(index: Int, oldItem: CoreGRPC.Lot, isFavorite: Bool) {
        var oldLots = self.lots.value
        oldLots.remove(at: index)
        let newData = CoreGRPC.Lot.with {
            $0.id = oldItem.id
            $0.favorite = isFavorite
            $0.status = oldItem.status
            $0.imageURL = oldItem.imageURL
            $0.publicationDate = oldItem.publicationDate
            $0.price = oldItem.price
            $0.title = oldItem.title
        }

        oldLots.insert(newData, at: index)

        self.lots.accept(oldLots)
    }
}
