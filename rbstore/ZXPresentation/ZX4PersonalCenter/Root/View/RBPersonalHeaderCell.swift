//
//  RBPersonalHeaderCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/18.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

let Personal_AllOrderButton_Tag    = 4111
let Personal_WaitPayButton_Tag     = 4112
let Personal_WaitDeliverButton_Tag = 4113
let Personal_WaitReceiveButton_Tag = 4114

protocol RBPersonalHeaderCellDelegate: NSObjectProtocol {
    func didSelectedHeaderToolCellAction(_ sender: UIButton)
    func didEditButtonAction(_ sender: UIButton)
}


class RBPersonalHeaderCell: UITableViewCell {
    
    static let RBPersonalHeaderCellID: String = "RBPersonalHeaderCell"
    
    weak var delegate: RBPersonalHeaderCellDelegate?
    
    @IBOutlet weak var headerMaskView: UIView!
    @IBOutlet weak var userIconImgView: UIImageView!
    @IBOutlet weak var userNameLB: UILabel!
    @IBOutlet weak var userTelLB: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var telSpace: NSLayoutConstraint!
    
    @IBOutlet weak var toolMaskView: UIView!
    
    
    @IBOutlet weak var allOrderMaskView: UIView!
    @IBOutlet weak var allOrderImgView: UIImageView!
    @IBOutlet weak var allOrderLB: UILabel!
    @IBOutlet weak var allOrderCountLB: UILabel!
    @IBOutlet weak var allOrderCountLBWidth: NSLayoutConstraint!
    @IBOutlet weak var sepearorLine1: UIView!
    
    @IBOutlet weak var waitPayMaskView: UIView!
    @IBOutlet weak var waitPayImgView: UIImageView!
    @IBOutlet weak var waitPayLB: UILabel!
    @IBOutlet weak var waitPayCountLB: UILabel!
    @IBOutlet weak var waitPayCountLBWidth: NSLayoutConstraint!
    @IBOutlet weak var sepeatorLine2: UIView!
    
    @IBOutlet weak var waitDeliverMaskView: UIView!
    @IBOutlet weak var waitDeliverImgView: UIImageView!
    @IBOutlet weak var waitDeliverLB: UILabel!
    @IBOutlet weak var waitDeliverCountLB: UILabel!
    @IBOutlet weak var waitDeliverCountLBWidth: NSLayoutConstraint!
    @IBOutlet weak var sepeatorLine3: UIView!
    
    @IBOutlet weak var waitReceiveView: UIView!
    @IBOutlet weak var waitReceiveImgView: UIImageView!
    @IBOutlet weak var waitReceiveLB: UILabel!
    @IBOutlet weak var waitReceiveCountLB: UILabel!
    @IBOutlet weak var waitReceiveCountLBWidth: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUIStyle()
        
//        self.setDefault()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func loadHeadIcon(_ headIconStr: String) {
        if headIconStr.characters.count != 0 {
            self.userIconImgView.kf.setImage(with: URL(string:headIconStr), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    //MARK: - 编辑资料
    @IBAction func editButtonAction(_ sender: UIButton) {
        if delegate != nil {
            delegate?.didEditButtonAction(sender)
        }
    }
    
    //MARK: - 订单
    @IBAction func orderButtonAction(_ sender: UIButton) {
        if delegate != nil {
            delegate?.didSelectedHeaderToolCellAction(sender)
        }
    }
    
    //MARK: - UI
    func setUIStyle() {
        self.headerMaskView.layer.insertSublayer(self.bgGradientLayer, at: 0)
        
        self.userIconImgView.layer.cornerRadius = 30.0
        self.userIconImgView.layer.masksToBounds = true
        
        self.userNameLB.font = UIFont.zx_bodyFont
        self.userNameLB.textColor = UIColor.white
        
        self.userTelLB.font = UIFont.zx_bodyFont(13)
        self.userTelLB.textColor = UIColor.white
        
        self.editButton.titleLabel?.font = UIFont.zx_bodyFont(13)
        
        self.userNameLB.font = UIFont.zx_bodyFont(13)
        self.userNameLB.textColor = UIColor.white
        
        self.toolMaskView.layer.cornerRadius = 5.0
        self.toolMaskView.layer.shadowColor = UIColor.zx_colorWithHexString("4f8ee5").cgColor
        self.toolMaskView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.toolMaskView.layer.shadowRadius = 5.0
        self.toolMaskView.layer.shadowOpacity = 0.25
        
        self.allOrderMaskView.layer.cornerRadius = 5.0
        self.allOrderMaskView.layer.masksToBounds = true
        self.allOrderLB.font = UIFont.zx_bodyFont(13)
        self.allOrderLB.textColor = UIColor.zx_textColorBody
        self.allOrderCountLB.font = UIFont.zx_markFont
        self.allOrderCountLB.layer.cornerRadius = 7.5
        self.allOrderCountLB.layer.masksToBounds = true
        self.sepearorLine1.backgroundColor = UIColor.clear
        self.sepearorLine1.layer.insertSublayer(self.dashedLineLayer1, at: 0)
        
        self.waitPayLB.font = UIFont.zx_bodyFont(13)
        self.waitPayLB.textColor = UIColor.zx_textColorBody
        self.waitPayCountLB.font = UIFont.zx_markFont
        self.waitPayCountLB.layer.cornerRadius = 7.5
        self.waitPayCountLB.layer.masksToBounds = true
        self.sepeatorLine2.backgroundColor = UIColor.clear
        self.sepeatorLine2.layer.insertSublayer(self.dashedLineLayer2, at: 0)
        
        self.waitDeliverLB.font = UIFont.zx_bodyFont(13)
        self.waitDeliverLB.textColor = UIColor.zx_textColorBody
        self.waitDeliverCountLB.font = UIFont.zx_markFont
        self.waitDeliverCountLB.layer.cornerRadius = 7.5
        self.waitDeliverCountLB.layer.masksToBounds = true
        self.sepeatorLine3.backgroundColor = UIColor.clear
        self.sepeatorLine3.layer.insertSublayer(self.dashedLineLayer3, at: 0)
        
        self.waitReceiveView.layer.cornerRadius = 5.0
        self.waitReceiveView.layer.masksToBounds = true
        self.waitReceiveLB.font = UIFont.zx_bodyFont(13)
        self.waitReceiveLB.textColor = UIColor.zx_textColorBody
        self.waitReceiveCountLB.font = UIFont.zx_markFont
        self.waitReceiveCountLB.layer.cornerRadius = 7.5
        self.waitReceiveCountLB.layer.masksToBounds = true
    }
    
    func setDefault() {
        self.userIconImgView.kf.setImage(with: URL.init(string: ZXUser.user.headPortraitFilesStr), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        
        self.userNameLB.text = ZXUser.user.name
        
        self.userTelLB.text = ZXUser.user.tel
    }
    
    func loadData(_ model: RBConerMarkModel) {

        if ZXUser.user.name == "" || ZXUser.user.name == "未设置" {
            self.userNameLB.isHidden = true
            self.telSpace.constant = 0
        }else{
            self.userNameLB.isHidden = false
            self.telSpace.constant = 10
        }
        self.userNameLB.text = ZXUser.user.name
        
        let head = ZXUser.user.tel.substring(with: 0..<3)
        let tail = ZXUser.user.tel.substring(with: (ZXUser.user.tel.characters.count - 4)..<ZXUser.user.tel.characters.count)
        self.userTelLB.text = "\(head)****\(tail)"
        
        self.userIconImgView.kf.setImage(with: URL.init(string: ZXUser.user.headPortraitFilesStr), placeholder: UIImage.Default.headerIcon, options: nil, progressBlock: nil, completionHandler: nil)
        
        let allOrderStr: String = "0"
        if NSInteger(allOrderStr)! <= 0 {
            self.allOrderCountLB.isHidden = true
        }else {
            self.allOrderCountLB.isHidden = false
            let size: CGSize = allOrderStr.zx_textRectSize(toFont: UIFont.zx_markFont, limiteSize: CGSize.init(width: 100, height: 15.0))
            if size.width <= 15.0 {
                self.allOrderCountLBWidth.constant = 15.0
            }else{
                self.allOrderCountLBWidth.constant = size.width + 10
            }
            self.allOrderCountLB.text = allOrderStr
        }

        let waitPayStr: String = "\(model.notPayNum)"
        if model.notPayNum <= 0 {
            self.waitPayCountLB.isHidden = true
        }else{
            self.waitPayCountLB.isHidden = false
            let size2: CGSize = waitPayStr.zx_textRectSize(toFont: UIFont.zx_markFont, limiteSize: CGSize.init(width: 100, height: 15.0))
            if size2.width <= 15.0 {
                self.waitPayCountLBWidth.constant = 15.0
            }else{
                self.waitPayCountLBWidth.constant = size2.width + 10
            }
            self.waitPayCountLB.text = waitPayStr
        }

        
        let waitDeliverStr: String = "\(model.notSendNum)"
        if model.notSendNum <= 0 {
            self.waitDeliverCountLB.isHidden = true
        }else{
            self.waitDeliverCountLB.isHidden = false
            let size3: CGSize = waitDeliverStr.zx_textRectSize(toFont: UIFont.zx_markFont, limiteSize: CGSize.init(width: 100, height: 15.0))
            if size3.width <= 15.0 {
                self.waitDeliverCountLBWidth.constant = 15.0
            }else{
                self.waitDeliverCountLBWidth.constant = size3.width + 10
            }
            self.waitDeliverCountLB.text = waitDeliverStr
        }
        
        
        let waitReceiveStr: String = "\(model.notReciveNum)"
        if model.notReciveNum <= 0 {
            self.waitReceiveCountLB.isHidden = true
        }else{
            self.waitReceiveCountLB.isHidden = false
            let size4: CGSize = waitReceiveStr.zx_textRectSize(toFont: UIFont.zx_markFont, limiteSize: CGSize.init(width: 100, height: 15.0))
            if size4.width <= 15.0 {
                self.waitReceiveCountLBWidth.constant = 15.0
            }else{
                self.waitReceiveCountLBWidth.constant = size4.width + 10
            }
            self.waitReceiveCountLB.text = waitReceiveStr
        }
        
    }
    
    //MARK: - 渐变色
    fileprivate var bgGradientLayer:CAGradientLayer = {
        let gradLayer:CAGradientLayer = CAGradientLayer.init(layer: CALayer())
        gradLayer.frame = CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH, height: 189)
        gradLayer.startPoint = CGPoint.init(x: 0, y: 1)
        gradLayer.endPoint = CGPoint.init(x: 1, y: 1)
        gradLayer.colors = [UIColor(red: 93 / 255.0, green: 102 / 255.0, blue: 222 / 255.0, alpha: 1.0).cgColor,UIColor(red: 41 / 255.0, green: 53 / 255.0, blue: 202 / 255.0, alpha: 1.0).cgColor]
        return gradLayer
    }()
    
    fileprivate var dashedLineLayer1: CAShapeLayer = {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: 1, height: 58.5)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 1), NSNumber(value: 2)]
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 58.5))
        shapeLayer.path = path
        return shapeLayer
    }()
    
    fileprivate var dashedLineLayer2: CAShapeLayer = {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: 1, height: 58.5)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 1), NSNumber(value: 2)]
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 58.5))
        shapeLayer.path = path
        return shapeLayer
    }()
    
    fileprivate var dashedLineLayer3: CAShapeLayer = {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: 1, height: 58.5)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 1), NSNumber(value: 2)]
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 58.5))
        shapeLayer.path = path
        return shapeLayer
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
