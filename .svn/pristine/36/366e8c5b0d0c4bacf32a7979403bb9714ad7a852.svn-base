//
//  ZXPayViewController.swift
//  rbstore
//
//  Created by screson on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXPayViewController: ZXUIViewController,UITableViewDelegate,UITableViewDataSource {

    var fromOrderList = true
    var payModel:ZXBSPayModel?
    @IBOutlet weak var tblList: UITableView!
    fileprivate var typeIndex = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单支付"
        // Do any additional setup after loading the view.
        self.tblList.backgroundColor = UIColor.clear
        self.tblList.register(UINib(nibName: ZXLRTableViewCell.NibName, bundle: nil), forCellReuseIdentifier: ZXLRTableViewCell.reuseIdentifier)
        self.tblList.register(UINib(nibName: ZXPayTypeCell.NibName, bundle: nil), forCellReuseIdentifier: ZXPayTypeCell.reuseIdentifier)
        let fView = UIView(frame: CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 24, height: 50))
        fView.backgroundColor = UIColor.clear
        let button = ZXCButton(frame: CGRect(x: 6, y: 0, width: fView.frame.size.width - 12, height: 40))
        button.cornerRadius = 20
        button.setTitle("确认支付", for: .normal)
        button.addTarget(self, action: #selector(commitAction), for: .touchUpInside)
        fView.addSubview(button)
        self.tblList.tableFooterView = fView
        
        
        self.tblList.selectRow(at: IndexPath(row: typeIndex, section: 0), animated: true, scrollPosition: .none)
        
        self.zx_addNavBarButtonItems(textNames: ["取消"], font: nil, color: nil, at: .left)
        
        NotificationCenter.default.addObserver(self, selector: #selector(paySuccess), name: ZXNotification.Order.paySuccess.zx_noticeName(), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(payPagePop), name: ZXNotification.Order.payPagePop.zx_noticeName(), object: nil)
    }
    
    func paySuccess() {
        ZXBSViewModel.payCallBack(orderId: self.payModel?.orderId ?? "")
        let paysuccess = ZXPaySuccessViewController()
        paysuccess.payModel = self.payModel
        self.zx_push(to: paysuccess, removeCount: 1, animated: true)
    }
    
    func payPagePop() {
        var cartVC:UIViewController?
        if let nav = self.navigationController {
            let list = nav.viewControllers.reversed()
            for vc in list {
                if vc is ZXShoppingCartViewController || vc is ZXGoodsDetailViewController {
                    cartVC = vc
                    break
                }
            }
        }
        if let cartVC = cartVC {
            self.navigationController?.popToViewController(cartVC, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func zx_leftBarButtonAction(index: Int) {
        if fromOrderList {
            ZXAlertUtils.showAlert(wihtTitle: "提示", message: "是否取消支付？", buttonTexts: ["取消支付","继续支付"], action: { (index) in
                if index == 0 {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        } else {
            ZXAlertUtils.showAlert(wihtTitle: "取消支付?", message: "可在待付款订单列表中继续完成支付", buttonTexts: ["取消支付","继续支付"], action: { (index) in
                if index == 0 {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    func commitAction() {
        if let model = self.payModel {
            ZXHUD.showLoading(in: self.view, text: "", delay: nil)
            ZXBSViewModel.alipay(orderId: model.orderId, success: { (signString) in
                ZXHUD.hide(for: self.view, animated: true)
                AlipaySDK.defaultService().payOrder(signString, fromScheme: "rbstore") { (obj) in
                    ZXBSControl.parsePayResult(obj)
                }
            }, failed: { (code, errorMsg) in
                ZXHUD.hide(for: self.view, animated: true)
                ZXNetwork.errorCodeParse(code, httpError: {
                    ZXHUD.showFailure(in: self.view, text: ZX_NETWORK_ERROR, delay: ZXConst.zxdelayTime)
                }, serverError: {
                    ZXHUD.showFailure(in: self.view, text: errorMsg, delay: ZXConst.zxdelayTime)
                })
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: ZXLRTableViewCell.reuseIdentifier, for: indexPath) as! ZXLRTableViewCell
                cell.reloadData(cornerType: .top, lineType: .bottom)
                cell.lbLeftText.text = "支付金额"
                cell.lbRightText.text = ""
                if let p = self.payModel {
                    cell.lbRightText.text = String.init(format: "%0.2f", p.payprice).zx_priceString()
                }
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: ZXPayTypeCell.reuseIdentifier, for: indexPath) as! ZXPayTypeCell
                if indexPath.row == 1 {//支付宝
                    cell.reloadData(payway: .alipay, cornerType: .none, lineType: .bottom)
                } else {//微信
                    cell.reloadData(payway: .wechat, cornerType: .bottom, lineType: .none)
                }
                return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.payModel != nil {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 17
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.tblList.selectRow(at: IndexPath(row: typeIndex, section: 0), animated: true, scrollPosition: .none)
        } else {
            typeIndex = indexPath.row
        }
    }
}
