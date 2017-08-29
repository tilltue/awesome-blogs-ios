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
    @IBOutlet var refreshView: UIView!
    @IBOutlet var refreshViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
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
    var dotTap = PublishSubject<Void>()
    var insideCellEvent = PublishSubject<Any>()
    
    var group: AwesomeBlogs.Group = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.isPagingEnabled = true
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.bindDataSource(tableView: self.tableView)
        self.compositeDisposable.add(disposables: [
            self.reactor.state.map{ $0.isLoading }.distinctUntilChanged().bind(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.view.showIndicator()
                }else {
                    self?.view.hideIndicator()
                }
            }),
            self.reactor.state.filter{ $0.eventType == .setModel }.map{ $0.viewModels }.subscribe(onNext: { [weak self] viewModels in
                self?.cellViewModels.value = [AnimatableSectionModel(model: "section\(0)", items: viewModels)]
                log.debug(viewModels.count)
            }),
            GlobalEvent.shared.silentFeedRefresh.filter{ [weak self] group in group == self?.group }.subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.reactor.action.on(.next(.refresh(group: self.group)))
            }),
            NotificationCenter.default.rx.willEnterForeground.subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.reactor.action.on(.next(.refresh(group: self.group)))
            }),
            self.dotButton.rx.debounceTap.subscribe(onNext: { [weak self] _ in
                self?.dotTap.on(.next())
            }),
            self.reloaded.subscribe(onNext: { [weak self] _ in
                self?.refreshViewHeightConstraint.constant = 0
                self?.tableView.contentOffset = CGPoint.zero
                self?.checkDotView()
            }),
            self.selectedCell.subscribe(onNext: { [weak self] (indexPath,viewModel) in
                switch viewModel.cellType {
                case .rectangle(let entry), .circle(let entry):
                    self?.pushBlogViewController(entry: entry)
                default:
                    break
                }
            }),
            self.insideCellEvent.subscribe(onNext: { [weak self] entry in
                guard let entry = entry as? Entry else { return }
                self?.pushBlogViewController(entry: entry)
            }),
            self.tableView.rx.contentOffset.filter{ $0.y < 0 }.subscribe(onNext: { [weak self] point in
                guard let `self` = self else { return }
                self.refreshViewHeightConstraint.constant = 20 - point.y
                let scale = fmin(1.8, fmax(1,point.y / -30))
                self.indicator.transform = CGAffineTransform(scaleX: scale, y: scale)
                if point.y < -60,!self.indicator.isAnimating {
                    log.debug("refresh trigger")
                    self.indicator.startAnimating()
                    self.refreshTrigger()
                }
            })
        ])
        self.reactor.action.on(.next(.load(group: self.group)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func refreshTrigger() {
        self.tableView.rx.contentOffset.filter{ $0.y >= 0 }.take(1).subscribe(onNext:{ [weak self] _ in
            guard let `self` = self else { return }
            self.indicator.stopAnimating()
            self.reactor.action.on(.next(.refresh(group: self.group)))
        }).disposed(by: disposeBag)
    }
    
    func pushBlogViewController(entry: Entry) {
        let blogViewController = UIStoryboard.VC(name: "Feed", withIdentifier: "BlogViewController") as! BlogViewController
        blogViewController.entry = entry
        self.navigationController?.pushViewController(blogViewController, animated: true)
    }
}

//MARK: - UITableViewDelegate
extension BlogFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.height
    }
    
    func checkDotView() {
        if let _ = self.tableView.visibleCells.first as? BlogFeedCell_Rectangle {
            self.dotView.borderColor = UIColor.white
        }else {
            self.dotView.borderColor = UIColor(hex: 0x333333)
        }
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
