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

struct Service {
    static let shared = Service()
    let container = Container()
    
    private init() {
        register()
    }
    
    func register() {
        let plugins = [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)]
        self.container.register(RxMoyaProvider<AwesomeBlogs>.self){ _ in RxMoyaProvider<AwesomeBlogs>(plugins: plugins) }
    }
    
    func mockRegister() {
        self.container.register(RxMoyaProvider<AwesomeBlogs>.self){ _ in RxMoyaProvider<AwesomeBlogs>(stubClosure: MoyaProvider.immediatelyStub) }
    }
}

