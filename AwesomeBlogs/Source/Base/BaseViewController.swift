//
//  BaseViewController.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2016. 10. 28..
//  Copyright © 2016년 wade.hawk. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

protocol BaseViewControllerType: class {
    var disposeBag: DisposeBag { get }
    var viewControllerState: Variable<ViewControllerState> { get }
    var statusBarStyle: UIStatusBarStyle { get }
}

class BaseViewController: UIViewController, BaseViewControllerType {
    var disposeBag = DisposeBag()
    var compositeDisposable = CompositeDisposable()
    let viewControllerState = Variable<ViewControllerState>(.notloaded)
    var statusBarStyle: UIStatusBarStyle { get { return .default } }
    deinit {
        self.compositeDisposable.dispose()
        log.verbose(type(of: self))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllerState.value = .hidden
        self.rx.viewEvent.subscribe(onNext:{ [weak self] state in
            self?.viewControllerState.value = state
        }).addDisposableTo(disposeBag)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
}
