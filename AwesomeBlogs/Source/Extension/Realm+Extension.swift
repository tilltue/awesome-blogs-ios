//
//  Realm+Extension.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 27..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class ChangedObject: Object {
    let objectChange = PublishSubject<Void>()
    deinit {
        //log.verbose(type(of: self))
    }
}

class RealmString: Object {
    dynamic var stringValue = ""
    override class func primaryKey() -> String? {
        return "stringValue"
    }
    deinit {
        //log.verbose(type(of: self))
    }
}

extension Realm {
    class func realmMigration(){
        func schemaVersion() -> UInt64 {
            return 2
        }
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL = config.fileURL
        config.schemaVersion = schemaVersion()
        config.migrationBlock = { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
                //Nothing to do!
            }
        }
        Realm.Configuration.defaultConfiguration = config
    }
}
