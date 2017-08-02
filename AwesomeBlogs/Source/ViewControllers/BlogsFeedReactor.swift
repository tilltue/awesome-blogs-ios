//
//  BlogsFeedReactor.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 25..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ReactorKit

class BlogsFeedReactor: Reactor {
    enum Action {
        case load(group: AwesomeBlogs.Group)
        case refresh(group: AwesomeBlogs.Group)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setEntries([Entry])
    }
    
    struct State {
        var isLoading: Bool = false
        var entries: [Entry] = [Entry]()
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        let start = Observable.just(Mutation.setLoading(true))
        let end = Observable.just(Mutation.setLoading(false))
        switch action {
        case .load(let group):
            let getFeed = Api.getFeeds(group: group).map(Mutation.setEntries).asObservable()
            return Observable.concat(start,getFeed,end)
        case .refresh(let group):
            let getFeed = Api.getFeeds(group: group).asObservable().map(Mutation.setEntries)
            return Observable.concat(start,getFeed,end)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state
        case let .setEntries(entries):
            state.entries = entries
            return state
        }
    }
}
