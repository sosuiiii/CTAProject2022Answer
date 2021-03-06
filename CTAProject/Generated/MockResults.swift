///
/// @Generated by Mockolo
///



import RealmSwift
import RxSwift
import SDWebImage
import UIKit
import Unio


class HotPepperAPITypeMock: HotPepperAPIType {
    init() { }


    private(set) var searchCallCount = 0
    var searchHandler: (([String: Any]) -> (Single<HotPepperResponse>))?
    func search(keyValue: [String: Any]) -> Single<HotPepperResponse> {
        searchCallCount += 1
        if let searchHandler = searchHandler {
            return searchHandler(keyValue)
        }
        fatalError("searchHandler returns can't have a default value thus its handler must be set")
    }
}

class RealmManagerTypeMock: RealmManagerType {
    init() { }


    private(set) var addEntityCallCount = 0
    var addEntityHandler: ((Any, @escaping (RealmStatus) -> Void) -> ())?
    func addEntity<T: Object>(object: T, completion: @escaping (RealmStatus) -> Void)  {
        addEntityCallCount += 1
        if let addEntityHandler = addEntityHandler {
            addEntityHandler(object, completion)
        }
        
    }

    private(set) var deleteOneObjectCallCount = 0
    var deleteOneObjectHandler: ((Any, String, @escaping (RealmStatus) -> Void) -> ())?
    func deleteOneObject<T: Object>(type: T.Type, name: String, completion: @escaping (RealmStatus) -> Void)  {
        deleteOneObjectCallCount += 1
        if let deleteOneObjectHandler = deleteOneObjectHandler {
            deleteOneObjectHandler(type, name, completion)
        }
        
    }

    private(set) var deleteEntityCallCount = 0
    var deleteEntityHandler: ((Any) -> ())?
    func deleteEntity<T: Object>(object: T)  {
        deleteEntityCallCount += 1
        if let deleteEntityHandler = deleteEntityHandler {
            deleteEntityHandler(object)
        }
        
    }

    private(set) var deleteObjectCallCount = 0
    var deleteObjectHandler: ((Any) -> ())?
    func deleteObject<T: Object>(type: T.Type)  {
        deleteObjectCallCount += 1
        if let deleteObjectHandler = deleteObjectHandler {
            deleteObjectHandler(type)
        }
        
    }

    private(set) var getEntityListCallCount = 0
    var getEntityListHandler: ((Any) -> (Any))?
    func getEntityList<T: Object>(type: T.Type) -> Array<T> {
        getEntityListCallCount += 1
        if let getEntityListHandler = getEntityListHandler {
            return getEntityListHandler(type) as! Array<T>
        }
        return Array<T>()
    }
}

class HotPepperRepositoryTypeMock: HotPepperRepositoryType {
    init() { }


    private(set) var searchCallCount = 0
    var searchHandler: (([String: Any]) -> (Single<HotPepperResponse>))?
    func search(keyValue: [String: Any]) -> Single<HotPepperResponse> {
        searchCallCount += 1
        if let searchHandler = searchHandler {
            return searchHandler(keyValue)
        }
        fatalError("searchHandler returns can't have a default value thus its handler must be set")
    }

    private(set) var addEntityCallCount = 0
    var addEntityHandler: ((Any, @escaping (RealmStatus) -> Void) -> ())?
    func addEntity<T: Object>(object: T, completion: @escaping (RealmStatus) -> Void)  {
        addEntityCallCount += 1
        if let addEntityHandler = addEntityHandler {
            addEntityHandler(object, completion)
        }
        
    }

    private(set) var deleteOneObjectCallCount = 0
    var deleteOneObjectHandler: ((Any, String, @escaping (RealmStatus) -> Void) -> ())?
    func deleteOneObject<T: Object>(type: T.Type, name: String, completion: @escaping (RealmStatus) -> Void)  {
        deleteOneObjectCallCount += 1
        if let deleteOneObjectHandler = deleteOneObjectHandler {
            deleteOneObjectHandler(type, name, completion)
        }
        
    }

    private(set) var deleteEntityCallCount = 0
    var deleteEntityHandler: ((Any) -> ())?
    func deleteEntity<T: Object>(object: T)  {
        deleteEntityCallCount += 1
        if let deleteEntityHandler = deleteEntityHandler {
            deleteEntityHandler(object)
        }
        
    }

    private(set) var deleteObjectCallCount = 0
    var deleteObjectHandler: ((Any) -> ())?
    func deleteObject<T: Object>(type: T.Type)  {
        deleteObjectCallCount += 1
        if let deleteObjectHandler = deleteObjectHandler {
            deleteObjectHandler(type)
        }
        
    }

    private(set) var getEntityListCallCount = 0
    var getEntityListHandler: ((Any) -> (Any))?
    func getEntityList<T: Object>(type: T.Type) -> Array<T> {
        getEntityListCallCount += 1
        if let getEntityListHandler = getEntityListHandler {
            return getEntityListHandler(type) as! Array<T>
        }
        return Array<T>()
    }
}

