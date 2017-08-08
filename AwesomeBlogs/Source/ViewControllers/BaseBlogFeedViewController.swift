//
//  BlogFeedViewController.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 4..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class BlogFeedViewController: BaseViewController,HaveReactor,RxTableViewBindProtocol {
    
    @IBOutlet var tableView: UITableView!
    
    typealias ReactorType = BlogsFeedReactor
    lazy var reactor: BlogsFeedReactor = { [unowned self] _ in
       return self.resolve()
    }()
    
    typealias ModelType = BlogFeedCellViewModel
    var cellViewModels = Variable<[AnimatableSectionModel<String, BlogFeedCellViewModel>]>([])
    
    var group: AwesomeBlogs.Group {
        return .all
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindDataSource(tableView: self.tableView)
        self.compositeDisposable.add(disposables: [
            self.reactor.state.map{ $0.isLoading }.distinctUntilChanged().bind(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.view.showIndicator()
                }else {
                    self?.view.hideIndicator()
                }
            }),
            self.reactor.state.map{ $0.entries }.subscribe(onNext: { [weak self] entries in
                let items = entries.map{ BlogFeedCellViewModel(entry: $0) }
                self?.cellViewModels.value = [AnimatableSectionModel(model: "section", items: items)]
                print(entries.count)
            })
        ])
        self.reactor.action.on(.next(.load(group: self.group)))
    }
}
