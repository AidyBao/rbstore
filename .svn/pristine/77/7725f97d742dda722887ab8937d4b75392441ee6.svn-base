//
//  ZXBSViewModel.swift
//  rbstore
//
//  Created by screson on 2017/8/10.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXBSViewModel: NSObject {
    static func addToCart(_ goods:ZXRecommendGoodsModel,completion:((Bool,Int,String) -> Void)?) {
        var dicp = [String:Any]()
        dicp["productId"] =  goods.productId
        dicp["specProductId"] =  goods.specProductId
        dicp["num"] = goods.zx_buyNum
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Cart.addToCart), params: dicp, method: .post) { (_, code, obj, stringValue, error) in
            if code == ZXAPI_SUCCESS {
                completion?(true,code,"")
            } else {
                completion?(false,code,(error?.description)!)
            }
        }
    }
    
    static func alipay(orderId:String,
                       success:((_ signString:String) -> Void)?,
                       failed:((_ code:Int,_ errorMsg:String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Pay.alipay), params: ["orderId":orderId], method: .post) { (s, status, obj, js, error) in
            if status == ZXAPI_SUCCESS {
                if let data = obj["data"] as? String {
                    success?(data)
                } else {
                    failed?(-9010,"支付信息为空,请重试")
                }
            } else {
                failed?(status,(error?.description)!)
            }
        }
    }
    
    static func payCallBack(orderId:String) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Pay.callBack), params: ["orderId":orderId], method: .post) { (s, c, obj, js, erorr) in
        }
    }
}
