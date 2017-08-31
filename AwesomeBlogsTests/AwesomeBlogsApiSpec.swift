//
//  AwesomeBlogsApiSpec.swift
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

class AwesomeBlogsApiSpec: QuickSpec {
    
    override func spec() {
        var disposeBag: DisposeBag!
        //describe("어썸 블로그 feed api 테스트") {
        context("awesome blog feed api test") {
            beforeEach {
                disposeBag = DisposeBag()
            }
            //describe("mock 데이터 사용하도록 의존성 주입") {
            describe("DI: used mock data") {
                beforeEach {
                    Service.shared.mockRegister()
                    Service.shared.deleteFeedCache()
                }
                //it("mock 데이터는 103개의 엔트리를 가져온다")
                it("mock data has returned 103 entry") {
                    var count = 0
                    Api.getFeeds(group: .dev).subscribe(onSuccess: { entries in
//                        log.debug(entries)
                        count = entries.count
                    }).disposed(by: disposeBag)
                    expect(count).toEventually(equal(103), timeout: 20)
                }
            }
            //describe("네트워크를 사용하도록 의존성 주입") {
            describe("DI: used networking") {
                beforeEach {
                    Service.shared.register()
                    Service.shared.deleteFeedCache()
                }
                //it("엔트리를 10개 이상 얻어오면 성공") {
                it("return entries greater than 10") {
                    var count = 0
                    Api.getFeeds(group: .dev).subscribe(onSuccess: { entries in
                        count = entries.count
                    }).disposed(by: disposeBag)
                    expect(count).toEventually(beGreaterThan(0),timeout: 20)
                }
            }
        }
    }
}
