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
    @IBOutlet var dotView: UIView!
    @IBOutlet var dotButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    typealias ReactorType = BlogsFeedReactor
    lazy var reactor: BlogsFeedReactor = { [unowned self] _ in
       return self.resolve()
    }()
    
    typealias ModelType = BlogFeedCellViewModel
    var cellViewModels = Variable<[AnimatableSectionModel<String, BlogFeedCellViewModel>]>([])
    var selectedCell = PublishSubject<(IndexPath, BlogFeedCellViewModel)>()
    var reloaded = PublishSubject<Void>()
    
    var group: AwesomeBlogs.Group = .all
    
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
            }),
            self.dotButton.rx.debounceTap.subscribe(onNext: { [weak self] _ in
                
            }),
            self.reloaded.subscribe(onNext: { [weak self] _ in
                self?.checkDotView()
            })
        ])
        self.reactor.action.on(.next(.load(group: self.group)))
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

//MARK: - UITableViewDelegate
extension BlogFeedViewController: UITableViewDelegate {
    func checkDotView() {
        if let _ = self.tableView.visibleCells.first as? BlogFeedCell_Rectangle {
            self.dotView.borderColor = UIColor.white
        }else {
            self.dotView.borderColor = UIColor(hex: 0x333333)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.height
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkDotView()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        checkDotView()
    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        checkDotView()
    }
}
