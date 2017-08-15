//
//  Bundle+Extension.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 15..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Bundle {
    class func jsonData(name: String) -> Data {
        guard let path = self.main.path(forResource: name, ofType: "json") else { return Data() }
        do {
            let data = try Data(contentsOf: path.fileurl)
            return data
        }catch {
            return Data()
        }
    }
    class func swiftyJsonData(name: String) -> JSON {
        guard let path = self.main.path(forResource: name, ofType: "json") else { return JSON([:]) }
        do {
            let data = try Data(contentsOf: path.fileurl)
            return JSON(data: data)
        }catch {
            return JSON([:])
        }
    }
}
