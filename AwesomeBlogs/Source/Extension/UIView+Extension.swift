//
//  UIView+Extension.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 7. 3..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import UIKit

// MARK: - Frame extension
extension UIView {
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    public var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue.x
            frame.origin.y = newValue.y
            self.frame = frame
        }
    }
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size.width = newValue.width
            frame.size.height = newValue.height
            self.frame = frame
        }
    }
    public var rect: CGRect {
        get {
            return self.frame
        }
        set {
            self.frame = newValue
        }
    }
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    public var centerY: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
}

// MARK: - View @IBInspectable
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue}
    }
    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor:layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set {
            layer.borderWidth = newValue
        }
    }
}

// MARK: - View extension
extension UIView {
    class func load(fromNibNamed: String, bundle : Bundle? = nil, withOwner: Any? = nil) -> UIView? {
        return UINib(nibName: fromNibNamed, bundle: bundle).instantiate(withOwner: withOwner, options: nil)[0] as? UIView
    }
    func show(_ show: Bool) -> Bool {
        if self.isHidden == !show { return false }
        self.isHidden = !show
        return true
    }
    func removeAllSubView() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    func flip(completion: ((Bool) -> Swift.Void)? = nil) {
        UIView.transition(with: self, duration: 0.2, options: .transitionFlipFromRight, animations: {
            self.transform = CGAffineTransform(rotationAngle: 0)
        }, completion: completion)
    }
    func flip(back: UIImage?, completion: (() -> Swift.Void)? = nil){
        let backView = UIImageView(frame: self.frame)
        backView.origin = CGPoint.zero
        backView.image = back
        self.addSubview(backView)
        UIView.transition(with: backView, duration: 0.2, options: .transitionFlipFromRight, animations: {
            self.isHidden = false
        }, completion: { _ in
            backView.removeFromSuperview()
        })
        UIView.transition(with: self, duration: 0.2, options: .transitionFlipFromRight, animations:nil, completion: { _ in
            self.isHidden = false
            completion?()
        })
    }
}

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}

// MARK: Loading indicator
class WhiteView: UIView {
    
}

extension UIView {
    func showIndicator() {
        if (self.subviews.filter{ $0 is WhiteView }.count) != 0 { return }
        let backView = WhiteView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        backView.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 0.3)
        let indicator = MaterialLoadingIndicator.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        indicator.center = self.center
        indicator.startAnimating()
        backView.addSubview(indicator)
        self.addSubview(backView)
    }
    func hideIndicator() {
        guard let backView = (self.subviews.filter{ $0 is WhiteView }.first) else { return }
        backView.removeFromSuperview()
    }
}
