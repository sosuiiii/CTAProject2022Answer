import RxSwift
import RealmSwift

/// @mockable
protocol HotPepperRepositoryType {
    /// ショップ検索API
    func search(keyValue: [String: Any]) -> Single<HotPepperResponse>
    /// DBにエンティティーを保存
    func addEntity<T: Object>(object: T, completion: @escaping (RealmStatus) -> Void )
    /// DBのあるオブジェクトを削除
    func deleteOneObject<T: Object>(type: T.Type, name: String, completion: @escaping (RealmStatus) -> Void )
    /// DBのあるエンティティーを削除
    func deleteEntity<T: Object>(object: T)
    /// DBのオブジェクトを削除
    func deleteObject<T: Object>(type: T.Type)
    /// DBのエンティティーを取得
    func getEntityList<T: Object>(type: T.Type) -> Array<T>
}
