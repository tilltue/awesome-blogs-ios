//
//  ObjectMapper+Extension.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 18..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import ObjectMapper

extension String {
    var dateAt: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
        return formatter.date(from: self)
    }
}

extension Date {
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
        return formatter.string(from: self)
    }
}

struct IntTransform: TransformType {
    typealias Object = Int
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Int? {
        guard let value = value as? String else { return nil }
        return Int(value)
    }
    
    func transformToJSON(_ value: Int?) -> String? {
        return value.flatMap(String.init(describing:))
    }
}

struct FloatTransform: TransformType {
    typealias Object = Float
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Float? {
        guard let value = value as? String else { return nil }
        return Float(value)
    }
    
    func transformToJSON(_ value: Float?) -> String? {
        return value.flatMap(String.init(describing:))
    }
}

struct DateAtTransform: TransformType {
    typealias Object = Date
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Date? {
        guard let value = value as? String else { return nil }
        return value.dateAt
    }
    
    func transformToJSON(_ value: Date?) -> String? {
        return value?.dateString
    }
}
