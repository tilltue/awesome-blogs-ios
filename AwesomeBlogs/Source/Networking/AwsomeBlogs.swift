//
//  AwsomeBlogs.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 27..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation

enum AwesomeBlogs {
    enum Group: String {
        case all
        case dev
        case company
        case insightful
        var title: String {
            switch self {
            case .all:
                return "ALL".localized
            case .dev:
                return "DEVELOPER".localized
            case .company:
                return "TECH COMPANY".localized
            case .insightful:
                return "INSIGHTFUL".localized
            }
        }
    }
    static let groups:[AwesomeBlogs.Group] = [.all,.dev,.company,.insightful]
}
