//
//  RealmAPI.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 27..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class RealmAPI<O:Object> {
    typealias DeleteMapperType = (O) -> Bool
    typealias SaveMapperType = (Realm,String,JSON) -> O
    typealias ProgressType = (Float) -> Void
    typealias CascadeDelete = (O) -> Void
    let realm = try? Realm()
    var deleteMapper: DeleteMapperType?
    var cascadeDelete: CascadeDelete?
    var saveMapper: SaveMapperType?
    var progressBlock: ProgressType?
    
    func progress(count: inout Int, total: Int) {
        guard let progressBlock = self.progressBlock else { return }
        count+=1
        var result = Float(count) / Float(total)
        if result == 1 { result = 0.99 }
        progressBlock(result)
    }
    func deleteAll(filter: String) {
        guard let realm = self.realm else { return }
        let objects = realm.objects(O.self).filter(filter)
        try? realm.write {
            realm.delete(objects)
        }
    }
    func delete() {
        guard let realm = self.realm, let deleteMapper = self.deleteMapper else { return }
        let objects = realm.objects(O.self)
        var deleteObjects = [O]()
        var count = 0
        for object in objects {
            if deleteMapper(object) {
                deleteObjects.append(object)
                if let cascadeDelete = self.cascadeDelete {
                    cascadeDelete(object)
                }
            }
            progress(count: &count, total: objects.count)
        }
        try? realm.write {
            realm.delete(deleteObjects)
        }
    }
    func save(dictionary: [String:JSON]) -> [O]  {
        guard let realm = self.realm, let saveMapper = self.saveMapper else { return [] }
        var saveObjects = [O]()
        var count = 0
        for (key,json) in dictionary {
            let realmObject = saveMapper(realm,key,json)
            saveObjects.append(realmObject)
            progress(count: &count, total: dictionary.keys.count)
        }
        
        try? realm.write {
            realm.add(saveObjects, update: true)
        }
        return saveObjects
    }
}

extension RealmAPI {
    func getObject(filter: String? = nil) -> O? {
        guard let realm = self.realm else { return nil }
        let objects = filter == nil ? realm.objects(O.self) : realm.objects(O.self).filter(filter!)
        return objects.map{ $0 as O }.first
    }
    func getObjects(filter: String? = nil) -> [O] {
        guard let realm = self.realm else { return [] }
        let objects = filter == nil ? realm.objects(O.self) : realm.objects(O.self).filter(filter!)
        return objects.map{ $0 as O }
    }
    func createAutoUnique() -> O? {
        guard  let realm = self.realm, let primaryKey = O.primaryKey() else {
            log.debug("createAutoUnique requires that \(O.self) implements primaryKey()")
            return nil
        }
        var id: String?
        var existing: O? = nil
        repeat {
            let uuid = UUID().uuidString
            id = uuid.components(separatedBy:"-").last ?? uuid
            existing = realm.object(ofType: O.self, forPrimaryKey: id)
        } while (existing != nil)
        let uniqObject = O()
        uniqObject.setValue(id, forKey: primaryKey)
        return uniqObject
    }
}
