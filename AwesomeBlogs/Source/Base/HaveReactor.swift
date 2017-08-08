//
//  HaveReactor.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 8..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import ReactorKit
import Swinject

protocol HaveReactor: class {
    associatedtype ReactorType
    var reactor: ReactorType { get set }
}

extension HaveReactor {
    func resolve(container: Container = Service.shared.container) -> ReactorType {
        return container.resolve(ReactorType.self)!
    }
}
