//
//  MainSideMenuReactor.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 21..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit

class MainSideMenuReactor: Reactor {
    
    enum Action {
        case menu(show: Bool)
        case selected(group: AwesomeBlogs.Group)
    }
    
    enum Mutation {
        case showMenu(Bool)
        case selected(AwesomeBlogs.Group)
    }
    
    struct State {
        var isShowMenu: Bool = false
        var selectedGroup: AwesomeBlogs.Group = .dev
    }
    
    let initialState = State()
    
    func mutate(action: MainSideMenuReactor.Action) -> Observable<Mutation> {
        switch action {
        case .menu(let show):
            return Observable.just(Mutation.showMenu(show))
        case .selected(let group):
            return Observable.just(.selected(group))
        }
    }
    
    func reduce(state: MainSideMenuReactor.State, mutation: MainSideMenuReactor.Mutation) -> MainSideMenuReactor.State {
        var state = state
        switch mutation {
        case let .showMenu(show):
            state.isShowMenu = show
            return state
        case let .selected(group):
            state.selectedGroup = group
            return state
        }
    }
}
