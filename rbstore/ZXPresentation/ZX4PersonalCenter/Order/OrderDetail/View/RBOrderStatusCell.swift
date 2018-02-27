//
//  RBOrderStatusCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBOrderStatusCell: UITableViewCell {
    
    static let RBOrderStatusCellID: String = "RBOrderStatusCell"
    
    @IBOutlet weak var statusLB: UILabel!
    @IBOutlet weak var notesLB: UILabel!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var statusCenterGap: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.backgroundColor = UIColor.zx_tintColor
        self.contentView.layer.insertSublayer(self.bgGradientLayer, at: 0)
        
        self.statusLB.font = UIFont.zx_bodyFont
        self.statusLB.textColor = UIColor.white
        self.statusLB.text = ""
        
        self.notesLB.font = UIFont.zx_bodyFont
        self.notesLB.textColor = UIColor.white
        self.notesLB.text = ""
    }
    
    func loadData(_ model: RBOrderRootModel) {
        switch model.orderStatus {
        case 1://待付款
            if model.payStatus == 1 {//支付确认中
                self.statusCenterGap.constant = 0
                self.notesLB.isHidden = true
                self.statusImg.image = #imageLiteral(resourceName: "daifukuan-img")
                self.statusLB.text = "支付确认中"
            }else{//待付款
                self.statusCenterGap.constant = -13
                self.notesLB.isHidden = false
                self.statusImg.image = #imageLiteral(resourceName: "daifukuan-img")
                self.statusLB.text = "待付款"
                self.notesLB.text = "订单已提交，请在(\(model.lastOrderDateStr))内支付，超时订单会取消"
            }
        case 2://待发货
            self.statusCenterGap.constant = 0
            self.notesLB.isHidden = true
            self.statusImg.image = #imageLiteral(resourceName: "daifahuo-img")
            self.statusLB.text = "待发货"
        case 3://待收货
            self.statusCenterGap.constant = -13
            self.notesLB.isHidden = false
            self.statusImg.image = #imageLiteral(resourceName: "yifahuo-img")
            self.statusLB.text = "待收货"
            self.notesLB.text = "还剩(\(model.lastOrderDateStr))自动确认收货"
        case 6://已完成
            self.statusCenterGap.constant = 0
            self.notesLB.isHidden = true
            self.statusImg.image = #imageLiteral(resourceName: "yiwancheng-img")
            self.statusLB.text = "已完成"
        case 4://已取消
            self.statusCenterGap.constant = 0
            self.notesLB.isHidden = true
            self.statusImg.image = UIImage.init(named: "")
            self.statusLB.text = "已取消"
        default:
            break
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - 渐变色
    fileprivate var bgGradientLayer:CAGradientLayer = {
        let gradLayer:CAGradientLayer = CAGradientLayer.init(layer: CALayer())
        gradLayer.frame = CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH, height: 70)
        gradLayer.startPoint = CGPoint.init(x: 0, y: 1)
        gradLayer.endPoint = CGPoint.init(x: 1, y: 1)
        gradLayer.colors = [UIColor(red: 121 / 255.0, green: 126 / 255.0, blue: 223 / 255.0, alpha: 1.0).cgColor,UIColor(red: 77 / 255.0, green: 83 / 255.0, blue: 216 / 255.0, alpha: 1.0).cgColor]
        return gradLayer
    }()
}