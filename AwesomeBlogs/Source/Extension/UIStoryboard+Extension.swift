//
//  UIStoryboard+Extension.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 20..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    class func VC(name: String, bundle: Bundle? = nil, withIdentifier: String) -> UIViewController {
        let board = UIStoryboard(name: name, bundle: bundle)
        return board.instantiateViewController(withIdentifier: withIdentifier)
    }
}
