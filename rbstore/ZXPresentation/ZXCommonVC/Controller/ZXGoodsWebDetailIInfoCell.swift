//
//  ZXGoodsWebDetailIInfoCell.swift
//  rbstore
//
//  Created by screson on 2017/7/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

protocol ZXGoodsWebDetailIInfoCellDelegate: class {
    func zxGoodsWebDetailLoadEnd(_ height:CGFloat,for cell:ZXGoodsWebDetailIInfoCell)
}

extension ZXGoodsWebDetailIInfoCellDelegate {
    func zxGoodsWebDetailLoadEnd(_ height:CGFloat,for cell:ZXGoodsWebDetailIInfoCell){}
}

/// Goods WebInfo
class ZXGoodsWebDetailIInfoCell: UITableViewCell,UIWebViewDelegate {
    static var height: CGFloat = ZXBOUNDS_HEIGHT - 64 - 45 - 44 //nav bottom tableheader
    weak var delegate: ZXGoodsWebDetailIInfoCellDelegate?
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        contentHeight.constant = ZXGoodsWebDetailIInfoCell.height //nav bottom tableheader
        contentHeight.constant = 0
        self.webView.delegate = self
        self.webView.backgroundColor = UIColor.white
        self.webView.scrollView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func reloadData(_ html:String?) {
        self.webView.loadHTMLString(html ?? "", baseURL: nil)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webView.scrollView.contentOffset = CGPoint.zero
        var height = webView.scrollView.contentSize.height
        if height < ZXGoodsWebDetailIInfoCell.height {
            height = ZXGoodsWebDetailIInfoCell.height
        }
        contentHeight.constant = height
        delegate?.zxGoodsWebDetailLoadEnd(height, for: self)
    }
    
}
