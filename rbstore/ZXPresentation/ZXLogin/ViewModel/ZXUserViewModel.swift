//
//  ZXUserViewModel.swift
//  rbstore
//
//  Created by screson on 2017/8/7.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

enum ZXSMSCodeType {
    case login
    case resetPwd
    case changePwd
    case changeTelNum
    case register
    
    func typeValue() -> String {
        switch self {
        case .login,.resetPwd:
            return "1"
        case .changePwd:
            return "2"
        case .changeTelNum:
            return "3"
        case .register:
            return "4"
        }
    }
}

enum ZXLoginType {
    case password
    case smscode
    
    func typeValue() -> String {
        switch self {
            case .password:
                return "1"
            default:
                return "2"
        }
    }
}

class ZXUserViewModel: NSObject {
    
    /// 获取验证码
    ///
    /// - Parameters:
    ///   - type: type description
    ///   - tel: tel description
    ///   - completion: completion description
    static func getSMSCode(type:ZXSMSCodeType,
                           tel:String,
                           success:((_ smdCode:String) -> Void)?,
                           unregist:(() -> Void)?,
                           failed:((_ code:Int,_ errorMsg:String) -> Void)?) {
        var dicp = [String:Any]()
        dicp["operateFlag"] = type.typeValue()
        dicp["tel"] = tel
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.User.getSMSCode), params: dicp, method: .post) { (s, status, obj, stringValue, error) in
            if status == ZXAPI_SUCCESS {
                if let code = obj["smsCode"] {
                    success?(String(describing: code))
                } else {
                    failed?(-9010,"验证码为空")
                }
            } else {
                if status == ZXAPI_UNREGIST {
                    unregist?()
                } else {
                    failed?(status,(error?.description)!)
                }
            }
        }
    }
    
    /// 用户注册
    ///
    /// - Parameters:
    ///   - tel: tel description
    ///   - password: password description
    ///   - uuid: uuid description
    ///   - completion: completion description
    static func register(tel:String,
                         password:String,
                         uuid:String,
                         completion:((_ status:Int,_ success:Bool,_ errorMsg:String) -> Void)?) {
        var dicp = [String:Any]()
        dicp["tel"] = tel
        dicp["password"] = password
        dicp["uuid"] = uuid
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.User.register), params: dicp, method: .post) { (success, status, obj, stringValue, error) in
            if status == ZXAPI_SUCCESS {
                if let data = obj["data"] as? [String:Any] {
                    ZXUser.user.active(data)
                    NotificationCenter.zxpost.loginSuccess()
                    completion?(status,true,"")
                } else {
                    completion?(status,false,"用户信息为空")
                }
            } else {
                completion?(status,false,(error?.description)!)
            }
        }
    }
    
    static func login(tel:String,
                      password:String?,
                      type:ZXLoginType,
                      success:(() -> Void)?,
                      unregist:(() -> Void)?,
                      failed:((_ code:Int,_ errorMsg:String) -> Void)?) {
        var dicp = [String:Any]()
        dicp["tel"] = tel
        if let password = password {
            dicp["password"] = password
        }
        dicp["loginType"] = type.typeValue()
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.User.login), params: dicp, method: .post) { (s, status, obj, stringValue, error) in
            if status == ZXAPI_SUCCESS {
                if let data = obj["data"] as? [String:Any] {
                    ZXUser.user.active(data)
                    NotificationCenter.zxpost.loginSuccess()
                    success?()
                } else {
                    failed?(-9010,"用户信息为空")
                }
            } else {
                if status == ZXAPI_UNREGIST {
                    unregist?()
                } else {
                    failed?(status,(error?.description)!)
                }
            }
        }
    }
    
    static func updateEquipmentInfo() {
        if ZXUser.user.isLogin {
            var dicp = [String:Any]()
            let device = UIDevice.current
            dicp["memberId"] = ZXUser.user.userId
            dicp["uuid"] = ZXUser.zxUUID()
            dicp["mobileSystemType"] = device.systemName
            dicp["mobileSystemVersion"] = device.systemVersion
            dicp["mobileModel"] = device.model
            let tk = ZXGlobalData.deviceToken
            if tk.characters.count > 0 {
                dicp["deviceToken"] = ZXGlobalData.deviceToken
            }
            dicp["mobileManufacturers"] = "Apple"
            dicp["packageName"] = Bundle.zx_bundleId
            dicp["appVersion"] = Bundle.zx_bundleVersion
            ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.User.updateEquipmentInfo), params: dicp, method: .post, completion: { (success, status, obj, stringValue, error) in
                if success {
                    print("updated")
                }
            })

        }
    }
    
    static func updatePassword(userId:String,
                               tel:String,
                               password:String,
                               completion:((_ status:Int,_ success:Bool,_ errorMsg:String) -> Void)?) {
        var dicp = [String:Any]()
        dicp["memberId"] = userId
        dicp["tel"] = tel
        dicp["password"] = password
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.User.updatePassword), params: dicp, method: .post, completion: { (success, status, obj, stringValue, error) in
            if status == ZXAPI_SUCCESS {
                completion?(status,true,"")
            } else {
                completion?(status,false,(error?.description)!)
            }
        })
    }
}
