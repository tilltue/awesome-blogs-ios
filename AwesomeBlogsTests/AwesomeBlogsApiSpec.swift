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
        //describe("") {
        context("get awesome blog feed all group") {
            beforeEach {
                disposeBag = DisposeBag()
            }
            //describe("응답에 빈데이터를 반환하도록 한 feeds api 테스트") {
            describe("test empty response data") {
                var container: Container!
                //var provider: RxMoyaProvider<AwesomeBlogs>!
                beforeEach {
                    container = Container()
                    container.register(RxMoyaProvider<AwesomeBlogs>.self){ _ in RxMoyaProvider<AwesomeBlogs>(stubClosure: MoyaProvider.immediatelyStub) }
                    provider.awesomeBlogProvider = container.resolve(RxMoyaProvider<AwesomeBlogs>.self)
                }
                //빈 데이터에서는 모델을 만들지 못하며 error 이벤트가 발생한다.
                it("failed to make model at empty data") {
                    var count = 0
//                    provider.singleRequest(.feeds(group: AwesomeBlogs.Group.dev)).map{ try Mapper<Entry>().mapArray(JSONObject: $0["entries"].rawValue) }.subscribe(onSuccess: { entries in
                    Api.getFeeds(group: .dev).subscribe(onSuccess: { entries in
                        print(entries)
                        count = entries.count
                    }, onError: { error in
                        
                    }).addDisposableTo(disposeBag)
                    expect(count).toEventually(equal(1))
                }
            }
            //describe("실제 feeds api 테스트") {
            xdescribe("test networking api") {
                //it("") {
                it("return entries") {
                    var count = 0
                    Api.getFeeds(group: .dev).subscribe(onSuccess: { entries in
                        count = entries.count
                        for entry in entries {
                            print(entry.title)
                        }
                    }) { error in
                        
                    }.addDisposableTo(disposeBag)
                    expect(count).toEventually(beGreaterThan(0),timeout: 20)
                }
            }
        }
    }
}
