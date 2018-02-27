//
//  RBOrderCenter.swift
//  rbstore
//
//  Created by 120v on 2017/8/10.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBOrderCenter: NSObject {
    
    /*
     @pragma mark 修改订单状态
     @param
     */
    static func requestForUpdateOrderStatus(orderId:Int,operateFlag:Int,completion:((_ success:Bool,_ status:Int) -> Void)?,failure:((_ code:Int,_ msg:String) -> Void)?) {
        var params:Dictionary<String,Any> = Dictionary.init()
        if orderId != 0 {
            params["orderId"] = orderId
        }
        if operateFlag != 0 {
            params["operateFlag"] = operateFlag
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.updateOrderStatus), params: params, method: .post) { (success, status, content, string, error) in
            if status == ZXAPI_SUCCESS {
                completion?(success,status)
            }else{
                failure?(status,(error?.description)!)
            }
        }
    }
    
    /*
     @pragma mark 删除订单
     @param
     */
    static func requestForDeleteOrder(orderId:Int,completion:((_ success:Bool,_ status:Int) -> Void)?,failure:((_ code:Int,_ msg:String) -> Void)?) {
        var params:Dictionary<String,Any> = Dictionary.init()
        if orderId != 0 {
            params["orderId"] = orderId
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.deleteOrder), params: params, method: .post) { (success, status, content, string, error) in
            if status == ZXAPI_SUCCESS {
                completion?(success,status)
            }else{
                failure?(status,(error?.description)!)
            }
        }
    }

}
