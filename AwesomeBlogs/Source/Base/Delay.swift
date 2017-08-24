//
//  Delay.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 24..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation

enum DispatchLevel {
    case Main, UserInteractive, UserInitiated, Utility, Background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .Main:             return DispatchQueue.main
        case .UserInteractive:  return DispatchQueue.global(qos: .userInteractive)
        case .UserInitiated:    return DispatchQueue.global(qos: .userInitiated)
        case .Utility:          return DispatchQueue.global(qos: .utility)
        case .Background:       return DispatchQueue.global(qos: .background)
        }
    }
}

func delay(delay:Double, closure:@escaping ()->()) {
    DispatchLevel.Main.dispatchQueue.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

func backgroundDelay(delay:Double, closure:@escaping ()->()) {
    DispatchLevel.Background.dispatchQueue.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
