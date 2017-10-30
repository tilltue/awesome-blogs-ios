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
import WebKit

class BlogViewController: BaseViewController {
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var safariButton: UIButton!
    @IBOutlet var airdropButton: UIButton!
    @IBOutlet var containerView: UIView!
    var entryViewModel: FeedEntryViewModel? = nil
    var downView: DownView? = nil
    var downText = Variable("")
    var webView = WKWebView()
    
    override func loadView() {
        super.loadView()
        func fetchScript() -> WKUserScript!{
            var jsScript = ""
            if let jsPath = Bundle.main.path(forResource: "to-markdown", ofType: "js"){
                do{
                    jsScript = try String(contentsOfFile: jsPath, encoding: String.Encoding.utf8)
                }catch{
                    log.verbose("Error fetchScript")
                }
            }
            let wkAlertScript = WKUserScript(source: jsScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            return wkAlertScript
        }
        let userContentController = WKUserContentController()
        userContentController.addUserScript(fetchScript())
        userContentController.add(self, name: "down")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        self.webView = WKWebView(frame: self.view.frame, configuration: configuration)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        htmlConvertMD()
        compositeDisposable.add(disposables: [
            self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }),
            self.airdropButton.rx.tap.map{ [weak self] _ in self?.entryViewModel?.link }.subscribe(onNext: { [weak self] link in
                guard let url = link?.url else { return }
                self?.presentActivityVC(url: url)
            }),
            self.safariButton.rx.tap.map{ [weak self] _ in self?.entryViewModel?.link }.subscribe(onNext: { link in
                guard let url = link?.url else { return }
                UIApplication.shared.open(url)
            }),
            self.downText.asDriver().filter{ !$0.isEmpty }.drive(onNext: { [weak self] text in
                self?.setMarkDown(text: text)
            })
        ])
        if let link = self.entryViewModel?.link {
            Api.readFeeds(link: link).subscribe().disposed(by: disposeBag)
        }
    }
    
    func presentActivityVC(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func setMarkDown(text: String) {
//        log.debug(text)
        let text = text.replacingOccurrences(of: "width", with: "")
        guard let entryViewModel = self.entryViewModel,self.downView == nil else { return }
        let down = Down(markdownString: text)
        if var downString = try? down.toCommonMark(DownOptions(rawValue: 1 << 2)) {
            downString = "## " + entryViewModel.title + "\n###### "
                + "by \(entryViewModel.author) · \(entryViewModel.updatedAt.colloquial())" + "\n" + downString
            self.downView = try? DownView(frame: self.containerView.bounds, markdownString: downString, didLoadSuccessfully: { [weak self] in
                self?.downView?.hideIndicator()
            })
        }
        guard let downView = self.downView else { return }
        self.downView?.showIndicator()
        self.containerView.addSubview(downView)
    }
    
    func htmlConvertMD() {
        let string = "<html><head><meta charset=\"utf-8\"><script> var downText = \"\(self.entryViewModel!.summary.removeNewLine)\";</script></head><body></body></html>"
        self.webView.loadHTMLString(string, baseURL: nil)
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.navigationDelegate = self
    }
}

extension BlogViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage){
        if let messageInfo = message.body as? [String:Any] {
            log.debug(messageInfo)
        }
        guard let message = message.body as? String else { return }
        self.downText.value = message
        //log.debug("Received message \(downText)")
    }
}

extension BlogViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("toMarkdown(downText);", completionHandler: nil)
    }
}
