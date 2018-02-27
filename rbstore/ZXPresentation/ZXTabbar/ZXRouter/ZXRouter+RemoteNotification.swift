//
//  ZXRouter+RemoteNotification.swift
//  YDY_GJ_3_5
//
//  Created by screson on 2017/4/17.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

enum ZXRemoteNoticeType {
    case activity,message,order,goods,unknown
}

class ApsModel:NSObject {
    var alert:Any?  //支持iOS10
    var badge:Int = 0
    var title:String {
        get {
            if let alert = alert as? Dictionary<String,Any> {
                return (alert["title"] as? String) ?? "新消息"
            }
            return "新消息"
        }
    }
    
    var body:String {
        get {
            if let alert = alert as? String {
                return alert
            } else if let alert = alert as? Dictionary<String,Any> {
                return (alert["body"] as? String) ?? "新消息"
            }
            return ""
        }
    }
}

class ZXRemoteNoticeModel:NSObject {
    static var lastNoticeInfo:Dictionary<String,Any>?
    var aps = ApsModel()
    var pushId = ""
    var extensionId = ""
    var pushType = ""       //文本
    
    var fromUserTap = false
    var noticeType:ZXRemoteNoticeType {
        get{
            if pushType == "order" {
                return  .order
            } else if pushType == "activity" {
                return .activity
            } else if pushType == "message" {
                return .message
            } else if pushType == "goods" {
                return .goods
            }
            return .unknown
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}


extension ZXRouter {
    
    static func showNotice(_ infoDic:Dictionary<String,Any>?) {
        if let infoDic = infoDic{
            let noticeModel = ZXRemoteNoticeModel.mj_object(withKeyValues: infoDic)
            let rootvc = UIApplication.shared.keyWindow?.rootViewController
            if rootvc == ZXRootController.zx_tabbarVC() {
                var selectedVc = ZXRootController.zx_tabbarVC().selectedViewController
                var nav:UIViewController?
                if ZXRootController.zx_tabbarVC().presentedViewController != nil{
                    selectedVc = ZXRootController.zx_tabbarVC().presentedViewController
                }
                if let navVC = selectedVc as? UINavigationController {
                    nav = navVC
                    selectedVc = navVC.viewControllers.first
                }else{
                    nav = selectedVc?.navigationController
                }
                
                if selectedVc is ZXLoginViewController ||
                    selectedVc is ZXTelCodeLoginViewController ||
                    selectedVc is ZXRegistViewController {
                    ZXRemoteNoticeModel.lastNoticeInfo = infoDic
                    return
                }
                
                if  nav is UINavigationController {
                    ZXRemoteNoticeModel.lastNoticeInfo = nil
                    if noticeModel?.noticeType == .unknown {
                        ZXAudioUtils.vibrate()
                        ZXAlertUtils.showAlert(withTitle: noticeModel?.aps.title, message: noticeModel?.aps.body)
                    }else{
                        ZXAudioUtils.vibrate()
                        ZXAlertUtils.showAlert(wihtTitle: noticeModel?.aps.title, message: noticeModel?.aps.body, buttonTexts: ["忽略","马上查看"], action: { (index) in
                            if index == 1 {
                                if noticeModel?.noticeType == .activity {//ZXActivityModel
                                    let showModel = ZXActivityModel()
                                    showModel.activeId = noticeModel?.pushId ?? ""
                                    ZXRouter.showDetail(type: .activityWebPage, model: showModel)
                                } else if noticeModel?.noticeType == .message {
                                    ZXUser.checkLogin({ 
                                        let showModel = ZXShowModel()
                                        showModel.showId = noticeModel?.pushId ?? ""
                                        ZXRouter.showDetail(type: .messageDetail, model: showModel)
                                    })
                                } else if noticeModel?.noticeType == .order { //
                                    ZXUser.checkLogin({ 
                                        let showModel = ZXShowModel()
                                        showModel.showId = noticeModel?.pushId ?? ""
                                        ZXRouter.showDetail(type: .orderDetail, model: showModel)
                                    })
                                } else if noticeModel?.noticeType == .goods {//ZXRecommendGoodsModel
                                    let showModel = ZXRecommendGoodsModel()
                                    showModel.productId = noticeModel?.pushId ?? ""
                                    showModel.specProductId = noticeModel?.extensionId ?? ""
                                    ZXRouter.showDetail(type: .goodsDetail, model: showModel)
                                }
                            }
                        })
                    }
                }else{
                    ZXRemoteNoticeModel.lastNoticeInfo = infoDic
                    return
                }
            }else{
                ZXRemoteNoticeModel.lastNoticeInfo = infoDic
            }
        }else{
            ZXRemoteNoticeModel.lastNoticeInfo = nil
        }
    }

    static func checkLastCacheRemoteNotice() {
        self.showNotice(ZXRemoteNoticeModel.lastNoticeInfo)
    }
    
}
