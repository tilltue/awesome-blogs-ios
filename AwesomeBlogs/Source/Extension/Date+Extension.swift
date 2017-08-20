//
//  Date+Extension.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 20..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import SwiftDate

extension Date {
    static public func == (lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == .orderedSame
    }
    static public func < (lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == .orderedAscending
    }
    static public func > (lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == .orderedDescending
    }
    func colloquial() -> String {
        return (try? self.colloquial(to: Date()).colloquial) ?? ""
    }
}
