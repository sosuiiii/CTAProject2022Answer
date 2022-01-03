

import XCTest
@testable import CTAProject

class FavoriteListViewModelTests: XCTestCase {

    var dependency: Dependency!

    override func setUp() {
        super.setUp()
    }

}
extension FavoriteListViewModelTests {
    struct Dependency {
        let testTarget: FavoriteListViewModel
        let realmManager: RealmManagerType

        init() {
            self.realmManager = RealmManagerTypeMock()
            testTarget = FavoriteListViewModel(realmManager: realmManager)
        }
    }
}
