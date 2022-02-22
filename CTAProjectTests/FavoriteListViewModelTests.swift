

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
        let hotPepperRepository = dependency.hotPepperRepository
        let datasource = WatchStack(testTarget.output.datasource)

        hotPepperRepository.getEntityListHandler = { _ in
            Mock.getShopObject()
        }
        XCTAssertEqual(hotPepperRepository.getEntityListCallCount, 0)
        testTarget.input.viewWillAppear.onNext(())
        // Object間で等しくならないため名前で判定する
        XCTAssertEqual(datasource.value?[0].items[0].name, Mock.getFavoriteHotPepperResponseDataSource().items[0].name)
        XCTAssertEqual(hotPepperRepository.getEntityListCallCount, 1, "viewWillAppearでgetEntityListが1回呼ばれていること")
    }

    func test_deleteObject_success() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let hotPepperRepository = dependency.hotPepperRepository
        let datasource = WatchStack(testTarget.output.datasource)
        let hud = WatchStack(testTarget.output.hud)

        hotPepperRepository.deleteOneObjectHandler = { _,_, status in
            status(.success)
        }
        hotPepperRepository.getEntityListHandler = { _ in
            []
        }
        XCTAssertEqual(hotPepperRepository.deleteOneObjectCallCount, 0)
        testTarget.input.deleteObject.onNext(.mock)
        XCTAssertEqual(hotPepperRepository.deleteOneObjectCallCount, 1)
        XCTAssertEqual(hud.value, .success, "データの削除に成功すると、successが流れること")
        XCTAssertEqual(hotPepperRepository.getEntityListCallCount, 1)
        XCTAssertEqual(datasource.value?[0].items, [], "お気に入りデータが削除されていること")
    }

    func test_deleteObject_failure() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let hotPepperRepository = dependency.hotPepperRepository
        let hud = WatchStack(testTarget.output.hud)
        hotPepperRepository.deleteOneObjectHandler = { _,_, status in
            status(.error)
        }
        testTarget.input.deleteObject.onNext(.mock)
        XCTAssertEqual(hud.value, .error, "データの削除に失敗すると、errorが流れること")
    }

}
extension FavoriteListViewModelTests {
    struct Dependency {
        let testTarget: FavoriteListViewModel
        let hotPepperRepository: HotPepperRepositoryTypeMock

        init() {
            self.hotPepperRepository = HotPepperRepositoryTypeMock()
            testTarget = FavoriteListViewModel(hotPepperRepository: hotPepperRepository)
        }
    }
}
