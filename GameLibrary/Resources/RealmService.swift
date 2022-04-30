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
    var realm: Realm?
    
    init(realm: Realm){
        self.realm = realm
    }
    
    convenience init(test: Bool = false) {
        if test{
            let x = Realm.Configuration(inMemoryIdentifier: "GameLibraryTest")
            do {
                self.init(realm: try Realm(configuration: x))
            }catch {
                self.init()
            }
        }
        
        do{
            self.init(realm: try Realm())
        }catch{
            self.init()
        }
        
    }
    
    
    func create<T: Object>(_ object: T) {
        guard let realm = realm else {return }

        do{
            try realm.write{
                realm.add(object)
            }
        }catch{
            print("error")
        }
    }
    
    func delete<T: Object>(_ object: T) {
        guard let realm = realm else {return }
        do{
            try realm.write{
                realm.delete(object)
            }
        }catch{
            print("error")
        }
    }
    
    func get<T: Object>(_ object: T.Type) -> Results<T>? {
        guard let realm = realm else {return nil }

        return realm.objects(T.self).isEmpty ? nil : realm.objects(T.self)
    }
}

