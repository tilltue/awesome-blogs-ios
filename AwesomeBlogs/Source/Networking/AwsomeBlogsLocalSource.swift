//
//  AwsomeBlogsLocalSource.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 27..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import SwiftyJSON

enum AwesomeBlogsLocalSource {
    static func getFeeds(group: AwesomeBlogs.Group) -> Observable<Feed> {
        return Observable.deferred { _ -> Observable<Feed> in
            if let feed = RealmAPI<Feed>().getObject(filter: "group == '\(group.rawValue)'") {
                return Observable.just(feed)
            }else {
                return Observable.empty()
            }
        }.subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    static func saveFeeds(group: AwesomeBlogs.Group, json: JSON) {
        guard let realm = try? Realm() else { return }
        let realmApi = RealmAPI<Feed>()
        realmApi.deleteMapper = { $0.group == group.rawValue }
        realmApi.cascadeDelete = { object in
//            log.verbose("delete cascade\(object.entries.count)")
            try? realm.write {
                realm.delete(object.entries)
            }
        }
        realmApi.delete()
        let feed = Feed(group: group, json: json)
//        log.verbose("save count\(json["entries"].arrayValue.count)")
        for entry in json["entries"].arrayValue {
            let object = EntryDB(group: group, json: entry)
            try? realm.write {
                realm.add(object, update: true)
            }
            feed.entries.append(object)
        }
        try? realm.write {
            realm.add(feed, update: true)
        }
    }
}
