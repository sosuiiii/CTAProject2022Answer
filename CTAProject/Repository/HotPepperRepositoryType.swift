
import RxSwift

/// @mockable
protocol HotPepperRepositoryType {
    func search(keyValue: [String: Any]) -> Single<HotPepperResponse>
}
