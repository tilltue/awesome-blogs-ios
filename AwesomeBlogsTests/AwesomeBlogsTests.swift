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
import Moya
import ObjectMapper

@testable import AwesomeBlogs

class AwesomeBlogsSpec: QuickSpec {
    
    override func spec() {
        
        var disposeBag: DisposeBag!
        //describe("") {
        context("get awesome blog feed all group") {
            beforeEach {
                disposeBag = DisposeBag()
            }
            //describe("응답에 빈데이터를 반환하도록 한 feeds api 테스트") {
            describe("test empty response data") {
                var provider: RxMoyaProvider<AwesomeBlogs>!
                beforeEach {
                    provider = RxMoyaProvider<AwesomeBlogs>(stubClosure: MoyaProvider.immediatelyStub)
                }
                //빈 데이터에서는 모델을 만들지 못하며 error 이벤트가 발생한다.
                it("failed to make model at empty data") {
                    var count = 0
                    var errorEvent: Swift.Error? = nil
                    provider.singleRequest(.feeds(group: AwesomeBlogs.Group.all)).map{ try Mapper<Entry>().mapArray(JSONObject: $0["entries"].rawValue) }.subscribe(onSuccess: { entries in
                        count = entries.count
                    }, onError: { error in
                        errorEvent = error
                    }).addDisposableTo(disposeBag)
                    expect(count).toEventually(equal(0))
                    expect(errorEvent).toEventuallyNot(beNil())
                }
            }
            //describe("실제 feeds api 테스트") {
            describe("test networking api") {
                //it("") {
                it("return entries") {
                    var count = 0
                    Api.getFeeds(group: .all).subscribe(onSuccess: { entries in
                        count = entries.count
                    }) { error in
                        
                    }.addDisposableTo(disposeBag)
                    expect(count).toEventuallyNot(equal(0),timeout: 10)
                }
            }
        }
    }
}
