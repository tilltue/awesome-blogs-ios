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

class LeftSideMenuViewController: BaseViewController {
    
}

class MainSideMenuController: FAPanelController,HaveReactor {

    typealias ReactorType = MainSideMenuReactor
    lazy var reactor: MainSideMenuReactor = { [unowned self] _ in
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var devBlogFeedViewController = UIStoryboard.VC(name: "Feed", withIdentifier: "BlogFeedViewController") as! BlogFeedViewController
        devBlogFeedViewController.group = .dev
        self.mainNavController.viewControllers = [devBlogFeedViewController]
        self.compositeDisposable.add(disposables:[
            self.reactor.state.map{ $0.showMenu }.distinctUntilChanged().bind(onNext: { [weak self] show in
                guard let `self` = self else { return }
                self.openLeft(animated: true)
            })
        ])
    }
}
