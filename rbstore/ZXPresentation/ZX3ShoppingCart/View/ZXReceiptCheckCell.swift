//
//  ZXReceiptCheckCell.swift
//  rbstore
//
//  Created by screson on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit


class ZXInvoiceInputCache: NSObject {
    static var remark:String?
    static var needOpenInvoice = false
    static var typeId:String? {
        if self.needOpenInvoice {
            return "1"
        }
        return nil
    }     //发票类型中的 【key】 现在固定为1
    
    static var titleTypeId:String? {
        if self.needOpenInvoice {
            if type == 2 {
                return "2"
            }
            return "1"
        }
        return nil
    }
    
    static var contentId:String? {
        if self.needOpenInvoice {
            return "1"
        }
        return nil
    }   //发票内容中的 【key】 现在固定为1
    
    static var type:Int = 1     //1个人 2公司
    static var personalTitle = "个人"    //个人
    static var companyTitle:String?     //公司名称
    static var taxNum:String?           //公司税号
    static var infomation:String = "无"   //发票须知
    
    static var invoiceTitle:String? {
        get {
            if type == 2 {
                if needOpenInvoice,let title = self.companyTitle,title.characters.count > 0 {
                    return title
                }
                return nil
                
            } else {
               return self.personalTitle
            }
        }
    }
    
    static var zx_titleDescription:String {
        get {
            if needOpenInvoice{
                if type == 1 {
                    return self.personalTitle
                } else {
                    if let title = self.companyTitle,title.characters.count > 0 {
                        if let taxNum = taxNum,taxNum.characters.count > 0 {
                            return "\(title)" + "(No.\(taxNum))"
                        }
                        return title
                    }
                    return ""
                }
            }
            return ""
        }
    }
    
    static func clear() {
        self.needOpenInvoice = false
//        self.personalTitle = "个人"
//        self.companyTitle = nil
//        self.taxNum = nil
        self.remark = ""
    }
    
    static func setInfo(with userInfo:ZXUserModel?) {
        if let model = userInfo {
            if model.receiptTitleTypeId == 1 {//个人
                self.type = 1
                self.personalTitle = "个人"
            } else if model.receiptTitleTypeId == 2 {//公司
                self.type = 2
                self.companyTitle = model.receiptTitle
                self.taxNum = model.receiptTaxNum
            }
        }
    }
}

/// 发票选择
class ZXReceiptCheckCell: UITableViewCell {

    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lbReceiptInfo: ZXUILabel!
    fileprivate let cornerLayer = CAShapeLayer()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.layer.mask = cornerLayer
        self.btnCheck.setImage(#imageLiteral(resourceName: "zx-uncheck"), for: .normal)
        self.btnCheck.setImage(#imageLiteral(resourceName: "zx-check"), for: .highlighted)
        self.btnCheck.setImage(#imageLiteral(resourceName: "zx-check"), for: .selected)
        self.btnCheck.isSelected = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkAction(_ sender: UIButton) {
        self.btnCheck.isSelected = !self.btnCheck.isSelected
        ZXInvoiceInputCache.needOpenInvoice = self.btnCheck.isSelected
        self.lbReceiptInfo.text = ZXInvoiceInputCache.zx_titleDescription
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateCorner()
    }
    
    func updateCorner() {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        cornerLayer.path = path.cgPath
    }
}

