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
    @objc dynamic var title: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var updatedAt: Double = 0
    @objc dynamic var summary: String = ""
    @objc dynamic var removeHTMLSummary: String = ""
    @objc dynamic var compoundKey: String = ""
    
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
