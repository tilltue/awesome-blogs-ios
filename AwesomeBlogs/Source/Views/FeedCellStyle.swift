//
//  FeedCellStyle.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 9. 7..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import GameplayKit

enum FeedCellStyle {
    case tableCell
    case rectangle
    case circle
    case diagonal
    case table
    var cellIdentifier: String {
        switch self {
        case .rectangle:
            return "BlogFeedCell_Rectangle"
        case .circle:
            return "BlogFeedCell_Circle"
        case .diagonal:
            return "BlogFeedCell_Diagonal"
        case .table:
            return "BlogFeedCell_Table"
        case .tableCell:
            return "BlogFeedCell_TableCell"
        }
    }
    var randomFlatColorCode: Int {
        let colorCodes = [0x6854cb,
                      0x6fadac,
                      0x36465d,
                      0x54A8E1,
                      0x333333,
                      0x555B5B,
                      0x0092A7,
                      0x2C9D91,
                      0x7153B7,
                      0x476DB3,
                      0x494389,
                      0x4F6A72,
                      0x636B7B,
                      0x738080,
                      0x8E8474,
                      0x828C90,
                      0x84898E,
                      0xA5B1B7,
                      0xBBAD9B,
                      0xE4615E,
                      0x1ABC9C,
                      0x2ECC71,
                      0xF08179]
        let randomBound = colorCodes.count
        let index = GKRandomSource.sharedRandom().nextInt(upperBound: randomBound)
        return colorCodes[index]
    }
}
