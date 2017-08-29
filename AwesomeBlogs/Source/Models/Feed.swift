//
//  Feed.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 27..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Feed: Object {
    dynamic var group: String = ""
    dynamic var title: String = ""
    dynamic var desc: String = ""
    dynamic var updatedAt: Double = 0
    dynamic var expiredTime: Double = 0
    
    let entries = List<EntryDB>()
    
    var isExpired: Bool {
        return Date(timeIntervalSince1970: expiredTime).timeIntervalSinceNow < -1800
    }
    
    override static func primaryKey() -> String? {
        return "group"
    }
    
    convenience init(group: AwesomeBlogs.Group, json: JSON) {
        self.init()
        self.group = group.rawValue
        self.title = json["title"].stringValue
        self.desc = json["description"].stringValue
        self.updatedAt = DateAtTransform().transformFromJSON(json["updated_at"].string)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        self.expiredTime = Date().timeIntervalSince1970
    }
}
