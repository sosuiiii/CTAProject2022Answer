
import Moya
import RxSwift
import RealmSwift

// レポジトリはデータアクセスレイヤーに対してI/Fを持つ
// ここではHotPepperAPIとRealmManagerで、
// Repositoryを利用する側からは 保存先が RealmでもSQL でも関係なく操作ができるようになる
// Realmに保存するか、SQLに保存するか、APIかどうか、はRepositoryの中で決定してることであって、
// Repositoryの外から意識することではないため。

final class HotPepperRepository: HotPepperRepositoryType {
    let hotPepperApi: HotPepperAPIType
    let realmManager: RealmManagerType
    init(
        hotPepperApi: HotPepperAPIType = HotPepperAPI(),
        realmManager: RealmManagerType = RealmManager()
    ) {
        self.hotPepperApi = hotPepperApi
        self.realmManager = realmManager
    }
}

extension HotPepperRepository: HotPepperAPIType {
    func search(keyValue: [String : Any]) -> Single<HotPepperResponse> {
        hotPepperApi.search(keyValue: keyValue)
    }
}

extension HotPepperRepository: RealmManagerType {
    func addEntity<T: Object>(object: T, completion: @escaping (RealmStatus) -> Void ) {
        realmManager.addEntity(object: object, completion: completion)
    }

    func deleteOneObject<T: Object>(type: T.Type, name: String, completion: @escaping (RealmStatus) -> Void ) {
        realmManager.deleteOneObject(type: type, name: name, completion: completion)
    }

    func deleteEntity<T: Object>(object: T) {
        realmManager.deleteEntity(object: object)
    }

    func deleteObject<T: Object>(type: T.Type) {
        realmManager.deleteObject(type: type)
    }

    func getEntityList<T: Object>(type: T.Type) -> Array<T> {
        realmManager.getEntityList(type: type)
    }
}
