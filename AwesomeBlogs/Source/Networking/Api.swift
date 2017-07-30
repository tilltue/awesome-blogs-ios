//
//  Api.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 3..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import Swinject

enum Api {
    static func getFeeds(group: AwesomeBlogs.Group) -> Single<[Entry]> {
        return Service.shared.container
            .resolve(RxMoyaProvider<AwesomeBlogs>.self)!.singleRequest(.feeds(group: group)).map{ try Mapper<Entry>().mapArray(JSONObject: $0["entries"].rawValue) }
    }
}
