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
import NotificationBannerSwift

class BlogFeedViewController: BaseViewController,HaveReactor,BlogFeedTableViewBindProtocol {
    @IBOutlet var refreshView: UIView!
    @IBOutlet var refreshViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    @IBOutlet var dotView: UIView!
    @IBOutlet var dotButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    typealias ReactorType = BlogsFeedReactor
    lazy var reactor: BlogsFeedReactor = { [unowned self] in
       return self.resolve()
    }()
    
    typealias ModelType = BlogFeedCellViewModel
    var cellNibSet = [FeedCellStyle.rectangle.cellIdentifier,FeedCellStyle.circle.cellIdentifier,FeedCellStyle.diagonal.cellIdentifier,FeedCellStyle.table.cellIdentifier]
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
            self.reactor.state.map{ $0.askingRefresh }.distinctUntilChanged().subscribe(onNext: { [weak self] askingRefresh in
                if askingRefresh {
                    let imageView = UIImageView(image: #imageLiteral(resourceName: "ic_launcher"))
                    let banner = NotificationBanner(title: "새로운 소식이 있습니다.", subtitle: nil, leftView: imageView, style: .success, colors: CustomBannerColors())
                    banner.onTap = {
                        guard let `self` = self else { return }
                        self.reactor.action.on(.next(.refresh(group: self.group, force: false)))
                    }
                    banner.show()
                }
            }),
            GlobalEvent.shared.silentFeedRefresh.filter{ [weak self] group in group == self?.group }.subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.reactor.action.on(.next(.silentRefresh))
            }),
            NotificationCenter.default.rx.willEnterForeground.subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.reactor.action.on(.next(.refresh(group: self.group, force: false)))
            }),
            self.dotButton.rx.debounceTap.subscribe(onNext: { [weak self] in
                self?.dotTap.on(.next(()))
            }),
            self.reloaded.subscribe(onNext: { [weak self] _ in
                self?.refreshViewHeightConstraint.constant = 0
                self?.tableView.contentOffset = CGPoint.zero
                self?.checkDotView()
            }),
            self.selectedCell.subscribe(onNext: { [weak self] (indexPath,viewModel) in
                switch viewModel.style {
                case .rectangle, .circle:
                    if let entryViewModel = viewModel.entryViewModels.first {
                        self?.pushBlogViewController(entryViewModel: entryViewModel)
                    }
                default:
                    break
                }
            }),
            self.insideCellEvent.subscribe(onNext: { [weak self] entryViewModel in
                guard let entryViewModel = entryViewModel as? FeedEntryViewModel else { return }
                self?.pushBlogViewController(entryViewModel: entryViewModel)
            }),
            self.tableView.rx.contentOffset.filter{ $0.y < 0 }.subscribe(onNext: { [weak self] point in
                guard let `self` = self else { return }
                self.refreshViewHeightConstraint.constant = 20 - point.y
                let scale = fmin(1.8, fmax(1,point.y / -30))
                self.indicator.transform = CGAffineTransform(scaleX: scale, y: scale)
                if point.y < -150,!self.indicator.isAnimating {
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
            self.reactor.action.on(.next(.refresh(group: self.group, force: true)))
        }).disposed(by: disposeBag)
    }
    
    func pushBlogViewController(entryViewModel: FeedEntryViewModel) {
        let blogViewController = UIStoryboard.VC(name: "Feed", withIdentifier: "BlogViewController") as! BlogViewController
        blogViewController.entryViewModel = entryViewModel
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
