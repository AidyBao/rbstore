//
//  GJWebViewController.swift
//  YDY_GJ_3_5
//
//  Created by 120v on 2017/4/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBWebViewController: ZXUIViewController {
    
    var webUrl:String = ""
    
    @IBOutlet weak var webView: UIWebView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.hidesBottomBarWhenPushed = true
        //self.fd_prefersNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        self.view.backgroundColor = UIColor.white
        self.webView.backgroundColor = UIColor.zx_backgroundColor
        
        if webUrl.isEmpty == false {
            webUrl = webUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            if let url = URL.init(string: webUrl) {
                self.webView.loadRequest(URLRequest(url: url))
            } else {
                ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: "地址不存在", delay: ZXHUD_MBDELAY_TIME)
            }
        }else{
            ZXAlertUtils.showAlert(wihtTitle: "提示", message: "访问出错了", buttonText: "确定", action: {
                self.navigationController?.popViewController(animated: true)
            })
        }
        
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD_MBDELAY_TIME)
        
   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RBWebViewController:UIWebViewDelegate{
    //MARK: - WebViewDelegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ZXHUD.hide(for: self.view, animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        ZXHUD.hide(for: self.view, animated: true)
        ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: "访问失败", delay: ZXHUD_MBDELAY_TIME)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}
