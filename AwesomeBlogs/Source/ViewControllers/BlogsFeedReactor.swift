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
        var viewModels: [BlogFeedCellViewModel] = [BlogFeedCellViewModel]()
    }
    
    deinit {
        print("deinit BlogFeedReactor")
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
            state.viewModels = flatMapFeedViewModel(entries: entries)
            return state
        }
    }
}

// MARK: - Service Logic
extension BlogsFeedReactor {
    func flatMapFeedViewModel(entries: [Entry]) -> [BlogFeedCellViewModel] {
        var viewModels = [BlogFeedCellViewModel]()
        var mutableEntries = entries
        repeat {
            switch Int(arc4random_uniform(4)) {
            case 0:
                guard let entry = mutableEntries.first else { break }
                viewModels.append(BlogFeedCellViewModel(cellType: .rectangle(entry: entry)))
                mutableEntries.removeFirst()
            case 1:
                guard let entry = mutableEntries.first else { break }
                viewModels.append(BlogFeedCellViewModel(cellType: .circle(entry: entry)))
                mutableEntries.removeFirst()
            case 2:
                let entries = Array(mutableEntries.prefix(2))
                guard entries.count == 2 else { break }
                viewModels.append(BlogFeedCellViewModel(cellType: .diagonal(entries: entries)))
                mutableEntries.removeFirst(2)
            case 3:
                let entries = Array(mutableEntries.prefix(4))
                guard entries.count == 4 else { break }
                viewModels.append(BlogFeedCellViewModel(cellType: .table(entries: entries)))
                mutableEntries.removeFirst(4)
            default:
                break
            }
        }while(mutableEntries.count > 0)
        return viewModels
    }
}
