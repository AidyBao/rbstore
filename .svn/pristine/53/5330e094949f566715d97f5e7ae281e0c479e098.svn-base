//
//  ZXHomePageViewModel.swift
//  rbstore
//
//  Created by screson on 2017/8/7.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXHomePageViewModel: NSObject {
    
    /// BannerList
    ///
    /// - Parameter completion: completion description
    static func getBannerList(_ completion:((_ bannerList:[ZXBannerModel]?) -> Void)?,failure:((_ code:Int,_ msg:String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Home.bannerList), params: nil, method: .post) { (success, status, obj, _, error) in
            if status == ZXAPI_SUCCESS {
                if let data = obj["data"] as? Array<Dictionary<String,Any>> {
                    var list = [ZXBannerModel]()
                    for b in data {
                        list.append(ZXBannerModel.mj_object(withKeyValues: b))
                    }
                    completion?(list)
                } else {
                    completion?(nil)
                }
            } else {
                failure?(status,(error?.description)!)
            }
        }
    }
    
    /// 分类
    ///
    /// - Parameter completion: completion description
    static func getShortCategoryList(_ completion:((_ bannerList:[ZXShortCategoryModel]?) -> Void)?,failure:((_ code:Int,_ msg:String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Home.categoryList), params: nil, method: .post) { (success, status, obj, _, error) in
            if status == ZXAPI_SUCCESS {
                if let data = obj["data"] as? Array<Dictionary<String,Any>> {
                    var list = [ZXShortCategoryModel]()
                    for b in data {
                        list.append(ZXShortCategoryModel.mj_object(withKeyValues: b))
                    }
                    completion?(list)
                } else {
                    completion?(nil)
                }
            } else {
                failure?(status,(error?.description)!)
            }
        }
    }
    
    /// 首页活动
    ///
    /// - Parameter completion: completion description
    static func getActiveGoodsList(_ completion:((_ active:ZXActivityModel?) -> Void)?,failure:((_ code:Int,_ msg:String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Home.activityGoodsList), params: nil, method: .post) { (success, status, obj, _, error) in
            if status == ZXAPI_SUCCESS {
                if let data = obj["data"] as? Array<Dictionary<String,Any>> {
                    completion?(ZXActivityModel.mj_object(withKeyValues: data.first))
                } else {
                    completion?(nil)
                }
            } else {
                failure?(status,(error?.description)!)
            }
        }
    }
    
    /// 楼层
    ///
    /// - Parameter completion: completion description
    static func getFloorList(_ completion:((_ bannerList:[ZXHomeFloorsModel]?) -> Void)?,failure:((_ code:Int,_ msg:String) -> Void)?) {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Home.floorList), params: nil, method: .post) { (success, status, obj, _, error) in
            if status == ZXAPI_SUCCESS {
                if let data = obj["data"] as? Array<Dictionary<String,Any>> {
                    var list = [ZXHomeFloorsModel]()
                    for b in data {
                        list.append(ZXHomeFloorsModel.mj_object(withKeyValues: b))
                    }
                    completion?(list)
                } else {
                    completion?(nil)
                }
            } else {
                failure?(status,(error?.description)!)
            }
        }
    }
    
    /// 推荐商品
    ///
    /// - Parameters:
    ///   - pageNum: pageNum description
    ///   - pageSize: pageSize description
    ///   - completion: completion description
    static func getRecommendGoodsList(pageNum:Int,pageSize:Int,completion:((_ bannerList:[ZXRecommendGoodsModel]?) -> Void)?,failure:((_ code:Int,_ msg:String) -> Void)?) {
        let num = pageNum <= 0 ? 1 : pageNum
        let size = pageSize <= 0 ? ZX_PAGE_SIZE: pageSize
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Home.recommendList), params: ["pageNum":num,"pageSize":size], method: .post) { (success, status, obj, _, error) in
            if status == ZXAPI_SUCCESS {
                if let data = obj["data"] as? Dictionary<String,Any> {
                    if let goodsList = data["listData"] as? Array<Dictionary<String,Any>> {
                        var list = [ZXRecommendGoodsModel]()
                        for b in goodsList {
                            list.append(ZXRecommendGoodsModel.mj_object(withKeyValues: b))
                        }
                        completion?(list)
                    } else {
                        completion?(nil)
                    }
                } else {
                    completion?(nil)
                }
            } else {
                failure?(status,(error?.description)!)
            }
        }
    }
    
    static func badgeUpdate() {
        if ZXUser.user.isLogin {
            self.getHomeMsgStatus()
            self.getCartNum()
        }
    }
    
    static func getHomeMsgStatus() {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Home.unreadMsg), params: nil, method: .post) { (success, status, obj, stringValue, error) in
            if status == ZXAPI_SUCCESS {
                if let count = obj["pushNum"] as? Int {
                    ZXUser.user.zx_unreadMsg = count
                    NotificationCenter.zxpost.reloadBadge()
                }
            }
        }
    }
    
    static func getCartNum() {
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Home.cartNum), params: nil, method: .post) { (success, status, obj, stringValue, error) in
            if status == ZXAPI_SUCCESS {
                if let count = obj["carNum"] as? Int {
                    ZXUser.user.zx_CartNum = count
                    NotificationCenter.zxpost.reloadBadge()
                }
            }
        }
    }
}
