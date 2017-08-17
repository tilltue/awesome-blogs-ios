//
//  BlogFeedCell_Circle.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 18..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit

class BlogFeedCell_Circle: BlogFeedCell {
    @IBOutlet var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.circleView.cornerRadius = (UIScreen.main.bounds.width - 80) / 2
    }
}
