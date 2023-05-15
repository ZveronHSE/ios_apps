//
//  FavoriteViewModelTests.swift
//  iosappTests
//
//  Created by alexander on 14.03.2023.
//

@testable import ConsumerApp
import XCTest
import RxSwift
import RxCocoa
import RxBlocking
import CoreGRPC
import FavoritesGRPC
import LotGRPC

class FavoriteViewModelTests: XCTestCase {

    var favoriteUseCase: FavoriteUseCaseMock!
    var viewModel: FavoriteViewModel!

    var disposBag: DisposeBag!

    override func setUp() {
        super.setUp()

        disposBag = DisposeBag()
        favoriteUseCase = FavoriteUseCaseMock()
        viewModel = FavoriteViewModel(favoriteUseCase)
    }

    func test_transform_loadDataTriggerInvoked_itemsLoaded() {
        // arrange
        let loadDataTrigger = PublishSubject<Void>()
        let input = createInput(loadDataTrigger: loadDataTrigger)
        let output = viewModel.transform(input: input)

        // act
        output.itemsLoaded.drive().disposed(by: disposBag)
        loadDataTrigger.onNext(Void())

        // assert
        XCTAssert(favoriteUseCase.getLotsByCategory1_Called)
        XCTAssert(favoriteUseCase.getLotsByCategory2_Called)
        XCTAssert(favoriteUseCase.getProfiles_Called)
    }

    func test_transform_favoriteTypeTriggerInvokedWithAnimalType_animalItemsEmited() {
        // arrange
        let animalItems = createLots()
        let favoriteTypeTrigger = PublishSubject<FavoriteSourceType>()
        let input = createInput(favoriteTypeTrigger: favoriteTypeTrigger)
        let output = viewModel.transform(input: input)
        favoriteUseCase.getLotsByCategory1_ReturnValue = Observable.just(animalItems)
        favoriteUseCase.getLotsByCategory2_ReturnValue = Observable.just([])
        favoriteUseCase.getProfiles_ReturnValue = Observable.just([])

        // act
        output.itemsLoaded.drive().disposed(by: disposBag)
        output.sourceSelected.drive().disposed(by: disposBag)

        output.items.drive().disposed(by: disposBag)
        favoriteTypeTrigger.onNext(.animal)
        let model = (try? output.items.toBlocking().first())!

        // assert
        XCTAssertEqual(model.items.count, animalItems.count)
        XCTAssertEqual(model.type, .animal)
    }

    func test_transform_favoriteTypeTriggerInvokedWithGoodsType_goodsItemsEmited() {
        // arrange
        let goodsItems = createLots()
        let favoriteTypeTrigger = PublishSubject<FavoriteSourceType>()
        let input = createInput(favoriteTypeTrigger: favoriteTypeTrigger)
        let output = viewModel.transform(input: input)
        favoriteUseCase.getLotsByCategory1_ReturnValue = Observable.just([])
        favoriteUseCase.getLotsByCategory2_ReturnValue = Observable.just(goodsItems)
        favoriteUseCase.getProfiles_ReturnValue = Observable.just([])

        // act
        output.itemsLoaded.drive().disposed(by: disposBag)
        output.sourceSelected.drive().disposed(by: disposBag)

        output.items.drive().disposed(by: disposBag)
        favoriteTypeTrigger.onNext(.goods)
        let model = (try? output.items.toBlocking().first())!

        // assert
        XCTAssertEqual(model.items.count, goodsItems.count)
        XCTAssertEqual(model.type, .goods)
    }

    func test_transform_favoriteTypeTriggerInvokedWithVendorType_vendorItemsEmited() {
        // arrange
        let vendorItems = createProfiles()
        let favoriteTypeTrigger = PublishSubject<FavoriteSourceType>()
        let input = createInput(favoriteTypeTrigger: favoriteTypeTrigger)
        let output = viewModel.transform(input: input)
        favoriteUseCase.getLotsByCategory1_ReturnValue = Observable.just([])
        favoriteUseCase.getLotsByCategory2_ReturnValue = Observable.just([])
        favoriteUseCase.getProfiles_ReturnValue = Observable.just(vendorItems)

        // act
        output.itemsLoaded.drive().disposed(by: disposBag)
        output.sourceSelected.drive().disposed(by: disposBag)

        output.items.drive().disposed(by: disposBag)
        favoriteTypeTrigger.onNext(.vendor)
        let model = (try? output.items.toBlocking().first())!

        // assert
        XCTAssertEqual(model.items.count, vendorItems.count)
        XCTAssertEqual(model.type, .vendor)
    }

    func test_transform_itemSelectTrigger_selectedLotEmited() {
        // arrange
        let indexPath = IndexPath(item: 2, section: 0)
        let animalItems = createLots()
        let cardLot = createCardLot()

        let sourceSelectTrigger = PublishSubject<FavoriteSourceType>()
        let itemSelectTrigger = PublishSubject<IndexPath>()
        let input = createInput(favoriteTypeTrigger: sourceSelectTrigger, itemSelectTrigger: itemSelectTrigger)
        let output = viewModel.transform(input: input)
        favoriteUseCase.getLotsByCategory1_ReturnValue = Observable.just(animalItems)
        favoriteUseCase.getCardLot_ReturnIfId = animalItems[indexPath.item].id
        favoriteUseCase.getCardLot_ReturnValue = Observable.just(cardLot)

        // act
        output.itemsLoaded.drive().disposed(by: disposBag)
        output.sourceSelected.drive().disposed(by: disposBag)
        output.lotSelected.drive().disposed(by: disposBag)

        sourceSelectTrigger.onNext(.animal)
        itemSelectTrigger.onNext(indexPath)

        let actualLot = (try? output.lotSelected.toBlocking().first())!

        // assert
        XCTAssertTrue(favoriteUseCase.getCardLot_Called)
        XCTAssertEqual(actualLot.title, cardLot.title)
    }

    // TODO: сделать потом как нибудь
    func test_transform_itemSelectTrigger_selectedProfileEmited() {}
//        // arrange
//        let indexPath = IndexPath(item: 2, section: 0)
//        let vendorItems = createProfiles()
//       // let cardProfile = createCardProfile()
//
//        let sourceSelectTrigger = PublishSubject<FavoriteSourceType>()
//        let itemSelectTrigger = PublishSubject<IndexPath>()
//        let input = createInput(favoriteTypeTrigger: sourceSelectTrigger, itemSelectTrigger: itemSelectTrigger)
//        let output = viewModel.transform(input: input)
//       // favoriteUseCase.getProfiles_ReturnValue = Observable.just(vendorItems)
//       // favoriteUseCase.getCardProfile_ReturnIfId = animalItems[indexPath.item].id
//       // favoriteUseCase.getCardProfile_ReturnValue = Observable.just(cardProfile)
//
//        // act
//        output.itemsLoaded.drive().disposed(by: disposBag)
//        output.sourceSelected.drive().disposed(by: disposBag)
//        output.profileSelected.drive().disposed(by: disposBag)
//
//        sourceSelectTrigger.onNext(.vendor)
//        itemSelectTrigger.onNext(indexPath)
//
//        let actualLot = (try? output.profileSelected.toBlocking().first())!
//
//        // assert
//      //  XCTAssertTrue(favoriteUseCase.getCardLot_Called)
//       // XCTAssertEqual(actualLot.title, cardLot.title)
//    }

    // Доделать тесты

//     func test_transform_sendPost_trackFetching() {
//       // arrange
//       let trigger = PublishSubject<Void>()
//       let output = viewModel.transform(input: createInput(trigger: trigger))
//       let expectedFetching = [true, false]
//       var actualFetching: [Bool] = []
//
//       // act
//       output.fetching
//         .do(onNext: { actualFetching.append($0) },
//             onSubscribe: { actualFetching.append(true) })
//         .drive()
//         .disposed(by: disposeBag)
//       trigger.onNext(())
//
//       // assert
//       XCTAssertEqual(actualFetching, expectedFetching)
//     }
//
//     func test_transform_postEmitError_trackError() {
//       // arrange
//       let trigger = PublishSubject<Void>()
//       let output = viewModel.transform(input: createInput(trigger: trigger))
//       allPostUseCase.posts_ReturnValue = Observable.error(TestError.test)
//
//       // act
//       output.posts.drive().disposed(by: disposeBag)
//       output.error.drive().disposed(by: disposeBag)
//       trigger.onNext(())
//       let error = try! output.error.toBlocking().first()
//
//       // assert
//       XCTAssertNotNil(error)
//     }
//
//     func test_transform_triggerInvoked_mapPostsToViewModels() {
//       // arrange
//       let trigger = PublishSubject<Void>()
//       let output = viewModel.transform(input: createInput(trigger: trigger))
//       allPostUseCase.posts_ReturnValue = Observable.just(createPosts())
//
//       // act
//       output.posts.drive().disposed(by: disposeBag)
//       trigger.onNext(())
//       let posts = try! output.posts.toBlocking().first()!
//
//       // assert
//       XCTAssertEqual(posts.count, 2)
//     }
//
//     func test_transform_selectedPostInvoked_navigateToPost() {
//       // arrange
//       let select = PublishSubject<IndexPath>()
//       let output = viewModel.transform(input: createInput(selection: select))
//       let posts = createPosts()
//       allPostUseCase.posts_ReturnValue = Observable.just(posts)
//
//       // act
//       output.posts.drive().disposed(by: disposeBag)
//       output.selectedPost.drive().disposed(by: disposeBag)
//       select.onNext(IndexPath(row: 1, section: 0))
//
//       // assert
//       XCTAssertTrue(postsNavigator.toPost_post_Called)
//       XCTAssertEqual(postsNavigator.toPost_post_ReceivedArguments, posts[1])
//     }
//
//     func test_transform_createPostInvoked_navigateToCreatePost() {
//       // arrange
//       let create = PublishSubject<Void>()
//       let output = viewModel.transform(input: createInput(createPostTrigger: create))
//       let posts = createPosts()
//       allPostUseCase.posts_ReturnValue = Observable.just(posts)
//
//       // act
//       output.posts.drive().disposed(by: disposeBag)
//       output.createPost.drive().disposed(by: disposeBag)
//       create.onNext(())
//
//       // assert
//       XCTAssertTrue(postsNavigator.toCreatePost_Called)
//     }

    private func createInput(
        dataWillRetryTrigger: Observable<Void> = Observable.never(),
        favoriteTypeTrigger: Observable<FavoriteSourceType> = Observable.never(),
        loadDataTrigger: Observable<Void> = Observable.just(Void()),
        removeItemTrigger: Observable<Int64> = Observable.never(),
        settingsTrigger: Observable<FavoriteViewController.SettingMode> = Observable.never(),
        itemSelectTrigger: Observable<IndexPath> = Observable.never()
    ) -> FavoriteViewModel.Input {
        return FavoriteViewModel.Input(
            dataWillRetry: dataWillRetryTrigger.asDriverOnErrorJustComplete(),
            favoriteTypeTrigger: favoriteTypeTrigger.asDriverOnErrorJustComplete(),
            loadDataTrigger: loadDataTrigger.asDriverOnErrorJustComplete(),
            removeItemTrigger: removeItemTrigger.asDriverOnErrorJustComplete(),
            settingsTrigger: settingsTrigger.asDriverOnErrorJustComplete(),
            itemSelectTrigger: itemSelectTrigger.asDriverOnErrorJustComplete()
        )
    }

    private func createLots() -> [CoreGRPC.Lot] {
        return [
            CoreGRPC.Lot.with { $0.id = 1 },
            CoreGRPC.Lot.with { $0.id = 2 },
            CoreGRPC.Lot.with { $0.id = 3 }
        ]
    }

    private func createProfiles() -> [ProfileSummary] {
        return [
            ProfileSummary.with { $0.id = 1 },
            ProfileSummary.with { $0.id = 2 }
        ]
    }

    private func createCardLot() -> CardLot {
        return CardLot.with { $0.title = "some title" }
    }

    // TODO:
//    private func createCardProfile() -> Void {
//        return
//    }
}
