//
//  SearchResultWKWebView.swift
//  cnode
//
//  Created by nswbmw on 2018/5/7.
//  Copyright © 2018年 nswbmw. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class SearchResultWKWebViewController: UIViewController, WKNavigationDelegate {
  var webview = WKWebView()
  var keyword: String?
  
  init (keyword: String) {
    super.init(nibName: nil, bundle: nil)
    self.keyword = keyword
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    SVProgressHUD.show()
    
    let webview = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    webview.navigationDelegate = self
    let url = URL(string: "https://www.google.com.hk/search?hl=zh-CN&q=site:cnodejs.org+" + keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
    let request = URLRequest(url: url!)
    
    webview.load(request)
    self.view.addSubview(webview)
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    SVProgressHUD.dismiss()
  }
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if navigationAction.navigationType == WKNavigationType.linkActivated {
      let url = navigationAction.request.url!.absoluteString
      // 帖子页跳转
      if url.hasPrefix("https://cnodejs.org/topic/") {
        let topicViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TopicViewController") as! TopicViewController
        let start = url.index(url.startIndex, offsetBy: 26)
        let end = url.index(url.endIndex, offsetBy: 0)
        let range = start..<end
        let topicId = String(url[range])
        topicViewController.topicId = topicId
        self.navigationController?.pushViewController(topicViewController, animated: true)
        decisionHandler(WKNavigationActionPolicy.cancel)
        return
      }
      // 用户页跳转
      if url.hasPrefix("https://cnodejs.org/user/") {
        let userViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        let start = url.index(url.startIndex, offsetBy: 25)
        let end = url.index(url.endIndex, offsetBy: 0)
        let range = start..<end
        let username = String(url[range])
        userViewController.loginname = username
        self.navigationController?.pushViewController(userViewController, animated: true)
        decisionHandler(WKNavigationActionPolicy.cancel)
        return
      }
    }
    decisionHandler(WKNavigationActionPolicy.allow)
  }
}
