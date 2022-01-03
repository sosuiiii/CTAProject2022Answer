

import XCTest
import PKHUD
import RealmSwift
@testable import CTAProject

class FavoriteListViewModelTests: XCTestCase {

    var dependency: Dependency!

    override func setUp() {
        super.setUp()
    }

    func test_viewWillAppear() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let realmManager = dependency.realmManager
        let datasource = WatchStack(testTarget.output.datasource)

        realmManager.getEntityListHandler = { _ in
            Mock.getShopObject()
        }
        XCTAssertEqual(realmManager.getEntityListCallCount, 0)
        testTarget.input.viewWillAppear.onNext(())
        // Object間で等しくならないため名前で判定する
        XCTAssertEqual(datasource.value?[0].items[0].name, Mock.getFavoriteHotPepperResponseDataSource().items[0].name)
        XCTAssertEqual(realmManager.getEntityListCallCount, 1, "viewWillAppearでgetEntityListが1回呼ばれていること")
    }

    func test_deleteObject_success() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let realmManager = dependency.realmManager
        let datasource = WatchStack(testTarget.output.datasource)
        let hud = WatchStack(testTarget.output.hud)

        realmManager.deleteOneObjectHandler = { _,_, status in
            status(.success)
        }
        realmManager.getEntityListHandler = { _ in
            []
        }
        XCTAssertEqual(realmManager.deleteOneObjectCallCount, 0)
        testTarget.input.deleteObject.onNext(.mock)
        XCTAssertEqual(realmManager.deleteOneObjectCallCount, 1)
        let hudIsSuccess = HUDContentTypeJudge.isSuccess(hud.value)
        XCTAssertTrue(hudIsSuccess)
        XCTAssertEqual(realmManager.getEntityListCallCount, 1)
        XCTAssertEqual(datasource.value?[0].items, [], "お気に入りデータが削除されていること")
    }

    func test_deleteObject_failure() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let realmManager = dependency.realmManager
        let hud = WatchStack(testTarget.output.hud)
        realmManager.deleteOneObjectHandler = { _,_, status in
            status(.error)
        }
        testTarget.input.deleteObject.onNext(.mock)
        let hudIsError = HUDContentTypeJudge.isError(hud.value)
        XCTAssertTrue(hudIsError)
    }

}
extension FavoriteListViewModelTests {
    struct Dependency {
        let testTarget: FavoriteListViewModel
        let realmManager: RealmManagerTypeMock

        init() {
            self.realmManager = RealmManagerTypeMock()
            testTarget = FavoriteListViewModel(realmManager: realmManager)
        }
    }
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
