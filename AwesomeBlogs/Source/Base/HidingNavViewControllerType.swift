//
//  HidingNavViewControllerType.swift
//  HearthGuide
//
//  Created by wade.hawk on 2016. 11. 26..
//  Copyright © 2016년 wade.hawk. All rights reserved.
//

import Foundation
import RxSwift
/*
import HidingNavigationBar

protocol HidingNavViewControllerType: HidingNavigationBarManagerDelegate {
    var hidingNavBarManager: HidingNavigationBarManager? { get set }
    var barState: Variable<HidingNavigationBarState> { get set }
    func setTarget(viewController: UIViewController, scrollView: UIScrollView)
}

extension HidingNavViewControllerType where Self:BaseViewController, Self:HidingNavigationBarManagerDelegate {
    func setTarget(viewController: UIViewController, scrollView: UIScrollView) {
        self.hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: scrollView)
        self.hidingNavBarManager?.delegate = self
        viewController.rx.viewWillAppear.subscribe(onNext: { [weak self] param in
            guard let animated = param[0] as? Bool else { return }
            self?.hidingNavBarManager?.viewWillAppear(animated)
        }).addDisposableTo(disposeBag)
        viewController.rx.viewWillDisappear.subscribe(onNext: { [weak self] param in
            guard let animated = param[0] as? Bool else { return }
            self?.hidingNavBarManager?.viewWillDisappear(animated)
        }).addDisposableTo(disposeBag)
        viewController.rx.viewDidLayoutSubviews.subscribe(onNext: { [weak self] _ in
            self?.hidingNavBarManager?.viewDidLayoutSubviews()
        }).addDisposableTo(disposeBag)
    }
    func hidingNavigationBarManagerDidUpdateScrollViewInsets(_ manager: HidingNavigationBarManager) {
        
    }
    func hidingNavigationBarManagerDidChangeState(_ manager: HidingNavigationBarManager, toState state: HidingNavigationBarState) {
        self.barState.value = state
    }
}*/
