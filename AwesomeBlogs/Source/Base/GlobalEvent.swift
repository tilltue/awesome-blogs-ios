//
//  GlobalEvent.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 23..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RxSwift

struct GlobalEvent {
    static let shared = GlobalEvent()
    private init() {}
    
    let selectedEntry = PublishSubject<Entry>()
}
