//
//  RealmConnectable.swift
//  TestFlatRockTech
//
//  Created by Sos Avetyan on 5/20/22.
//

import Foundation
import RealmSwift

protocol RealmConnectable {
    var config: Realm.Configuration { get }
}

extension RealmConnectable {
    func getRealm() throws -> Realm {
        let realmConfig = config

        
        guard realmConfig.encryptionKey == nil || realmConfig.encryptionKey?.count == Constant.Realm.encryptionKeySize else {
            throw RealmError.emptyEncryptionKey
        }
        return try Realm(configuration: realmConfig)
    }

    /**
     Private saving method
     - Parameter data: Object which should be saved
     */
    func save(object: Object) throws {
        do {
            let realm = try getRealm()
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch Realm.Error.schemaMismatch {
            let error = RealmError.realmSchemaMismatch
            throw error
        } catch {
            throw error
        }
    }

    /**
     Private saving method
     - Parameter data: Object which should be saved
     */
    func save(objects: [Object]) throws {
        do {
            let realm = try getRealm()
            try realm.write {
                realm.add(objects, update: .modified)
            }
        } catch Realm.Error.schemaMismatch {
            let error = RealmError.realmSchemaMismatch
            if let sourceClass = objects.first {
                let sourceClassName = String(describing: sourceClass.self)
                print("Somthing went wrong", sourceClassName)
            }
            throw error
        } catch {
            throw error
        }
    }

    /**
     Update already existing object or add new object
     - Parameter data: New object data
     */
    func update<T: IdentifiableObject>(data: T) {
        do {
            let realm = try getRealm()
            try realm.write {
                realm.add(data, update: .modified)
            }
        } catch {
        }
    }

    /**
     Get object from DB with primary key
     - Parameter type: Object type
     - Parameter id: primary key
     - Returns: Optional object
     */
    func getObject<T: Object>(_ type: T.Type, id: Any) -> T? {
        do {
            let object = try getRealm().object(ofType: T.self, forPrimaryKey: id)
            return object
        } catch {
            return nil
        }
    }

    /**
     Get all objects from Realm
     - Parameter object: Object type to fetch from DB
     - Returns: optional array of objects
     */
    func getAll<T: Object>(_ object: T.Type) throws -> [T] {
        do {
            let realm = try getRealm()
            let objects = realm.objects(T.self)
            return objects.map { $0 }
        } catch {
            throw error
        }
    }

    /**
     Get all objects from Realm as Realm Results seguence.
     - Parameter object: Object type to fetch from DB
     - Returns: optional array of objects
     */
    func getAllAsResults<T: Object>(_ object: T.Type) throws -> Results<T> {
        do {
            let realm = try getRealm()
            return realm.objects(T.self)
        } catch {
            throw error
        }
    }

    /**
     Remove object from realm.
     - Parameter type: Object type
     - Parameter id: primary key
     - Returns: Bool representing the success of the action.
     */
    @discardableResult
    func removeIfExist<T: Object>(_ object: T, id: Any) -> Bool {
        guard let object = getObject(T.self, id: id) else {
            return false
        }

        do {
            let realm = try getRealm()
            try realm.write {
                realm.delete(object)
            }
            return true
        } catch {
            return false
        }
    }

    /**
     Remove all the entries from Realm
     - Parameter object: Object type wich should be removed
     */
    func removeAll<T: Object>(_ object: T.Type) {
        do {
            let realm = try getRealm()
            let objects = realm.objects(T.self)
            try realm.write {
                realm.delete(objects)
            }
        } catch {
        }
    }

    /**
     Remove the objects from realm
     - Parameter objects: List of objects to be removed
     */
    func remove<T: Object>(_ objects: [T]) {
        do {
            let realm = try getRealm()
            try realm.write {
                realm.delete(objects)
            }
        } catch {
        }
    }

    /**
     Remove the object from realm
     - Parameter object: Object to be removed
     */
    func remove<T: Object>(object: T) {
        do {
            let realm = try getRealm()
            try realm.write {
                realm.delete(object)
            }
        } catch {
        }
    }
}
