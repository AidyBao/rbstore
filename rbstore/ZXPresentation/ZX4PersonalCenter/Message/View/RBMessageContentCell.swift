//
//  RBMessageContentCell.swift
//  
//
//  Created by 120v on 2017/8/4.
//
//

import UIKit

protocol RBMessageContentCellDelegate: NSObjectProtocol {
    func getCellHeight(_ cellHeight:CGFloat, _ cell:RBMessageContentCell) -> Void
}

class RBMessageContentCell: UITableViewCell {
    
    static let RBMessageContentCellID: String = "RBMessageContentCell"
    @IBOutlet weak var webView: UIWebView!
    weak var delegate: RBMessageContentCellDelegate?
    var cellHeight:CGFloat = 0
    var firstLoad: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        self.webView.backgroundColor = UIColor.groupTableViewBackground
        
        self.webView.delegate = self
        self.webView.scrollView.isScrollEnabled = false

        self.webView.isOpaque = false
    }
    
    func loadWebView(_ string:String) ->Void{
        let content:NSMutableString = NSMutableString.init(string: "")
        if string.isEmpty == false {
            content.append(string)
        }
        self.webView.loadHTMLString(content as String, baseURL: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.height = webView.scrollView.contentSize.height

    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RBMessageContentCell:UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'")
        self.webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'")
        self.webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.background='#EFEFF4'")
        
        if !self.firstLoad {
            self.firstLoad = true
            ZXHUD.hide(for: (UIApplication.shared.keyWindow?.rootViewController?.view)!, animated: true)
            var frame:CGRect = webView.frame
            frame.size.width = ZX_BOUNDS_WIDTH
            frame.size.height = webView.scrollView.contentSize.height
            webView.frame = frame
            self.cellHeight = webView.height
            if delegate != nil {
                delegate?.getCellHeight(webView.scrollView.contentSize.height,self)
            }
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
        ZXHUD.hide(for: (UIApplication.shared.keyWindow?.rootViewController?.view)!, animated: true)
    }
}


