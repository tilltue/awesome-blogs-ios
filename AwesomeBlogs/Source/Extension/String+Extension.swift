//
//  String+Extension.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 15..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation

extension String {
    var url: URL? {
        get {
            if self.isEmpty { return nil }
            return URL(string: self)!
        }
    }
    var fileurl: URL {
        get {
            return URL(fileURLWithPath: self)
        }
    }
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    var removeHTMLTags: String {
        var ret = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        ret = ret.replacingOccurrences(of: "&[^;]+;", with: "", options: String.CompareOptions.regularExpression, range: nil)
        ret = ret.replacingOccurrences(of: "\n", with: "")
        if ret.characters.count > 300 {
            let index = ret.index(ret.startIndex, offsetBy: 300)
            return ret.substring(to: index)
        }else {
            return ret
        }
    }
}
