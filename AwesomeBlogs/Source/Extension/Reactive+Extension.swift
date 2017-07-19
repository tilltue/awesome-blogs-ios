//
//  Reactive+Extension.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2016. 11. 26..
//  Copyright © 2016년 wade.hawk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - UIViewController
enum ViewControllerState {
    case notloaded, hidden, hiding, showing, shown
}

extension Reactive where Base: UIViewController {
    internal var viewWillAppear: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewWillAppear(_:)))
    }
    internal var viewDidAppear: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewDidAppear(_:)))
    }
    internal var viewDidDisappear: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewDidDisappear(_:)))
    }
    internal var viewWillDisappear: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewWillDisappear(_:)))
    }
    internal var viewDidLayoutSubviews: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewDidLayoutSubviews))
    }
    internal var viewEvent: Observable<ViewControllerState> {
        let willAppear = viewWillAppear.map{ _ -> ViewControllerState in return .showing }
        let didAppear = viewDidAppear.map{ _ -> ViewControllerState in return .shown }
        let willDisappear = viewWillDisappear.map{ _ -> ViewControllerState in return .hiding }
        let didDisappear = viewDidDisappear.map{ _ -> ViewControllerState in return .hidden }
        return  Observable.of(willAppear,didAppear,willDisappear,didDisappear).merge()
    }
}

// MARK: - UIView
extension Reactive where Base: UIView {
    internal var layoutSubviews: Observable<[Any]> {
        return sentMessage(#selector(UIView.layoutSubviews))
    }
}

// MARK: - UIBarButtonItem
extension Reactive where Base: UIBarButtonItem {
    public var debounceTap: Observable<Void> {
        return self.tap.debounce(0.2, scheduler: MainScheduler.instance)
    }
}
// MARK: - UIButton
extension Reactive where Base: UIButton {
    public var debounceTap: Observable<Void> {
        return controlEvent(.touchUpInside).debounce(0.2, scheduler: MainScheduler.instance)
    }
    /// Reactive wrapper for `setImage(_:controlState:)`
    public func image(for controlState: UIControlState = []) -> UIBindingObserver<Base, UIImage?> {
        return UIBindingObserver<Base, UIImage?>(UIElement: self.base) { (button, image) -> () in
            button.setImage(image, for: controlState)
        }
    }
}

enum KeyboardNotification {
    case willShow
    case didShow
    case willChangeFrame
    case willHide
    case didHide
    var name: NSNotification.Name {
        switch self {
        case .willShow:
            return NSNotification.Name.UIKeyboardWillShow
        case .didShow:
            return NSNotification.Name.UIKeyboardDidShow
        case .willChangeFrame:
            return NSNotification.Name.UIKeyboardWillChangeFrame
        case .willHide:
            return NSNotification.Name.UIKeyboardWillHide
        case .didHide:
            return NSNotification.Name.UIKeyboardDidHide
        }
    }
}

enum System {
    case willEnterForeground
    case didEnterBackground
    var name: NSNotification.Name {
        switch self {
        case .willEnterForeground:
            return Notification.Name.UIApplicationWillEnterForeground
        case .didEnterBackground:
            return Notification.Name.UIApplicationDidEnterBackground
        }
    }
}

// MARK: - NotificationCenter
extension Reactive where Base: NotificationCenter {
    func keyboard(_ notification: KeyboardNotification) -> Observable<(begin: (CGRect,TimeInterval), end: (CGRect,TimeInterval))> {
        return self.notification(notification.name)
            .flatMap { event -> Observable<(begin: (CGRect,TimeInterval), end: (CGRect,TimeInterval))> in
                guard let userInfo = event.userInfo as? [String: AnyObject] else { return Observable.empty() }
                guard let begin = userInfo[UIKeyboardFrameBeginUserInfoKey]?.cgRectValue, let end = userInfo[UIKeyboardFrameEndUserInfoKey]?.cgRectValue, let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return Observable.empty() }
                if begin.origin == end.origin { return Observable.empty() }
                return Observable.just((begin: (begin, duration), end: (end, duration)))
            }
    }
}

// MARK: - UIScrollView
extension Reactive where Base: UIScrollView {
    public var willBeginDragging: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(UIScrollViewDelegate.scrollViewWillBeginDragging(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    public var nextPageTrigger: Observable<Void> {
        return contentOffset.map{ [weak base] (point) -> Bool in
            guard let sbase = base else { return false }
            let contentHeight = sbase.contentSize.height
            let viewHeight = sbase.height
            let shouldTrigger = contentHeight > 0 && point.y - 20 >= contentHeight - viewHeight && point.y > 0
            return shouldTrigger
        }.distinctUntilChanged()
        .flatMapFirst{ shouldTrigger -> Observable<Void> in
            return shouldTrigger ? Observable.just() : Observable.empty()
        }
    }
}
