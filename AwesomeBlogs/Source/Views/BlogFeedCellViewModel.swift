//
//  BlogFeedCellViewModel.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 18..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation

struct BlogFeedCellViewModel: RxTableCellViewModel {
    
    init(style: FeedCellStyle, entries: [Entry]) {
        self.style = style
        self.colorCode = style.randomFlatColorCode
        self.entryViewModels = entries.map{ FeedEntryViewModel(entry: $0) }
    }
    
    var style: FeedCellStyle
    var entryViewModels: [FeedEntryViewModel]
    var colorCode: Int
    var cellIdentifier: String {
        return self.style.cellIdentifier
    }
    var identity: String {
        return self.entryViewModels.first?.link ?? ""
    }

    static func ==(lhs: BlogFeedCellViewModel, rhs: BlogFeedCellViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }
}
