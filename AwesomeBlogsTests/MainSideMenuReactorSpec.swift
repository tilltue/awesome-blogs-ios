//
//  MainSideMenuReactorSpec.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 21..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Swinject
import RxSwift
import RxTest

@testable import AwesomeBlogs

struct SideMenuStateEvent: Equatable {
    var isShowMenu: Bool
    var selectedGroup: AwesomeBlogs.Group
    init(isShowMenu: Bool, selectedGroup: AwesomeBlogs.Group) {
        self.isShowMenu = isShowMenu
        self.selectedGroup = selectedGroup
    }
    static func ==(lhs: SideMenuStateEvent, rhs: SideMenuStateEvent) -> Bool {
        return lhs.isShowMenu == rhs.isShowMenu && lhs.selectedGroup == rhs.selectedGroup
    }
}


class MainSideMenuReactorSpec: QuickSpec {
    override func spec() {
        var disposeBag: DisposeBag!
        var reactor: MainSideMenuReactor!
        //context("사이드 메뉴 리엑터 테스트") {
        context("MainSideMenuReactor test") {
            beforeEach {
                disposeBag = DisposeBag()
                reactor = MainSideMenuReactor()
            }
            //describe("액션을 전달하고 이벤트 스트림 결과를 비교") {
            describe("action -> event stream result") {
                //it("액션: show 메뉴") {
                it("action: show menu") {
                    var stateEvents = [Recorded<Event<SideMenuStateEvent>>]()
                    var index = 0
                    let times = [100,150,200]
                    reactor.state.map{ SideMenuStateEvent(isShowMenu: $0.isShowMenu, selectedGroup:$0.selectedGroup) }
                    .subscribe(onNext: { event in
                        stateEvents.append(next(times[index],event))
                        index+=1
                        log.debug("state : \(event.isShowMenu) \(event.selectedGroup)")
                    }).addDisposableTo(disposeBag)
                    reactor.action.on(.next(.menu(show: true)))
                    reactor.action.on(.next(.menu(show: false)))
                    expect(stateEvents).toEventually(equal([next(100, SideMenuStateEvent(isShowMenu: false, selectedGroup: .all)),
                                                            next(150, SideMenuStateEvent(isShowMenu: true, selectedGroup: .all)),
                                                            next(200, SideMenuStateEvent(isShowMenu: false, selectedGroup: .all))]))
                }
                //it("액션: selected 메뉴") {
                it("action: selected menu index") {
                    let groups = AwesomeBlogs.groups
                    var stateEvents = [Recorded<Event<SideMenuStateEvent>>]()
                    var index = 0
                    let times = [100,150,200,250,300]
                    reactor.state.map{ SideMenuStateEvent(isShowMenu: $0.isShowMenu, selectedGroup:$0.selectedGroup) }
                    .subscribe(onNext: { event in
                        stateEvents.append(next(times[index],event))
                        index+=1
                        log.debug("state : \(event.isShowMenu) \(event.selectedGroup)")
                    }).addDisposableTo(disposeBag)
                    reactor.action.on(.next(.selected(index: 0)))
                    reactor.action.on(.next(.selected(index: 3)))
                    reactor.action.on(.next(.selected(index: 1)))
                    reactor.action.on(.next(.selected(index: 2)))
                    expect(stateEvents).toEventually(equal([next(100, SideMenuStateEvent(isShowMenu: false, selectedGroup: groups[1])),
                                                            next(150, SideMenuStateEvent(isShowMenu: false, selectedGroup: groups[0])),
                                                            next(200, SideMenuStateEvent(isShowMenu: false, selectedGroup: groups[3])),
                                                            next(250, SideMenuStateEvent(isShowMenu: false, selectedGroup: groups[1])),
                                                            next(300, SideMenuStateEvent(isShowMenu: false, selectedGroup: groups[2]))]))
                }
            }
        }
    }
}
