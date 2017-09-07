//
//  Entry.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 10..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
import RealmSwift

enum EntryError: Error {
    case unknown
}

struct Entry: Equatable,ImmutableMappable {
    let title: String
    let author: String
    let link: String
    let updatedAt: Date
    let summary: String
    let removeHTMLSummary: String
    //let createdAt: String
    
    init(map: Map) throws {
        self.title = try map.value("title", using: RemoveHTMLAtTransform())
        self.author = try map.value("author")
        self.link = try map.value("link")
        self.updatedAt = try map.value("updated_at", using: DateAtTransform())
        self.summary = try map.value("summary")
        self.removeHTMLSummary = self.summary.removeHTMLTags
    }
    
    init?(entryDB: EntryDB) {
        self.title = entryDB.title
        self.author = entryDB.author
        self.link = entryDB.link
        self.updatedAt = Date(timeIntervalSince1970: entryDB.updatedAt)
        self.summary = entryDB.summary
        self.removeHTMLSummary = entryDB.removeHTMLSummary
    }
    
    static func ==(lhs: Entry,rhs: Entry) -> Bool {
        return lhs.link == rhs.link
    }
}
