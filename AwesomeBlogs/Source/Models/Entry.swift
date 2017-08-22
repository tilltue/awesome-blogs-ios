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

struct Entry: Equatable,ImmutableMappable {
    let title: String
    let author: String
    let link: URL
    let updatedAt: Date
    let summary: String
    let removeHTMLSummary: String
    //let createdAt: String
    
    init(map: Map) throws {
        self.title = try map.value("title", using: RemoveHTMLAtTransform())
        self.author = try map.value("author")
        self.link = try map.value("link", using: URLTransform())
        self.updatedAt = try map.value("updated_at", using: DateAtTransform())
        self.summary = try map.value("summary")
        self.removeHTMLSummary = self.summary.removeHTMLTags
    }
    
    static func ==(lhs: Entry,rhs: Entry) -> Bool {
        return lhs.link.absoluteString == rhs.link.absoluteString
    }
}
