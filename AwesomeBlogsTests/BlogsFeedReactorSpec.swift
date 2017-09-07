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
                Service.shared.deleteFeedCache()
            }
            //describe("액션을 전달하고 이벤트 스트림 결과를 비교") {
            describe("action -> event stream result") {
                //it("액션: 피드 로드 -> 엔트리 상태 확인") {
                it("action: feed load -> get entries") {
                    var stateEvents = [Recorded<Event<FeedStateEvent>>]()
                    var index = 0
                    let times = [100,150,200,250]
                    reactor.state.map{ FeedStateEvent(loading: $0.isLoading, entryCount:$0.entries.count) }
                    .subscribe(onNext: { event in
                        stateEvents.append(next(times[index],event))
                        index+=1
                        log.debug("load state : \(event.loading) \(event.entryCount)")
                    }).disposed(by: disposeBag)
                    reactor.action.on(.next(.load(group: .dev)))
                    expect(stateEvents).toEventually(equal([next(100, FeedStateEvent(loading: false, entryCount: 0)),
                                                            next(150, FeedStateEvent(loading: true, entryCount: 0)),
                                                            next(200, FeedStateEvent(loading: true, entryCount: 103)),
                                                            next(250, FeedStateEvent(loading: false, entryCount: 103))]),
                                                     timeout: 20)
                }
                //it("액션: 피드 로드가 되면 리프레시 액션을 수행. 필터 : reactor state 의 event type 중 setModel")
                it("action: feed load -> complete load -> feed refresh (filter eventType: setModel) ") {
                    var stateEvents = [Recorded<Event<FeedStateEvent>>]()
                    var index = 0
                    let times = [100,150]
                    reactor.state.filter{ $0.eventType == .setModel }.map{ FeedStateEvent(loading: $0.isLoading, entryCount:$0.entries.count) }
                    .subscribe(onNext: { event in
                        stateEvents.append(next(times[index],event))
                        index+=1
                        log.debug("refresh state : \(event.loading) \(event.entryCount)")
                        if event.entryCount == 103 {
                            reactor.action.on(.next(.refresh(group: .company, force: true)))
                        }
                    }).disposed(by: disposeBag)
                    reactor.action.on(.next(.load(group: .dev)))
                    expect(stateEvents).toEventually(equal([next(100, FeedStateEvent(loading: true, entryCount: 103)),
                                                            next(150, FeedStateEvent(loading: true, entryCount: 35))]),
                                                     timeout: 20)
                }
                //it("액션: 피드 로드 -> 뷰모델이 정상적으로 생성되었는지 확인.")
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
                    }.subscribe(onNext: { event in
                        stateEvents.append(next(times[index],event))
                        index+=1
                        log.debug("usable state : \(event.loading) \(event.entryCount) \(event.useableViewModel)")
                    }).disposed(by: disposeBag)
                    reactor.action.on(.next(.load(group: .company)))
                    expect(stateEvents).toEventually(equal([next(100, FeedStateEvent(loading: false, entryCount: 0, useableViewModel: false)),
                                                            next(150, FeedStateEvent(loading: true, entryCount: 0, useableViewModel: false)),
                                                            next(200, FeedStateEvent(loading: true, entryCount: 35, useableViewModel: true)),
                                                            next(250, FeedStateEvent(loading: false, entryCount: 35, useableViewModel: true))]),
                                                     timeout: 20)
                }
            }
        }
    }
}
