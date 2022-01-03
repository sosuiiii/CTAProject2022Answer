
import RxSwift

/// @mockable
protocol HotPepperRepositoryType {
    func search(keyValue: [String: Any]) -> Observable<HotPepperResponse>
}
