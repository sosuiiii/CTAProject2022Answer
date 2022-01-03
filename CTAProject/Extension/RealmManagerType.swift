
import RealmSwift

/// @mockable
protocol RealmManagerType {
    func addEntity<T: Object>(object: T, completion: @escaping (RealmStatus) -> Void )

    func deleteOneObject<T: Object>(type: T.Type, name: String, completion: @escaping (RealmStatus) -> Void )

    func deleteEntity<T: Object>(object: T)

    func deleteObject<T: Object>(type: T.Type)

    func getEntityList<T: Object>(type: T.Type)
    -> Results<T>
    func filterEntityList<T: Object>(type: T.Type, property: String, filter: Any) -> Results<T>
}
