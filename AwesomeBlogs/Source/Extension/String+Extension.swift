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
    var removeNewLine: String {
        var ret = self.replacingOccurrences(of: "\n", with: "")
        var original = self.replacingOccurrences(of: "\n", with: "")
        ret = ret.lowercased()
        func remove(tag: String) {
            repeat {
                if let bodyStartRange = ret.range(of: "<\(tag)"), let bodyEndRange = ret.range(of: "/\(tag)>") {
                    let start = ret.index(bodyStartRange.lowerBound, offsetBy: 0)
                    let end = ret.index(bodyEndRange.upperBound, offsetBy: 0)
                    let range1 = ret.startIndex..<start
                    let range2 = end..<ret.endIndex
                    ret = ret.substring(with: range1) + ret.substring(with: range2)
                    original = original.substring(with: range1) + original.substring(with: range2)
                }
            }while(ret.range(of: "<\(tag)") != nil)
        }
        if let htmlRange = ret.range(of: "<html") {
            let end = ret.index(htmlRange.lowerBound, offsetBy: 0)
            let range1 = end..<ret.endIndex
            ret = ret.substring(with: range1)
            original = original.substring(with: range1)
        }
        remove(tag: "script")
        remove(tag: "pre")
        remove(tag: "iframe")
//        let entityMap = [
//            "&": "&amp;",
//            "<": "&lt;",
//            ">": "&gt;",
//            "\"": "&quot;",
//            "'": "&#39;",
//            "/": "&#x2F;",
//            "`": "&#x60;",
//            "=": "&#x3D;"
//        ]
//        for (key,value) in entityMap {
//            original = original.replacingOccurrences(of: key, with: value)
//        }
        return original.replacingOccurrences(of: "\"", with: "'")
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
