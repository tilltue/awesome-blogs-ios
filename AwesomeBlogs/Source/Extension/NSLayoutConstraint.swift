//
//  NSLayoutConstraint.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 16..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    @IBInspectable var preciseConstant: Int {
        get {
            return Int(constant * UIScreen.main.scale)
        }
        set {
            constant = CGFloat(newValue) / UIScreen.main.scale
        }
    }
}
