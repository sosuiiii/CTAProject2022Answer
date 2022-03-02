//
//  CTAProjectTests.swift
//  CTAProjectTests
//
//  Created by 田中 颯志 on 2022/01/01.
//

@testable import CTAProject
import PKHUD
import RxSwift
import XCTest

class ListViewModelTests: XCTestCase {
    var dependency: Dependency!

    override func setUp() {
        super.setUp()
    }

    func test_searchTextInput() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let exceedFiftyText = String(repeating: "テスト", count: 20)
        let validatedText = WatchStack(testTarget.output.validatedText)
        let alert = WatchStack(testTarget.output.alert.map { _ in true }) // HUDContentTypeは比較できないのでBool化

        testTarget.input.searchBarText.onNext(.mock)
        testTarget.input.searchBarEditingChanged.onNext(())
        XCTAssertNil(alert.value, "50文字以内で警告アラートが出ないこと")

        testTarget.input.searchBarText.onNext(exceedFiftyText)
        testTarget.input.searchBarEditingChanged.onNext(())
        XCTAssertEqual(validatedText.value?.count, 50, "50文字超過の入力文字が50文字に切り抜かれて反映されること")
        XCTAssertNotNil(alert.value, "50文字超過でアラートが出ること")
    }

    func test_searchButtonTapped_success() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let hotPepperRepository = dependency.hotPepperRespository
        let datasource = WatchStack(testTarget.output.datasource)
        let hud = WatchStack(testTarget.output.hud)

        XCTAssertEqual(hotPepperRepository.searchCallCount, 0, "searchが呼ばれていないこと")
        var keyword: [String: Any]?
        dependency.hotPepperRespository.searchHandler = {
            keyword = $0
            return Mock.SingleHotPepperResponse()
        }

        testTarget.input.searchBarText.onNext(.mock)
        testTarget.input.searchButtonClicked.onNext(())
        XCTAssertEqual(hotPepperRepository.searchCallCount, 1, "searchが1回呼ばれること")
        XCTAssertEqual(keyword!["keyword"] as? String, .mock, "[keyword: 検索ワード]でイベントが流れること")
        XCTAssertEqual(datasource.value?[0].items, Mock.getShop(), "期待する検索結果が返ってくること")
        XCTAssertEqual(hud.value, .progress, "progressが表示されること")
    }

    func test_searchButtonTapped_failure() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let hotPepperRepository = dependency.hotPepperRespository
        let hud = WatchStack(testTarget.output.hud)

        XCTAssertEqual(hotPepperRepository.searchCallCount, 0, "searchが呼ばれていないこと")
        hotPepperRepository.searchHandler = { _ in .error(MockError()) }
        testTarget.input.searchBarText.onNext(.mock)
        testTarget.input.searchButtonClicked.onNext(())
        XCTAssertEqual(hud.value, .error, "APIErrorでHUDContentType.errorが流れること")
    }

    func test_saveFavorite_success() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let hotPepperRespository = dependency.hotPepperRespository
        let hud = WatchStack(testTarget.output.hud)
        hotPepperRespository.addEntityHandler = { _, status in
            status(.success)
        }
        XCTAssertEqual(hotPepperRespository.addEntityCallCount, 0, "saveFavoriteイベント前に呼ばれていないこと")
        let shop = Mock.getShop()[0]
        testTarget.input.saveFavorite.onNext(shop)
        XCTAssertEqual(hotPepperRespository.addEntityCallCount, 1, "saveFavoriteイベント後に1度だけ呼ばれること")
        XCTAssertEqual(hud.value, .success, "保存に成功した時、HUDContentType.successが流れること")
    }

    func test_saveFavorite_failure() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let hotPepperRespository = dependency.hotPepperRespository
        let hud = WatchStack(testTarget.output.hud)
        hotPepperRespository.addEntityHandler = { _, status in
            status(.error)
        }
        XCTAssertEqual(hotPepperRespository.addEntityCallCount, 0, "saveFavoriteイベント前に呼ばれていないこと")
        let shop = Mock.getShop()[0]
        testTarget.input.saveFavorite.onNext(shop)
        XCTAssertEqual(hotPepperRespository.addEntityCallCount, 1, "saveFavoriteイベント後に1度だけ呼ばれること")
        XCTAssertEqual(hud.value, .error, "保存に成功した時、HUDContentType.errorが流れること")
    }

    func test_deleteObject_success() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let hotPepperRespository = dependency.hotPepperRespository
        let hud = WatchStack(testTarget.output.hud)
        hotPepperRespository.deleteOneObjectHandler = { _, _, status in
            status(.success)
        }
        XCTAssertEqual(hotPepperRespository.deleteOneObjectCallCount, 0, "deleteObjectイベント前に呼ばれていないこと")
        testTarget.input.deleteObject.onNext(.mock)
        XCTAssertEqual(hotPepperRespository.deleteOneObjectCallCount, 1, "deleteObjectイベント後に1度だけ呼ばれること")
        XCTAssertEqual(hud.value, .success, "保存に成功した時、HUDContentType.successが流れること")
    }

    func test_deleteObject_failure() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let hotPepperRespository = dependency.hotPepperRespository
        let hud = WatchStack(testTarget.output.hud)
        hotPepperRespository.deleteOneObjectHandler = { _, _, status in
            status(.error)
        }
        XCTAssertEqual(hotPepperRespository.deleteOneObjectCallCount, 0, "deleteObjectイベント前に呼ばれていないこと")
        testTarget.input.deleteObject.onNext(.mock)
        XCTAssertEqual(hotPepperRespository.deleteOneObjectCallCount, 1, "deleteObjectイベント後に1度だけ呼ばれること")
        XCTAssertEqual(hud.value, .error, "保存に成功した時、HUDContentType.errorが流れること")
    }

}

extension ListViewModelTests {
    struct Dependency {
        let testTarget: ListViewModel
        let hotPepperRespository: HotPepperRepositoryTypeMock
//        let realmManager: RealmManagerTypeMock

        init() {
            self.hotPepperRespository = HotPepperRepositoryTypeMock()
//            self.realmManager = RealmManagerTypeMock()
            testTarget = ListViewModel(
                hotPepperRepository: hotPepperRespository
            )
        }
    }

    struct MockError: Error {}
}
