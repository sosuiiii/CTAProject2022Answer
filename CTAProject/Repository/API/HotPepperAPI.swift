import Moya
import RxSwift

final class HotPepperAPI {
    private let apiProvider = MoyaProvider<HotPepperTarget>()
}

extension HotPepperAPI: HotPepperAPIType {
    func search(keyValue: [String: Any]) -> Single<HotPepperResponse> {
        // Singleを生成。クロージャ内のobserverパラメータにイベントをハンドリングすることで、
        // 任意のタイミングで正常系だったり異常系のイベントを渡し、
        // 購読側でそれを検知することができる
        // decodeオペレータもあるのでチェックしてみると良いかも
        return Single<HotPepperResponse>.create { [apiProvider] observer in
            apiProvider.request(.search(keyValue: keyValue)) { response in
                switch response {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(HotPepperResponse.self, from: response.data)
                        observer(.success(decodedData))
                    } catch {
                        observer(.failure(HotPepperAPIError.decodeError))
                    }
                case .failure:
                    observer(.failure(HotPepperAPIError.responseError))
                }
            }
            // disposableなやつを最後に返してあげないとdisposeできない。書かないと怒られる。
            return Disposables.create()
        }
    }
}

enum HotPepperAPIError: Error {
    case decodeError
    case responseError
}
