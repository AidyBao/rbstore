//
//  ZXCartViewModel.swift
//  rbstore
//
//  Created by screson on 2017/8/15.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXPayOrderModel: NSObject {
    var id:String = ""
    var payTotal:Double = 0
}

/// 购物车
class ZXCartViewModel: NSObject {
    
    /// 列表
    ///
    /// - Parameter completion: completion description
    static func getCartList(_ completion:((_ code:Int,_ success:Bool,_ list:[ZXCartModel]?,_ errorMsg:String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Cart.list), params: nil, method: .post) { (s, c, obj, js, error) in
            if c == ZXAPI_SUCCESS {
                if let data = obj["data"] as? Array<Dictionary<String,Any>>,data.count > 0 {
                    var list = [ZXCartModel]()
                    for dic in data {
                        list.append(ZXCartModel.mj_object(withKeyValues: dic))
                    }
                    completion?(c,true,list,"")
                } else {
                    completion?(c,true,[],"")
                }
            } else {
                completion?(c,false,nil,(error?.description)!)
            }
        }
    }
    
    /// 删除
    ///
    /// - Parameters:
    ///   - cartIds: cartIds description
    ///   - completion: completion description
    static func remove(cartIds:[String],completion:((_ code:Int,_ success:Bool,_ errorMsg:String) -> Void)?) {
        if cartIds.count > 0 {
            ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Cart.delete), params: ["carIds":cartIds.joined(separator: ",")], method: .post, completion: { (s, c, obj, js, error) in
                if c == ZXAPI_SUCCESS {
                    completion?(c,true,"")
                } else {
                    completion?(c,false,(error?.description)!)
                }
            })
        } else {
            completion?(-1234,false,"ID为空")
        }
    }
    
    /// 更新选中状态
    ///
    /// - Parameters:
    ///   - cartIds: nil/empty == All
    ///   - select: select description
    ///   - completion: completion description
    static func updateSelect(cartIds:[String],select:Bool,completion:((_ code:Int,_ success:Bool,_ errorMsg:String) -> Void)?) {
        var p = [String:Any]()
        p["isChosen"] = select ? "1" : "0"
        if cartIds.count > 0 {
            p["carIds"] = cartIds.joined(separator: ",")
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Cart.updateSelect), params: p, method: .post, completion: { (s, c, obj, js, error) in
            if c == ZXAPI_SUCCESS {
                completion?(c,true,"")
            } else {
                completion?(c,false,(error?.description)!)
            }
        })
    }
    
    
    static func getLatestSpecList(productId:String,completion:((_ code:Int,_ success:Bool,_ model:ZXGoodsDetailModel?,_ errorMsg:String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Cart.latestSpecList), params: ["productId":productId], method: .post) { (success, status, obj, stringValue, error) in
            if status == ZXAPI_SUCCESS {
                if let data = obj["data"] as? Dictionary<String,Any> {
                    if let detail = ZXGoodsDetailModel.mj_object(withKeyValues: data) {
                        completion?(status,true,detail,"")
                    } else {
                        completion?(status,true,nil,"")
                    }
                } else {
                    completion?(status,true,nil,"")
                }
            } else {
                completion?(status,false,nil,(error?.description)!)
            }
        }
    }

    
    
    /// 修改规格或数量
    ///
    /// - Parameters:
    ///   - cartId: cartId description
    ///   - productId: productId description
    ///   - specProductId: specProductId description
    ///   - num: num description
    ///   - type: 1 修改规格 数量 2 修改数量
    ///   - completion: completion description
    static func updateSpec_Num(cartId:String,
                               productId:String,
                               specProductId:String,
                               num:Int,
                               type:Int,
                               success:(() -> Void)?,notEnough:((_ spec:ZXSpecProductModel?) -> Void)?,failed:((_ code:Int,_ errorMsg:String) -> Void)?) {
        var params = [String:Any]()
        params["carId"] = cartId
        params["productId"] = productId
        params["specProductId"] = specProductId
        params["type"] = type
        params["num"] = num
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Cart.updateSpec), params: params, method: .post, completion: { (s, c, obj, js, error) in
            if c == ZXAPI_SUCCESS {
                success?()
            } else {
                if c == ZXAPI_STOCK_NOTENOUGH {
                    if let data = obj["specProduct"] as? Dictionary<String,Any> {
                        notEnough?(ZXSpecProductModel.mj_object(withKeyValues: data))
                    } else {
                        notEnough?(nil)
                    }
                } else {
                    failed?(c,(error?.description)!)
                }
            }
        })
    }
    
    //结算
    static func payMent(specProductIds:[String],
                        specNums:[String],
                        success:((_ model:ZXPaymentModel?,_ errorMsg:String) -> Void)?,
                        failed:((_ code:Int,_ errorMsg:String) -> Void)?) {
        var params = [String:Any]()
        params["specProductIds"] = specProductIds.joined(separator: ",")
        params["specNums"] = specNums.joined(separator: ",")
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Cart.payment), params: params, method: .post, completion: { (s, c, obj, js, error) in
            if c == ZXAPI_SUCCESS {
                if let data = obj["data"] as? [String:Any],data.count > 0 {
                    success?(ZXPaymentModel.mj_object(withKeyValues: data),"")
                } else {
                    success?(nil,"")
                }
            } else {
                failed?(c,(error?.description)!)
            }
        })
    }
    
    //下单 + 支付
    static func takeOrderAndPay(consignee:String,
                                tel:String,
                                address:String,
                                memberAddressId:String,
                                receiptTitleTypeId:String?,
                                receiptTypeId:String?,
                                receiptContentId:String?,
                                receiptTitle:String?,
                                receiptTaxNum:String?,
                                payTotal:Double,
                                freight:Double,
                                orderData:String,
                                remark:String?,
                                success:((_ payModel:ZXPayOrderModel?) -> Void)?,
                                priceError:((_ msg:String) -> Void)?,
                                failed:((_ code:Int,_ errorMsg:String) -> Void)?) {
        var params = [String:Any]()
        params["consignee"] = consignee
        params["tel"] = tel
        params["address"] = address
        params["memberAddressId"] = memberAddressId
        if let rid = receiptTypeId,rid.characters.count > 0 {
            params["receiptTypeId"] = receiptTypeId
            params["receiptContentId"] = receiptContentId
            params["receiptTitle"] = receiptTitle
            params["receiptTitleTypeId"] = receiptTitleTypeId
        }
        if let receiptTaxNum = receiptTaxNum,ZXInvoiceInputCache.type == 2 {
            params["receiptTaxNum"] = receiptTaxNum
        }
        if let remark = remark,remark.characters.count > 0 {
            params["remark"] = remark
        }
        params["payTotal"] = payTotal
        params["freight"] = freight
        params["orderData"] = orderData
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Cart.takeOrder), params: params, method: .post) { (s, c, obj, js, error) in
            if c == ZXAPI_SUCCESS {
                if let data = obj["data"] as? Dictionary<String,Any> {
                    success?(ZXPayOrderModel.mj_object(withKeyValues: data))
                } else {
                    success?(nil)
                }
            } else {
                if c == 201002 {//订单金额变更 重新调用结算接口
                    priceError?("商品价格有变动是否重新结算?")
                } else if c == 201001 {//订单运费变更 重新调用结算接口
                    priceError?("订单运费有变动是否重新结算?")
                } else {
                    failed?(c,(error?.description)!)
                }
            }
        }
    }
}

