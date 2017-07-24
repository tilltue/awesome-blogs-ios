//
//  BlogsFeedReactor.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 25..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit

class BlogsFeedReactor: Reactor {
    enum Action {
        case getFeed(group: AwesomeBlogs.Group)
    }
    
    enum Mutation {
        case setLoaded(Bool)
    }
    
    struct State {
        var isLoaded: Bool?
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Single<Mutation> {
        switch action {
        case .getFeed(let group):
            return Api.getFeeds(group: group).map{ $0.count == 10 }.map(Mutation.setLoaded)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoaded(isLoaded):
            state.isLoaded = isLoaded
            return state
        }
    }
}
