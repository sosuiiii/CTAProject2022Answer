
import RealmSwift

class RealmManager {

    static func addEntity<T: Object>(object: T, completion: @escaping (RealmStatus) -> Void ) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object, update: .all)
            }
            completion(.success)
        } catch let error as NSError {
            print("RealmManager.addEntity: " + error.localizedDescription)
            completion(.error)
        }
        //print("realmファイル場所: \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }
    static func deleteOneObject<T: Object>(type: T.Type, name: String, completion: @escaping (RealmStatus) -> Void ) {
        do {
            let realm = try Realm()
            let object = realm.objects(type.self).filter("name == '\(name)'")
            try realm.write {
                realm.delete(object)
            }
            completion(.success)
        } catch let error as NSError {
            print("RealmManager.deleteObject: " + error.localizedDescription)
            completion(.error)
        }
    }

    static func deleteEntity<T: Object>(object: T) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(object)
        }
    }

    static func deleteObject<T: Object>(type: T.Type) {
        do {
            let realm = try Realm()
            let object = realm.objects(type.self)
            try realm.write {
                realm.delete(object)
            }
        } catch let error as NSError {
            print("RealmManager.deleteObject: " + error.localizedDescription)
        }
    }

    static func getEntityList<T: Object>(type: T.Type) -> Results<T> {
        let realm = try! Realm()
        return realm.objects(type.self)
    }

    static func filterEntityList<T: Object>(type: T.Type, property: String, filter: Any) -> Results<T> {
        return getEntityList(type: type).filter("%K == %@", property, String(describing: filter))
    }
}
