import Foundation
import RealmSwift
import UIKit

protocol RealmServiceProtocol: AnyObject{
    func create<T: Object>(_ object: T)
    func delete<T: Object>(_ object: T)
    func get<T: Object>(_ object: T.Type) -> Results<T>?
}


class RealmService: RealmServiceProtocol{
    
    static let shared = RealmService()
    var realm: Realm!
    
    init(realm: Realm){
        self.realm = realm
    }
    
    convenience init(test: Bool = false){
        if test{
            let x = Realm.Configuration(inMemoryIdentifier: "GameLibraryTest")
            self.init(realm: try! Realm(configuration: x))
        }else{
            self.init(realm: try! Realm())
        }
        
    }
    
    
    func create<T: Object>(_ object: T){
        do{
            try realm.write{
                realm.add(object)
            }
        }catch{
            print("error")
        }
    }
    
    func delete<T: Object>(_ object: T){
        do{
            try realm.write{
                realm.delete(object)
            }
        }catch{
            
        }
    }
    
    func get<T: Object>(_ object: T.Type) -> Results<T>?{
        return realm.objects(T.self).count == 0 ? nil : realm.objects(T.self)
    }
}

