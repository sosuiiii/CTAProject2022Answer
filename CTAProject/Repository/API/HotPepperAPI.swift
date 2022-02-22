import Moya
import RxSwift

final class HotPepperAPI {
    private let apiProvider = MoyaProvider<HotPepperTarget>()
}

extension HotPepperAPI: HotPepperAPIType {
    func search(keyValue: [String: Any]) -> Single<HotPepperResponse> {
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
            return Disposables.create()
        }
    }
}

enum HotPepperAPIError: Error {
    case decodeError
    case responseError
}
