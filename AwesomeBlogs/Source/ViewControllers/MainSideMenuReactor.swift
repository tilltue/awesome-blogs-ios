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
        case selected(index: Int)
    }
    
    enum Mutation {
        case setShowMenu(Bool)
        case setRootViewController(BlogFeedViewController)
    }
    
    struct State {
        var showMenu: Bool = false
        var currentIndex: Int = 0
    }
    
    let initialState = State()
    
    func mutate(action: MainSideMenuReactor.Action) -> Observable<Mutation> {
        switch action {
        case .menu(let show):
            return Observable.just(Mutation.setShowMenu(show))
        case .selected(let index):
            var groups: [AwesomeBlogs.Group] = [.all,.dev,.company,.insightful]
            let group = groups[index]
            
            return Observable.empty()
        }
    }
    
    func reduce(state: MainSideMenuReactor.State, mutation: MainSideMenuReactor.Mutation) -> MainSideMenuReactor.State {
        switch mutation {
        case let _:
            return state
        case let _:
            return state
        }
    }
}
