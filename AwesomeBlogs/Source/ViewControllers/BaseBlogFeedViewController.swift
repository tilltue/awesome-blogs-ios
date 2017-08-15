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
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.isPagingEnabled = true
        self.tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        self.bindDataSource(tableView: self.tableView)
        self.compositeDisposable.add(disposables: [
            self.reactor.state.map{ $0.isLoading }.distinctUntilChanged().bind(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.view.showIndicator()
                }else {
                    self?.view.hideIndicator()
                }
            }),
            self.reactor.state.map{ $0.viewModels }.subscribe(onNext: { [weak self] viewModels in
                self?.cellViewModels.value = [AnimatableSectionModel(model: "section", items: viewModels)]
                log.debug(viewModels.count)
            })
        ])
        self.reactor.action.on(.next(.load(group: self.group)))
    }
}

extension UIStoryboard {
    class func VC(name: String, bundle: Bundle? = nil, withIdentifier: String) -> UIViewController {
        let board = UIStoryboard(name: name, bundle: bundle)
        return board.instantiateViewController(withIdentifier: withIdentifier)
    }
}


//MARK: - UITableViewDelegate
extension BlogFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.height
    }
}
