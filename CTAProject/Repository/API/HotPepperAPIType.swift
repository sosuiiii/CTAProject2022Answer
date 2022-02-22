import RxSwift

/// @mockable
protocol HotPepperAPIType {
    /// ショップ検索API
    func search(keyValue: [String: Any]) -> Single<HotPepperResponse>
}
