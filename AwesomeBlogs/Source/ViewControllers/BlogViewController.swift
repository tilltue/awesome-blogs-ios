//
//  BlogViewController.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 23..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Down

class BlogViewController: BaseViewController {
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var webView: UIWebView!
    var summary: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        compositeDisposable.add(disposables: [
            self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
        ])
        let downOption = DownOptions(rawValue: 1 << 2)
        let down = Down(markdownString: self.summary)
        if let html = try? down.toHTML(downOption) {
            self.webView.loadHTMLString(html, baseURL: nil)
        }
    }
}
