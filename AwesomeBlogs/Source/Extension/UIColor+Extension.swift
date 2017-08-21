//
//  UIColor+Extension.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 25..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha:alpha)
    }
    class var randomFlatColor: UIColor {
        let colors = [UIColor(hex: 0x6854cb),
                      UIColor(hex: 0x6fadac),
                      UIColor(hex: 0x36465d),
                      UIColor(hex: 0x54A8E1),
                      UIColor(hex: 0x333333),
                      UIColor(hex: 0x555B5B),
                      UIColor(hex: 0x0092A7),
                      UIColor(hex: 0x2C9D91),
                      UIColor(hex: 0x7153B7),
                      UIColor(hex: 0x476DB3),
                      UIColor(hex: 0x494389),
                      UIColor(hex: 0x4F6A72),
                      UIColor(hex: 0x636B7B),
                      UIColor(hex: 0x738080),
                      UIColor(hex: 0x8E8474),
                      UIColor(hex: 0x828C90),
                      UIColor(hex: 0x84898E),
                      UIColor(hex: 0xA5B1B7),
                      UIColor(hex: 0xBBAD9B),
                      UIColor(hex: 0xE4615E),
                      UIColor(hex: 0x1ABC9C),
                      UIColor(hex: 0x2ECC71),
                      UIColor(hex: 0xF08179)]
        let randomBound = colors.count
        let index = GKRandomSource.sharedRandom().nextInt(upperBound: randomBound)
        return colors[index]
    }
}
