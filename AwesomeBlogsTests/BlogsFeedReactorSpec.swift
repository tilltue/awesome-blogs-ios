//
//  BlogsFeedReactorSpec.swift
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

struct FeedStateEvent: Equatable {
    var loading: Bool
    var entryCount: Int
    var useableViewModel: Bool
    init(loading: Bool, entryCount: Int, useableViewModel: Bool = false) {
        self.loading = loading
        self.entryCount = entryCount
        self.useableViewModel = useableViewModel
    }
    static func ==(lhs: FeedStateEvent, rhs: FeedStateEvent) -> Bool {
        return lhs.loading == rhs.loading && lhs.entryCount == rhs.entryCount && lhs.useableViewModel == rhs.useableViewModel
    }
}

class BlogsFeedReactorSpec: QuickSpec {
    
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
            //describe("액션을 전달하고 이벤트 스트림 결과를 비교") {
            describe("action -> event stream result") {
                //it("액션: 피드 로드") {
                it("action: feed load") {
                    var stateEvents = [Recorded<Event<FeedStateEvent>>]()
                    var index = 0
                    let times = [100,150,200,250]
                    reactor.state.map{ FeedStateEvent(loading: $0.isLoading, entryCount:$0.entries.count) }
                    .subscribe(onNext: { event in
                        stateEvents.append(next(times[index],event))
                        index+=1
                        log.debug("state : \(event.loading) \(event.entryCount)")
                    }).disposed(by: disposeBag)
                    reactor.action.on(.next(.load(group: .dev)))
                    expect(stateEvents).toEventually(equal([next(100, FeedStateEvent(loading: false, entryCount: 0)),
                                                            next(150, FeedStateEvent(loading: true, entryCount: 0)),
                                                            next(200, FeedStateEvent(loading: true, entryCount: 103)),
                                                            next(250, FeedStateEvent(loading: false, entryCount: 103))]))
                }
                it("action: feed load , feed refresh") {
                    var stateEvents = [Recorded<Event<FeedStateEvent>>]()
                    var index = 0
                    let times = [100,150,200,250,300,350,400]
                    reactor.state.map{ FeedStateEvent(loading: $0.isLoading, entryCount:$0.entries.count) }
                    .subscribe(onNext: { event in
                        stateEvents.append(next(times[index],event))
                        index+=1
                        log.debug("state : \(event.loading) \(event.entryCount)")
                    }).disposed(by: disposeBag)
                    reactor.action.on(.next(.load(group: .dev)))
                    reactor.action.on(.next(.refresh(group: .company)))
                    expect(stateEvents).toEventually(equal([next(100, FeedStateEvent(loading: false, entryCount: 0)),
                                                            next(150, FeedStateEvent(loading: true, entryCount: 0)),
                                                            next(200, FeedStateEvent(loading: true, entryCount: 103)),
                                                            next(250, FeedStateEvent(loading: false, entryCount: 103)),
                                                            next(300, FeedStateEvent(loading: true, entryCount: 103)),
                                                            next(350, FeedStateEvent(loading: true, entryCount: 35)),
                                                            next(400, FeedStateEvent(loading: false, entryCount: 35))]))
                }
                it("action: feed load -> usable view model") {
                    var stateEvents = [Recorded<Event<FeedStateEvent>>]()
                    var index = 0
                    let times = [100,150,200,250]
                    reactor.state.map{ state -> FeedStateEvent in
                        let viewModelEntryCount = state.viewModels.reduce(0, { (result, viewModel) -> Int in
                            return result + viewModel.cellType.entries.count
                        })
                        let useableViewModel = state.entries.count == viewModelEntryCount && viewModelEntryCount > 0
                        return FeedStateEvent(loading: state.isLoading, entryCount:state.entries.count, useableViewModel: useableViewModel)
                        }
                        .subscribe(onNext: { event in
                            stateEvents.append(next(times[index],event))
                            index+=1
                            log.debug("state : \(event.loading) \(event.entryCount) \(event.useableViewModel)")
                        }).disposed(by: disposeBag)
                    reactor.action.on(.next(.load(group: .company)))
                    expect(stateEvents).toEventually(equal([next(100, FeedStateEvent(loading: false, entryCount: 0, useableViewModel: false)),
                                                            next(150, FeedStateEvent(loading: true, entryCount: 0, useableViewModel: false)),
                                                            next(200, FeedStateEvent(loading: true, entryCount: 35, useableViewModel: true)),
                                                            next(250, FeedStateEvent(loading: false, entryCount: 35, useableViewModel: true))]))
                }
            }
        }
    }
}
