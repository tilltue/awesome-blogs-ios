//
//  Service.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 31..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import Moya
import Swinject
import ReactorKit

struct Service {
    static let shared = Service()
    let container = Container()
    
    private init() {
//        mockRegister()
        register()
        reactorRegister()
    }
    
    func register() {
        let version =
            (Bundle.main.infoDictionary?["CFBundleShortVersionString"]) as? String ?? "1.0"
        let endpointClosure = { (target: AwesomeBlogsRemoteSource) -> Endpoint<AwesomeBlogsRemoteSource> in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint.adding(newHTTPHeaderFields: ["User-Agent": "awesome-blogs-ios/\(version)"])
        }
        let plugins = [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)]
        self.container.register(RxMoyaProvider<AwesomeBlogsRemoteSource>.self){ _ in RxMoyaProvider<AwesomeBlogsRemoteSource>(endpointClosure: endpointClosure,plugins: plugins) }
    }
    
    func mockRegister() {
        self.container.register(RxMoyaProvider<AwesomeBlogsRemoteSource>.self){ _ in RxMoyaProvider<AwesomeBlogsRemoteSource>(stubClosure: MoyaProvider.immediatelyStub) }
    }
    
    func reactorRegister() {
        self.container.register(BlogsFeedReactor.self) { _ in BlogsFeedReactor() }
        self.container.register(MainSideMenuReactor.self) { _ in MainSideMenuReactor() }
    }
}

