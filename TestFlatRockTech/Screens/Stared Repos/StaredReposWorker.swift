//
//  StaredReposWorker.swift
//  TestFlatRockTech
//

import UIKit
import RealmSwift

class StaredReposWorker {
    
    var realm: Realm = try! Realm()
    
    
    func storeData(data: UserRepoViewModel) {
        
        try! realm.write {
            realm.add(data.toDB())
        }
    }
    
    func getData() -> [UserRepoViewModel] {
        let objects = realm.objects(UserRepoDB.self)
        var array = [UserRepoDB]()
        for data in objects {
            array.append(data)
        }
        let userModels = array.compactMap({$0.toUserModel()})
        return  userModels
    }
}
