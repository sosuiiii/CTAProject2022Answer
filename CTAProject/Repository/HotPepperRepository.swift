
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

    func search(keyValue: [String: Any]) -> Observable<HotPepperResponse> {

        return Observable.create({ [apiProvider] observer in
            apiProvider.request(.search(keyValue: keyValue)) { response in

                switch response {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(HotPepperResponse.self, from: response.data)
                        observer.onNext(decodedData)
                        observer.onCompleted()
                    } catch {
                        observer.onError(HotPepperAPIError.decodeError)
                    }
                case .failure:
                    observer.onError(HotPepperAPIError.responseError)
                }
            }
            return Disposables.create{}
        })
    }
}
