//
//  MainTabBarController.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 19..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainTabBarController: UITabBarController,BaseViewControllerType {
    let disposeBag = DisposeBag()
    let viewControllerState = Variable<ViewControllerState>(.notloaded)
    var statusBarStyle: UIStatusBarStyle { get { return .default } }
    
    deinit {
        log.verbose(type(of: self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
