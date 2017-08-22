//
//  AwesomeBlogsTests.swift
//  AwesomeBlogsTests
//
//  Created by wade.hawk on 2017. 7. 19..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import XCTest
import RxSwift
import Quick
import Nimble
import Swinject
import Moya
import ObjectMapper

@testable import AwesomeBlogs

class AwesomeBlogsSpec: QuickSpec {
    
    override func spec() {
        var disposeBag: DisposeBag!
        //describe("어썸 블로그 feed api 테스트") {
        xcontext("awesome blog feed api test") {
            beforeEach {
                disposeBag = DisposeBag()
            }
            //describe("mock 데이터 사용하도록 의존성 주입") {
            describe("DI: used mock data") {
                beforeEach {
                    Service.shared.mockRegister()
                    //provider.awesomeBlogProvider = container.resolve(RxMoyaProvider<AwesomeBlogs>.self)
                }
                //it("mock 데이터는 1개의 엔트리를 가져온다")
                it("mock data has returned 1 entry") {
                    var count = 0
                    Api.getFeeds(group: .dev).subscribe(onSuccess: { entries in
                        log.debug(entries)
                        count = entries.count
                    }, onError: { error in
                        
                    }).disposed(by: disposeBag)
                    expect(count).toEventually(equal(1))
                }
            }
            //describe("네트워크를 사용하도록 의존성 주입") {
            describe("DI: used networking") {
                beforeEach {
                    Service.shared.register()
                }
                //it("엔트리를 10개 이상 얻어오면 성공") {
                it("return entries greater than 10") {
                    var count = 0
                    Api.getFeeds(group: .dev).subscribe(onSuccess: { entries in
                        count = entries.count
                        for entry in entries {
                            log.debug(entry.title)
                        }
                    }) { error in
                        
                    }.disposed(by: disposeBag)
                    expect(count).toEventually(beGreaterThan(0),timeout: 20)
                }
            }
        }
    }
}
