//
//  RBMyOrderFooter.swift
//  rbstore
//
//  Created by 120v on 2017/9/8.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

protocol RBMyOrderFooterDelegate: NSObjectProtocol {
    func didSelectedButtonAction(_ sender: UIButton,_ model: RBOrderRootModel) -> Void
}

class RBMyOrderFooter: UITableViewCell {
    
    static let RBMyOrderFooterID: String = "RBMyOrderFooter"
    
    weak var delegate: RBMyOrderFooterDelegate?
    struct OrderButton {
        static let checkTag     = 4211
        static let deleteTag    = 4212
    }
    
    @IBOutlet weak var contentMaskView: ZXUIView!
    @IBOutlet weak var totalCountLB: UILabel!
    @IBOutlet weak var totalPriceLB: UILabel!
    @IBOutlet weak var totalTitleLB: UILabel!
    @IBOutlet weak var expressLB: UILabel!
    
    
    @IBOutlet weak var checkLogisticsBTN: ZXUIButton!
    @IBOutlet weak var deleteOrderBTN: ZXUIButton!
    var orderRootModel: RBOrderRootModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.totalCountLB.font = UIFont.zx_bodyFont
        self.totalCountLB.textColor = UIColor.zx_textColorBody
        
        self.totalTitleLB.font = UIFont.zx_bodyFont
        self.totalTitleLB.textColor = UIColor.zx_textColorBody
        
        self.totalPriceLB.font = UIFont.zx_bodyFont
        self.totalPriceLB.textColor = UIColor.zx_colorWithHexString("#fd4545")
        
        self.expressLB.font = UIFont.zx_markFont
        self.expressLB.textColor = UIColor.zx_colorWithHexString("#fd4545")
        
        self.totalTitleLB.font = UIFont.zx_bodyFont
        self.totalTitleLB.textColor = UIColor.zx_textColorBody
        
        self.checkLogisticsBTN.titleLabel?.font = UIFont.zx_bodyFont
        self.checkLogisticsBTN.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.checkLogisticsBTN.backgroundColor = UIColor.zx_tintColor
        
        self.deleteOrderBTN.titleLabel?.font = UIFont.zx_bodyFont
        self.deleteOrderBTN.setTitleColor(UIColor.zx_textColorBody, for: UIControlState.normal)
        self.deleteOrderBTN.backgroundColor = UIColor.white
    }
    
    func loadData(_ model: RBOrderRootModel) {
        
        self.orderRootModel = model
        
        self.totalCountLB.text = "共计 \(model.totalCount) 件商品"
        self.totalPriceLB.text = String.init(format: "￥%.2f", model.payTotal)
        self.expressLB.text = String.init(format: "(运费:￥%.2f)",model.freight)
        switch model.orderStatus {
        case 1://待付款
            if model.payStatus == 1 {
                self.checkLogisticsBTN.isHidden = true
                self.deleteOrderBTN.isHidden = true
            }else{
                self.checkLogisticsBTN.isHidden = false
                self.deleteOrderBTN.isHidden = false
            }
            self.checkLogisticsBTN.setTitle(ButtonStatus.nowPay, for: UIControlState.normal)
            self.checkLogisticsBTN.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.checkLogisticsBTN.backgroundColor = UIColor.zx_tintColor
            
            self.deleteOrderBTN.setTitle(ButtonStatus.cancelOrder, for: UIControlState.normal)
            self.deleteOrderBTN.setTitleColor(UIColor.zx_textColorBody, for: UIControlState.normal)
            self.deleteOrderBTN.backgroundColor = UIColor.white
        case 2://待发货
            self.checkLogisticsBTN.isHidden = true
            self.deleteOrderBTN.isHidden = true
        case 3://已发货
            self.checkLogisticsBTN.isHidden = false
            self.deleteOrderBTN.isHidden = false
            
            self.checkLogisticsBTN.setTitle(ButtonStatus.confirm, for: UIControlState.normal)
            self.checkLogisticsBTN.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.checkLogisticsBTN.backgroundColor = UIColor.zx_tintColor
            
            self.deleteOrderBTN.setTitle(ButtonStatus.checkLogistics, for: UIControlState.normal)
            self.deleteOrderBTN.setTitleColor(UIColor.zx_textColorBody, for: UIControlState.normal)
            self.deleteOrderBTN.backgroundColor = UIColor.white
        case 4://已取消
            self.checkLogisticsBTN.isHidden = true
            self.deleteOrderBTN.isHidden = false
            
            self.deleteOrderBTN.setTitle(ButtonStatus.deleteOrder, for: UIControlState.normal)
            self.deleteOrderBTN.setTitleColor(UIColor.zx_textColorBody, for: UIControlState.normal)
            self.deleteOrderBTN.backgroundColor = UIColor.white
        case 6://已完成
            self.checkLogisticsBTN.isHidden = false
            self.deleteOrderBTN.isHidden = false
            self.checkLogisticsBTN.setTitle(ButtonStatus.checkLogistics, for: UIControlState.normal)
            self.checkLogisticsBTN.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.checkLogisticsBTN.backgroundColor = UIColor.zx_tintColor
            
            self.deleteOrderBTN.setTitle(ButtonStatus.deleteOrder, for: UIControlState.normal)
            self.deleteOrderBTN.setTitleColor(UIColor.zx_textColorBody, for: UIControlState.normal)
            self.deleteOrderBTN.backgroundColor = UIColor.white
        default:
            break
        }
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        if delegate != nil {
            delegate?.didSelectedButtonAction(sender,self.orderRootModel!)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
