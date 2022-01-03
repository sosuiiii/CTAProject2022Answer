
import CoreLocation
import Foundation
import RxSwift
@testable import CTAProject

enum Mock {
    static func getHotPepperResponse() -> HotPepperResponse {
        let genre: Genre = Genre(code: .mock, name: .mock)
        let url: URL = .mock
        let urls: Urls = .init(pc: .mock, sp: nil)
        let photo: Photo = .init(pc: .init(l: url, m: url, s: url), mobile: .init(l: url, m: url, s: url))
        let shops: [Shop] = [
            Shop(id: .mock, name: .mock, logoImage: nil, nameKana: .mock, address: .mock, stationName: .mock, ktaiCoupon: .mock, largeServiceArea: nil, serviceArea: nil, largeArea: nil, middleArea: nil, smallArea: nil, lat: .mock, lng: .mock, genre: genre, subGenre: genre, budget: nil, budgetMemo: .mock, catch: .mock, capacity: 1, access: .mock, mobileAccess: .mock, urls: urls, photo: photo, open: .mock, close: .mock, wifi: .mock, wedding: .mock, course: .mock, freeDrink: .mock, freeFood: .mock, privateRoom: .mock, horigotatsu: .mock, tatami: .mock, card: .mock, nonSmoking: .mock, charter: .mock, parking: .mock, barrierFree: .mock, otherMemo: .mock, show: .mock, karaoke: .mock, band: .mock, tv: .mock, english: .mock, pet: .mock, child: .mock, lunch: .mock, midnight: .mock, shopDetailMemo: .mock, couponUrls: urls)
        ]
        let result: Result =
        Result(apiVersion: .mock, resultsAvailable: 1, resultsReturned: .mock, resultsStart: 1, shop: shops)
        return CTAProject.HotPepperResponse(results: result)
    }
    static func ObservableHotPepperResponse() -> Observable<HotPepperResponse> {
        Observable.just(getHotPepperResponse())
    }
    static func getShop() -> [Shop] {
        getHotPepperResponse().results.shop
    }
}
extension String {
    static let mock = "mock"
}
extension URL {
    static let mock = URL(string: "http://www.dummy.com/")!
}
extension Int {
    static let mock = 1
}
extension Double {
    static let mock = 1.0
}
