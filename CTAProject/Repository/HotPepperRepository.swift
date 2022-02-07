
import Moya
import RxSwift

enum HotPepperAPIError: Error {
    case responseError
    case decodeError
}

final class HotPepperRepository: HotPepperRepositoryType {
    private let apiProvider = MoyaProvider<HotPepperAPI>()
}
extension HotPepperRepository {

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
