//
//  AwesomeBlogsRemoteSource.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 3..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import Moya

enum AwesomeBlogsRemoteSource {
    case feeds(group: AwesomeBlogs.Group)
    case read
}

extension AwesomeBlogsRemoteSource: TargetType {
    public var baseURL: URL { return URL(string: "https://awesome-blogs.petabytes.org")! }
    public var path: String {
        switch self {
        case .feeds(_):
            return "/feeds.json"
        case .read:
            return "/feeds/read.json"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .feeds(_):
            return .get
        case .read:
            return .post
        }
    }
    public var parameters: [String: Any]? {
        var parameters = [String: Any]()
        switch self {
        case .feeds(let group):
            parameters["group"] = group.rawValue
        case .read:
            return parameters
        }
        return parameters
    }
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var task: Task {
        return .request
    }
    public var validate: Bool {
        return true
    }
    public var sampleData: Data {
        switch self {
        case .feeds(let group):
            switch group {
            case .dev:
                return Bundle.jsonData(name: "MockDevBlogs")
            case .company:
                return Bundle.jsonData(name: "MockCompanyBlogs")
            default:
                return "{ \"entries\" : [{\"title\": \"mock title\", \"author\": \"mock author\", \"link\": \"mock link\", \"updated_at\": \"2017-07-26T00:01:00.000+09:00\", \"summary\" : \"mock summary\" }] }".data(using: String.Encoding.utf8)!
            }
        default:
            return Data()
        }
    }
}
