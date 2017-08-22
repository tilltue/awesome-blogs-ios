//
//  LeftSideMenuViewController.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 22..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RxSwift

class LeftSideMenuViewController: BaseViewController {
    @IBOutlet var allButton: UIButton!
    @IBOutlet var devButton: UIButton!
    @IBOutlet var companyButton: UIButton!
    @IBOutlet var insightfulButton: UIButton!
    
    var selectedGroup = Variable(AwesomeBlogs.Group.dev)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()

        compositeDisposable.add(disposables: [
            self.allButton.rx.tap.map{ AwesomeBlogs.Group.all }.bind(to: self.selectedGroup),
            self.devButton.rx.tap.map{ AwesomeBlogs.Group.dev }.bind(to: self.selectedGroup),
            self.companyButton.rx.tap.map{ AwesomeBlogs.Group.company }.bind(to: self.selectedGroup),
            self.insightfulButton.rx.tap.map{ AwesomeBlogs.Group.insightful }.bind(to: self.selectedGroup),
            self.selectedGroup.asObservable().map{ $0 == .all }.bind(to: self.allButton.rx.isSelected),
            self.selectedGroup.asObservable().map{ $0 == .dev }.bind(to: self.devButton.rx.isSelected),
            self.selectedGroup.asObservable().map{ $0 == .company }.bind(to: self.companyButton.rx.isSelected),
            self.selectedGroup.asObservable().map{ $0 == .insightful }.bind(to: self.insightfulButton.rx.isSelected),
        ])
    }
    
    func makeUI() {
        var normalAttrs: [String : Any] = [NSFontAttributeName : self.allButton.titleLabel!.font,
                                      NSForegroundColorAttributeName : UIColor.white]
        var selectedAttrs = normalAttrs
        selectedAttrs[NSUnderlineStyleAttributeName] = NSUnderlineStyle.styleSingle.rawValue
        func setStyle(button: UIButton, group: AwesomeBlogs.Group) {
            button.setAttributedTitle(NSAttributedString(string: group.title, attributes: normalAttrs), for: .normal)
            button.setAttributedTitle(NSAttributedString(string: group.title, attributes: selectedAttrs), for: .selected)
        }
        setStyle(button: self.allButton, group: .all)
        setStyle(button: self.devButton, group: .dev)
        setStyle(button: self.companyButton, group: .company)
        setStyle(button: self.insightfulButton, group: .insightful)
    }
}
