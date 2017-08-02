//
//  BlogsFeedSpec.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 25..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import XCTest
import RxSwift
import Quick
import Nimble
import Swinject
import Moya
import RxTest
//import ObjectMapper

@testable import AwesomeBlogs

class BlogsFeedSpec: QuickSpec {
    
    override func spec() {
        var disposeBag: DisposeBag!
        var reactor: BlogsFeedReactor!
        //context("블로그 피드 리엑터 테스트") {
        context("blog feed reactor test") {
            beforeEach {
                disposeBag = DisposeBag()
                reactor = BlogsFeedReactor()
                Service.shared.mockRegister()
            }
            //describe("load action -> loding -> loaded -> empty or have state") {
            describe("action -> state test") {
                it("get feed action") {
                    var events = [Recorded<Event<Int>>]()
                    let correctEvents = [
                        next(100, 0),
                        next(150, 1),
                        next(200, 1)
                    ]
                    var index = 0
                    let times = [100,150,200,250]
                    reactor.state.subscribe(onNext: { state in
                        events.append(next(times[index],state.entries.count))
                        index+=1
                        //print("state : \(state.isLoading) \(state.entries.count)")
                    }).addDisposableTo(disposeBag)
                    reactor.action.on(.next(.load(group: .dev)))
//                    XCTAssertEqual(events,correctEvents)
                    expect(events).toEventually(equal(correctEvents))
                    //expect(mutations).toEventually(equal([(true,0),(true,1),(false,1)]))
                    //expect(mutations).toEventually(equal([true,true,false]))
                }
            }
        }
        /*
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
                    provider.singleRequest(.feeds(group: AwesomeBlogs.Group.dev)).map{ try Mapper<Entry>().mapArray(JSONObject: $0["entries"].rawValue) }.subscribe(onSuccess: { entries in
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
                    expect(count).toEventuallyNot(equal(100),timeout: 10)
                }
            }
        }*/
    }
}
