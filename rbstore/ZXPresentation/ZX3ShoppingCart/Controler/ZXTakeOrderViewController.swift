//
//  ZXTakeOrderViewController.swift
//  rbstore
//
//  Created by screson on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXTakeOrderViewController: ZXUIViewController {

    var paymentModel:ZXPaymentModel?
    @IBOutlet weak var lbTotalPrice: ZXUILabel!
    @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var btnPay: ZXRButton!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "我的订单"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.zx_emptyColor
        self.tblList.backgroundColor = UIColor.clear
        //地址
        self.tblList.register(UINib(nibName: ZXAddressTableViewCell.NibName, bundle: nil), forCellReuseIdentifier: ZXAddressTableViewCell.reuseIdentifier)
        //商品
        self.tblList.register(UINib(nibName: ZXTKGoodsTableViewCell.NibName, bundle: nil), forCellReuseIdentifier: ZXTKGoodsTableViewCell.reuseIdentifier)
        //运费、价格信息
        self.tblList.register(UINib(nibName: ZXLRTableViewCell.NibName, bundle: nil), forCellReuseIdentifier: ZXLRTableViewCell.reuseIdentifier)
        //备注
        self.tblList.register(UINib(nibName: ZXRemarkInputCell.NibName, bundle: nil), forCellReuseIdentifier: ZXRemarkInputCell.reuseIdentifier)
        //发票
        self.tblList.register(UINib(nibName: ZXReceiptCheckCell.NibName, bundle: nil), forCellReuseIdentifier: ZXReceiptCheckCell.reuseIdentifier)
        //Header
        self.tblList.register(ZXSingleTextCellHeader.self, forHeaderFooterViewReuseIdentifier: ZXSingleTextCellHeader.reuseIdentifier)
        //失效商品
        self.tblList.register(UINib(nibName: ZXInvalidGoodsTableViewCell.NibName, bundle: nil), forCellReuseIdentifier: ZXInvalidGoodsTableViewCell.reuseIdentifier)
        
        self.tblList.estimatedRowHeight = 70
        self.zx_addKeyboardNotification()
        
        self.lbTotalPrice.text = ""
        ZXInvoiceInputCache.clear()
        if let m = self.paymentModel,m.specProductList.count > 0 {
            self.setNeedPay(price: m.payTotal)
            self.btnPay.zx_isEnabled(true)
        } else {
            self.setNeedPay(price: 0)
            self.btnPay.zx_isEnabled(false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblList.reloadData()
    }
    
    func setNeedPay(price:Double) {
        let string = "需支付： "
        let attr = NSAttributedString.zx_fontFormat(string, font: UIFont.zx_bodyFont, at: NSRange(location: 0, length: string.characters.count))
        let price = "\(price)".zx_priceFormat(color: nil)
        attr.append(price)
        self.lbTotalPrice.attributedText = attr
    }
    
    //MARK: - 支付
    @IBAction func payAction(_ sender: UIButton) {
        if let m = self.paymentModel {
            if let address = m.defualtAddress {
                var list:Array<Dictionary<String,Any>> = []
                for l in m.specProductList {
                    var dic = [String:Any]()
                    dic["specProductId"] = l.id
                    dic["productId"] = l.productId
                    dic["productName"] = l.title
                    dic["specNames"] = l.specOptionNames
                    dic["num"] = l.buyNum
                    list.append(dic)
                }
                ZXHUD.showLoading(in: self.view, text: "", delay: nil)
                ZXCartViewModel.takeOrderAndPay(consignee: address.consignee, tel: address.tel, address: address.zx_description, memberAddressId: "\(address.addrId)", receiptTitleTypeId: ZXInvoiceInputCache.titleTypeId, receiptTypeId: ZXInvoiceInputCache.typeId, receiptContentId: ZXInvoiceInputCache.contentId, receiptTitle: ZXInvoiceInputCache.invoiceTitle, receiptTaxNum: ZXInvoiceInputCache.taxNum, payTotal: m.payTotal,freight:m.freight, orderData: list.zx_sortJsonString(), remark: ZXInvoiceInputCache.remark, success: { (payModel) in
                    ZXHUD.hide(for: self.view, animated: true)
                    if let p = payModel {
                        let bsp = ZXBSPayModel()
                        bsp.orderId = p.id
                        bsp.payprice = p.payTotal
                        ZXBSControl.payOrder(bsp,fromOrderList: false)
                    } else {
                        ZXHUD.showFailure(in: self.view, text: "订单信息为空", delay: ZXConst.zxdelayTime)
                    }
                }, priceError: { (msg) in
                    ZXHUD.hide(for: self.view, animated: true)
                    //reload 重新结算
                    ZXAlertUtils.showAlert(wihtTitle: nil, message: msg, buttonTexts: ["取消","重新结算"], action: { (index) in
                        if index == 1 {
                            self.rePayment()
                        }
                    })
                }, failed: { (c, errorMsg) in
                    ZXHUD.hide(for: self.view, animated: true)
                    ZXNetwork.errorCodeParse(c, httpError: {
                        ZXHUD.showFailure(in: self.view, text: ZX_NETWORK_ERROR, delay: ZXConst.zxdelayTime)
                    }, serverError: {
                        ZXHUD.showFailure(in: self.view, text: errorMsg, delay: ZXConst.zxdelayTime)
                    })
                })
            } else {
                ZXHUD.showFailure(in: self.view, text: "请填写收货地址", delay: ZXConst.zxdelayTime)
            }
        } else {
            ZXHUD.showFailure(in: self.view, text: "订单数据不存在", delay: ZXConst.zxdelayTime)
        }
    }
    
    fileprivate func rePayment() {
        if let m = self.paymentModel {
            var specIds = [String]()
            var nums = [String]()
            for c in m.specProductList {
                specIds.append(c.id)
                nums.append("\(c.buyNum)")
            }
            if specIds.count > 0 {
                ZXHUD.showLoading(in: self.view, text: "", delay: nil)
                ZXCartViewModel.payMent(specProductIds: specIds, specNums: nums, success: { (paymentModel, errorMsg) in
                    ZXHUD.hide(for: self.view, animated: true)
                    ZXInvoiceInputCache.setInfo(with: paymentModel?.memberData)
                    self.paymentModel = paymentModel
                    self.tblList.reloadData()
                }, failed: { (c, errorMsg) in
                    ZXHUD.hide(for: self.view, animated: true)
                    ZXNetwork.errorCodeParse(c, httpError: {
                        ZXHUD.showFailure(in: self.view, text: ZX_NETWORK_ERROR, delay: ZXConst.zxdelayTime)
                    }, serverError: {
                        ZXHUD.showFailure(in: self.view, text: errorMsg, delay: ZXConst.zxdelayTime)
                    })
                })
                
            } else {
                ZXHUD.showText(in: self.view, text: "商品列表为空", delay: ZXConst.zxdelayTime)
            }
        }
    }
    
    override func zx_keyboardWillChangeFrame(beginRect: CGRect, endRect: CGRect, duration dt: Double, userInfo: Dictionary<String, Any>) {
        self.tblBottomConstraint.constant = endRect.height - 45
        UIView.animate(withDuration: dt) { 
            self.view.layoutIfNeeded()
        }
    }
    
    override func zx_keyboardWillHide(duration dt: Double, userInfo: Dictionary<String, Any>) {
        self.tblBottomConstraint.constant = 0
        UIView.animate(withDuration: dt) {
            self.view.layoutIfNeeded()
        }
    }

    deinit {
        self.zx_removeKeyboardNotification()
    }

}
