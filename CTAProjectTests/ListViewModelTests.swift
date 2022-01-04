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
        let exceedFiftyText = "テストテキストテストテキストテストテキストテストテキストテストテキストテストテキストテストテキストテストテキスト"
        let validatedText = WatchStack(testTarget.output.validatedText)
        let alert = WatchStack(testTarget.output.alert.map { _ in true }) // HUDContentTypeは比較できないのでBool化

        testTarget.input.searchTextInput.onNext(.mock)
        XCTAssertEqual(validatedText.value, .mock, "50文字以内の入力文字がそのまま反映されること")
        XCTAssertNil(alert.value, "50文字以内で警告アラートが出ないこと")

        testTarget.input.searchTextInput.onNext(exceedFiftyText)
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
            return Mock.ObservableHotPepperResponse()
        }

        testTarget.input.searchButtonTapped.onNext(.mock)
        XCTAssertEqual(hotPepperRepository.searchCallCount, 1, "searchが1回呼ばれること")
        XCTAssertEqual(keyword!["keyword"] as? String, .mock, "[keyword: 検索ワード]でイベントが流れること")
        XCTAssertEqual(datasource.value?[0].items, Mock.getShop(), "期待する検索結果が返ってくること")

        let hudIsProgress = HUDContentTypeJudge.isProgress(hud.value)
        XCTAssertTrue(hudIsProgress, "progressが表示されること")
    }

    func test_searchButtonTapped_failure() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let hotPepperRepository = dependency.hotPepperRespository
        let hud = WatchStack(testTarget.output.hud)

        XCTAssertEqual(hotPepperRepository.searchCallCount, 0, "searchが呼ばれていないこと")
        hotPepperRepository.searchHandler = { _ in .error(MockError()) }
        testTarget.input.searchButtonTapped.onNext(.mock)

        let hudIsError = HUDContentTypeJudge.isError(hud.value)
        XCTAssertEqual(hudIsError, true, "APIErrorでHUDContentType.errorが流れること")
    }

    func test_saveFavorite_success() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let realmManager = dependency.realmManager
        let hud = WatchStack(testTarget.output.hud)
        realmManager.addEntityHandler = { _, status in
            status(.success)
        }
        XCTAssertEqual(realmManager.addEntityCallCount, 0, "saveFavoriteイベント前に呼ばれていないこと")
        let shop = Mock.getShop()[0]
        testTarget.input.saveFavorite.onNext(shop)
        let hudIsSuccess = HUDContentTypeJudge.isSuccess(hud.value)
        XCTAssertEqual(realmManager.addEntityCallCount, 1, "saveFavoriteイベント後に1度だけ呼ばれること")
        XCTAssertTrue(hudIsSuccess, "保存に成功した時、HUDContentType.successが流れること")
    }

    func test_saveFavorite_failure() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let realmManager = dependency.realmManager
        let hud = WatchStack(testTarget.output.hud)
        realmManager.addEntityHandler = { _, status in
            status(.error)
        }
        XCTAssertEqual(realmManager.addEntityCallCount, 0, "saveFavoriteイベント前に呼ばれていないこと")
        let shop = Mock.getShop()[0]
        testTarget.input.saveFavorite.onNext(shop)
        let hudIsError = HUDContentTypeJudge.isError(hud.value)
        XCTAssertEqual(realmManager.addEntityCallCount, 1, "saveFavoriteイベント後に1度だけ呼ばれること")
        XCTAssertTrue(hudIsError, "保存に成功した時、HUDContentType.errorが流れること")
    }

    func test_deleteObject_success() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let realmManager = dependency.realmManager
        let hud = WatchStack(testTarget.output.hud)
        realmManager.deleteOneObjectHandler = { _, _, status in
            status(.success)
        }
        XCTAssertEqual(realmManager.deleteOneObjectCallCount, 0, "deleteObjectイベント前に呼ばれていないこと")
        testTarget.input.deleteObject.onNext(.mock)
        let hudIsSuccess = HUDContentTypeJudge.isSuccess(hud.value)
        XCTAssertEqual(realmManager.deleteOneObjectCallCount, 1, "deleteObjectイベント後に1度だけ呼ばれること")
        XCTAssertTrue(hudIsSuccess, "保存に成功した時、HUDContentType.successが流れること")
    }

    func test_deleteObject_failure() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let realmManager = dependency.realmManager
        let hud = WatchStack(testTarget.output.hud)
        realmManager.deleteOneObjectHandler = { _, _, status in
            status(.error)
        }
        XCTAssertEqual(realmManager.deleteOneObjectCallCount, 0, "deleteObjectイベント前に呼ばれていないこと")
        testTarget.input.deleteObject.onNext(.mock)
        let hudIsError = HUDContentTypeJudge.isError(hud.value)
        XCTAssertEqual(realmManager.deleteOneObjectCallCount, 1, "deleteObjectイベント後に1度だけ呼ばれること")
        XCTAssertTrue(hudIsError, "保存に成功した時、HUDContentType.errorが流れること")
    }

}

extension ListViewModelTests {
    struct Dependency {
        let testTarget: ListViewModel
        let hotPepperRespository: HotPepperRepositoryTypeMock
        let realmManager: RealmManagerTypeMock

        init() {
            self.hotPepperRespository = HotPepperRepositoryTypeMock()
            self.realmManager = RealmManagerTypeMock()
            testTarget = ListViewModel(
                hotPepperRepository: hotPepperRespository,
                realmManager: realmManager
            )
        }
    }

    struct MockError: Error {}

    enum HUDContentTypeJudge {
        static func isError(_ type: HUDContentType?) -> Bool {
            guard let type = type else { return false }
            switch type {
            case .error: return true
            default: return false
            }
        }
        static func isSuccess(_ type: HUDContentType?) -> Bool {
            guard let type = type else { return false }
            switch type {
            case .success: return true
            default: return false
            }
        }
        static func isProgress(_ type: HUDContentType?) -> Bool {
            guard let type = type else { return false }
            switch type {
            case .progress: return true
            default: return false
            }
        }
    }
}
