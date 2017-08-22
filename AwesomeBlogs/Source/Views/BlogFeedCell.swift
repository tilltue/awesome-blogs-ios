//
//  BlogFeedCell.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 9..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit
import KRWordWrapLabel

class BlogFeedCell: BaseUITableViewCell {
    @IBOutlet var titleLabel: KRWordWrapLabel?
    @IBOutlet var authorLabel: UILabel?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet var authorDateLabel: UILabel?
    @IBOutlet var summaryLabel: KRWordWrapLabel?
}
