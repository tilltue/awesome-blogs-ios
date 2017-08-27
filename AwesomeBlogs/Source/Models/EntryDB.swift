//
//  EntryDB.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 27..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class EntryDB: Object {
    dynamic var title: String = ""
    dynamic var author: String = ""
    dynamic var link: String = ""
    dynamic var updatedAt: Double = 0
    dynamic var summary: String = ""
    dynamic var removeHTMLSummary: String = ""
    dynamic var compoundKey: String = ""
    
    override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    convenience init(group: AwesomeBlogs.Group, json: JSON) {
        self.init()
        self.title = json["title"].stringValue
        self.author = json["author"].stringValue
        self.link = json["link"].stringValue
        self.updatedAt = DateAtTransform().transformFromJSON(json["updated_at"].string)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        self.summary = json["summary"].stringValue
        self.removeHTMLSummary = self.summary.removeHTMLTags
        self.compoundKey = group.rawValue + self.link
    }
}
