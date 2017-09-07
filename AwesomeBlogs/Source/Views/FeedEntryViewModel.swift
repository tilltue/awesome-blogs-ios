//
//  FeedEntryViewModel.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 9. 7..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation

struct FeedEntryViewModel {
    var title: String
    var link: String
    var removeHTMLSummary: String
    var summary: String
    var author: String
    var updatedAt: Date
    init(entry: Entry) {
        self.title = entry.title
        self.link = entry.link
        self.summary = entry.summary
        self.removeHTMLSummary = entry.removeHTMLSummary
        self.author = entry.author
        self.updatedAt = entry.updatedAt
    }
}
