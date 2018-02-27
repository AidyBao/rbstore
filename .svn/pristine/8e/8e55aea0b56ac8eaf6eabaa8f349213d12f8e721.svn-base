//
//  ZXBSControl.swift
//  rbstore
//
//  Created by screson on 2017/7/27.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

/// 业务控制
class ZXBSControl: NSObject {
    static func addToCart(_ goods:ZXRecommendGoodsModel?,callBack:((_ success:Bool) -> Void)? = nil) {
        if let goods = goods {
            ZXUser.checkLogin {
                ZXHUD.showLoading(in: ZXRootController.appWindow()!, text: "", delay: nil)
                ZXBSViewModel.addToCart(goods, completion: { (success, code,errorMsg) in
                    ZXHUD.hide(for: ZXRootController.appWindow()!, animated: true)
                    if success {
                        ZXHUD.showSuccess(in: ZXRootController.appWindow()!, text: "已添加", delay: ZXConst.zxdelayTime)
                        ZXHomePageViewModel.badgeUpdate()
                        callBack?(true)
                    } else {
                        if code != ZXAPI_LOGIN_INVALID {
                            ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: errorMsg, delay: ZXConst.zxdelayTime)
                        }
                        callBack?(false)
                    }
                })
            }
        }
    }
    
    static func payOrder(_ model:ZXBSPayModel?,fromOrderList:Bool = true) {
        ZXUser.checkLogin {
            let payvc = ZXPayViewController()
            payvc.payModel = model
            payvc.fromOrderList = fromOrderList
            if !fromOrderList {//销毁下单界面
                ZXRootController.selectedNav().zx_push(to: payvc, removeCount: 1, animated: true)
            } else {
                ZXRootController.selectedNav().pushViewController(payvc, animated: true)
            }
        }
    }
    
    static func parsePayResult(_ result:[AnyHashable:Any]?) {
        if let result = result as? Dictionary<String,Any> {
            if let str = result["resultStatus"] as? String,let code = Int.init(str) {
                switch code {
                case 9000://支付成功 同步通知
                    NotificationCenter.default.post(name: ZXNotification.Order.paySuccess.zx_noticeName(), object: nil)
                case 8000://正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                    ZXAlertUtils.showAlert(wihtTitle: "支付处理中", message: "后续请在订单列表查看支付状态", buttonText: "确定", action: {
                        NotificationCenter.default.post(name: ZXNotification.Order.payPagePop.zx_noticeName(), object: nil)
                    })
                case 4000://订单支付失败
                    ZXHUD.showText(in: ZXRootController.appWindow()!, text: "订单支付失败", delay: ZXConst.zxdelayTime)
                case 5000://重复请求
                    ZXHUD.showText(in: ZXRootController.appWindow()!, text: "重复请求", delay: ZXConst.zxdelayTime)
                case 6001://用户中途取消
                    ZXHUD.showText(in: ZXRootController.appWindow()!, text: "支付已取消", delay: ZXConst.zxdelayTime)
                case 6002://网络连接出错
                    ZXHUD.showText(in: ZXRootController.appWindow()!, text: "网络连接错误", delay: ZXConst.zxdelayTime)
                case 6004://支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                    ZXAlertUtils.showAlert(wihtTitle: "支付结果未知", message: "后续请在订单列表查看支付状态", buttonText: "确定", action: {
                        NotificationCenter.default.post(name: ZXNotification.Order.payPagePop.zx_noticeName(), object: nil)
                    })
                default:
                    ZXAlertUtils.showAlert(withTitle: "支付失败", message: "未知错误")
                }
            } else {
                ZXAlertUtils.showAlert(wihtTitle: "支付结果未知", message: "后续请在订单列表查看支付状态", buttonText: "确定", action: {
                    NotificationCenter.default.post(name: ZXNotification.Order.payPagePop.zx_noticeName(), object: nil)
                })
            }
        }
    }
}
