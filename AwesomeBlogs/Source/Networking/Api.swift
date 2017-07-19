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
import SwiftyJSON
import ObjectMapper

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

extension RxMoyaProvider {
    func singleRequest(_ token: Target) -> Single<JSON> {
        return Single<JSON>.create { single in
            let cancellableToken = self.request(token) { result in
                switch result {
                case let .success(response):
                    single(.success(JSON(data: response.data)))
                case let .failure(error):
                    single(.error(error))
                }
            }
            return Disposables.create {
                cancellableToken.cancel()
            }
        }
    }
}

enum Api {
    static func getFeeds(group: AwesomeBlogs.Group) -> Single<[Entry]> {
        let awesomeBlogProvider = RxMoyaProvider<AwesomeBlogs>(plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)])
        return awesomeBlogProvider.singleRequest(.feeds(group: group)).map{ try Mapper<Entry>().mapArray(JSONObject: $0["entries"].rawValue) }
    }
}
