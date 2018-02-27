//
//  ZXWebPageViewController.swift
//  rbstore
//
//  Created by screson on 2017/8/8.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import MJExtension

class ZXWebPageViewController: ZXUIViewController,UIWebViewDelegate {

    @IBOutlet weak var webPage: UIWebView!
    var url:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.webPage.delegate = self
        self.webPage.backgroundColor = UIColor.zx_backgroundColor
        self.webPage.scalesPageToFit = true        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstLoad {
            firstLoad = false
            self.startLoad()
        }
    }
    
    fileprivate func startLoad() {
        if let url = URL(string: url) {
            self.webPage.loadRequest(URLRequest(url: url))
        } else {
            ZXHUD.showFailure(in: self.view, text: "访问地址不存在", delay: ZXConst.zxdelayTime)
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        ZXHUD.showLoading(in: self.view, text: "", delay: nil)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        ZXHUD.hide(for: self.view, animated: true)
        ZXEmptyView.show(in: self.view, type: .networkError, text: nil) {
            self.startLoad()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ZXHUD.hide(for: self.view, animated: true)
        ZXEmptyView.hide(from: self.view)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let strUrl = request.url?.absoluteString {
            let arrList = strUrl.components(separatedBy: "#")
            if arrList.count >= 2 {
                if let list = arrList.last?.components(separatedBy: "&"),list.count > 0,let type = list.first,let value = list.last {
                    var decodeValue = value.replacingOccurrences(of: "%5D", with: "]")
                    decodeValue = decodeValue.zx_base64Decode()
                    if let typeIndex = Int(type),let linkType = ZXLinkType(rawValue: typeIndex) {
                        guard let data = decodeValue.data(using: .utf8) else {
                            return true
                        }
                        if let obj = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)  {
                            ZXRouter.showLinkType(linkType, model: ZXRecommendGoodsModel.mj_object(withKeyValues: obj))
                            return false

                        }
                    }
                }
            }
        }
        return true
    }

}
