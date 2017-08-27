//
//  FileManager+Extension.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 27..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit

extension FileManager {
    class func documentsDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    class func cachesDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    class func saveImage(name: String, image: UIImage) {
        let path = cachesDir()
        let data = UIImagePNGRepresentation(image)
        let url = URL(fileURLWithPath: "\(path)/\(name)")
        try? data?.write(to: url)
    }
}
