//
//  UIColor+Extension.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 25..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha:alpha)
    }
}

class CustomBannerColors: BannerColorsProtocol {
    func color(for style: BannerStyle) -> UIColor {
        switch style {
        default:
            return UIColor(hex: 0x333333)
        }
    }
}
