//
//  ZXGoodsViewModel.swift
//  rbstore
//
//  Created by screson on 2017/8/11.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

enum ZXGoodsMarkType: Int {
    case detial = 1
    case cart   = 2
}

class ZXGoodsViewModel: NSObject {
    
    /// 商品详情
    ///
    /// - Parameters:
    ///   - productId: productId description
    ///   - specProductId: specProductId description
    ///   - completion: completion description
    static func getGoodsDetail(productId:String,specProductId:String,completion:((_ code:Int,_ success:Bool,_ model:ZXGoodsDetailModel?,_ errorMsg:String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Goods.detailInfo), params: ["productId":productId,"specProductId":specProductId], method: .post) { (success, status, obj, stringValue, error) in
            if status == ZXAPI_SUCCESS {
                if let data = obj["data"] as? Dictionary<String,Any> {
                    completion?(status,true,ZXGoodsDetailModel.mj_object(withKeyValues: data),"")
                } else {
                    completion?(status,true,nil,"")
                }
                
            } else {
                completion?(status,false,nil,(error?.description)!)
            }
        }
    }
    
    
    /// 收藏/取消收藏
    ///
    /// - Parameters:
    ///   - mark: mark description
    ///   - source: 1、详情2、购物车
    ///   - productIds: productIds description
    ///   - specProductIds: specProductIds description
    ///   - completion: completion description
    static func mark(_ mark:Bool,source:ZXGoodsMarkType,productIds:[String],specProductIds:[String],completion:((_ code:Int,_ success:Bool,_ errorMsg:String) -> Void)?) {
        var p = [String:Any]()
        if mark {
            p["isFavorite"] = "1"
        } else {
            p["isFavorite"] = "0"
        }
        if productIds.count > 0,specProductIds.count > 0 {
            p["productIds"] = productIds.joined(separator: ",")
            p["specProductIds"] = specProductIds.joined(separator: ",")
        }
        p["source"] = source.rawValue
        
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Goods.mark_unmark), params: p, method: .post) { (s, c, obj, sv, error) in
            if c == ZXAPI_SUCCESS {
                completion?(c,true,"")
            } else {
                completion?(c,false,error?.description ?? "")
            }
        }
    
    }
}
