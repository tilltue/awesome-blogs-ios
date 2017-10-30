//
//  MainSideMenuController.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 19..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FAPanels

class MainNavController: BaseNavigationViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

class MainSideMenuController: FAPanelController,HaveReactor {

    typealias ReactorType = MainSideMenuReactor
    lazy var reactor: MainSideMenuReactor = { [unowned self] in
        return self.resolve()
    }()
    var compositeDisposable = CompositeDisposable()
    var mainNavController:MainNavController!
    var leftSideMenuViewController:LeftSideMenuViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.mainNavController = UIStoryboard.VC(name: "Main", withIdentifier: "MainNavController") as! MainNavController
        _ = self.center(self.mainNavController)
        self.leftSideMenuViewController = UIStoryboard.VC(name: "Main", withIdentifier: "LeftSideMenuViewController") as! LeftSideMenuViewController
        _ = self.left(self.leftSideMenuViewController)
        self.configs.leftPanelWidth = UIScreen.main.bounds.width * 0.75
    }
    
    private func setBlogFeed(group: AwesomeBlogs.Group) {
        let blogFeedViewController = UIStoryboard.VC(name: "Feed", withIdentifier: "BlogFeedViewController") as! BlogFeedViewController
        blogFeedViewController.group = group
        self.compositeDisposable.add(disposables: [
            blogFeedViewController.dotTap.subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.reactor.action.on(.next(.menu(show: self.state != .left)))
            })
        ])
        self.mainNavController.viewControllers = [blogFeedViewController]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.compositeDisposable.add(disposables:[
            self.reactor.state.map{ $0.isShowMenu }.bind(onNext: { [weak self] show in
                guard let `self` = self else { return }
                if show, self.state != .left {
                    self.openLeft(animated: true)
                }else {
                    self.openCenter(animated: true)
                }
            }),
            self.reactor.state.map{ $0.selectedGroup }.distinctUntilChanged().bind(onNext: { [weak self] group in
                guard let `self` = self else { return }
                self.setBlogFeed(group: group)
            }),
            self.leftSideMenuViewController.selectedGroup.asObservable().skip(1).map{ MainSideMenuReactor.Action.selected(group: $0) }.bind(to: self.reactor.action),
            self.leftSideMenuViewController.selectedGroup.asObservable().skip(1).distinctUntilChanged().map{ _ in MainSideMenuReactor.Action.menu(show: false) }.bind(to: self.reactor.action)
        ])
    }
}
