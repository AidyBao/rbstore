//
//  ZXUserModel.swift
//  rbstore
//
//  Created by screson on 2017/7/19.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import KeychainAccess

class ZXUserModel: NSObject {
    fileprivate var uId:Int = -1
    fileprivate var token:String = ""
    fileprivate var passWord: String = ""
    var zxPassWord: String  { return passWord.zx_base64Decode()}
    var tel: String = ""
    var name: String = ""
    var nameStr: String = ""
    var headPortraitFiles: String = ""
    var sex: Int = 0
    var sexStr: String = ""
    var ageGroups: Int = 0
    var ageGroupsStr: String = ""
    var regDate: Int64 = 0
    var status: Int = 0
    var regDateStr: String = ""
    var headPortraitFilesStr: String = ""
    
    // 发票信息
    var receiptTitleTypeId: Int = 0 // 1 个人 2 公司
    var receiptTitle: String = ""   //抬头
    var receiptTaxNum: String = ""  //税号
    
    //id
    var userId:String {
        get {
            if uId <= 0 {
                var rd = arc4random() %  9999
                if rd == 0 {
                    rd = 1
                }
                return "-\(rd)"
            }
            return "\(uId)"
        }
    }
    //token
    var userToken:String {
        get {
            if token.isEmpty {
                return NSUUID.init().uuidString
            }
            return token
        }
    }
    
    var isLogin: Bool {
        get {
            if self.valid,uId > 0 {
                return true
            }
            return false
        }
    }
    
    func active(_ dic:[String:Any]?) {
        if let dic = dic {
            var tempDic = dic
            if let pwd = dic["passWord"] as? String {
                tempDic["passWord"] = pwd.zx_base64Encode()
            }
            
            let user = ZXUserModel.mj_object(withKeyValues: tempDic)
            if let uid = tempDic["id"] as? Int {
                user?.uId = uid
            }
            if let pwd = tempDic["passWord"] as? String {
                user?.passWord = pwd
            }
            if let tk = tempDic["token"] as? String {
                user?.token = tk
            }
            ZXUser.zxuser = user
            let dic2 = user?.mj_keyValues()
            dic2?["id"] = tempDic["id"]
            dic2?["passWord"] = tempDic["passWord"]
            dic2?["token"] = tempDic["token"]
            UserDefaults.standard.set(dic2, forKey: "ZXUser")
            UserDefaults.standard.synchronize()
            NotificationCenter.zxpost.loginSuccess()
            if ZXUserModel.lastTel.characters.count > 0,user?.tel != ZXUserModel.lastTel {
                //切换用户登录
                NotificationCenter.zxpost.accountChanged()
            }
            self.saveLastUserTel(user?.tel)
        } else {
            if let dic = UserDefaults.standard.value(forKey: "ZXUser") as? [String:Any] {
                ZXUser.zxuser = ZXUserModel.mj_object(withKeyValues: dic)
                if let uid = dic["id"] as? Int {
                    ZXUser.user.uId = uid
                }
                if let pwd = dic["passWord"] as? String {
                    ZXUser.user.passWord = pwd
                }
                if let tk = dic["token"] as? String {
                    ZXUser.user.token = tk
                }
                NotificationCenter.zxpost.loginSuccess()
                self.saveLastUserTel(ZXUser.user.tel)
            }
        }
        ZXUserViewModel.updateEquipmentInfo()
    }
    
    func sync() {
        if ZXUser.user.uId >= 0 {
            let dic2 = ZXUser.user.mj_keyValues()
            dic2?["id"] = ZXUser.zxuser?.uId
            dic2?["passWord"] = ZXUser.zxuser?.passWord
            dic2?["token"] = ZXUser.zxuser?.token
            UserDefaults.standard.set(dic2, forKey: "ZXUser")
            UserDefaults.standard.synchronize()
        }
    }
    
    func logout() {
        ZXUser.zxuser = nil
        UserDefaults.standard.removeObject(forKey: "ZXUser")
        UserDefaults.standard.synchronize()
        ZXRouter.zx_backToHomePage()
    }
    
    static var lastTel = "" //判断用户切换
    fileprivate var valid = true
    var zx_unreadMsg = 0
    var zx_CartNum = 0
    
    func invalid() {
        ZXUserModel.lastTel = self.tel
        self.valid = false
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    fileprivate func saveLastUserTel(_ tel:String?) {
        if let tel = tel,tel.characters.count > 0 {
            UserDefaults.standard.set(tel, forKey: "ZXLASET_USER_TEL")
            UserDefaults.standard.synchronize()
        }
    }
    
    static func lasetUserTel() -> String? {
        if let tel = UserDefaults.standard.object(forKey: "ZXLASET_USER_TEL") as? String {
            return tel
        }
        return nil
    }
}

class ZXUser: NSObject {
    
    fileprivate static var zxuser:ZXUserModel?
    static var user:ZXUserModel {
        get {
            
            if let _user = zxuser {
                return _user
            } else {
                zxuser = ZXUserModel()
            }
            return zxuser!
        }
    }
    
    @discardableResult static func checkLogin(_ callBack:ZXClosure_Empty? = nil) -> Bool {
        if user.isLogin {
            callBack?()
            return true
        } else {
            ZXLoginViewController.show({ 
                callBack?()
            })
        }
        return false
    }
    
    static let service = "com.reson.rbstore.bc21ee5ed9f327cb4595"
    static let key = "fbed6f09cb35463f99df10e342070137"
    static func zxUUID() -> String{
        let keychain = Keychain(service: self.service)
        let items = keychain.allItems()
        var uuid = UIDevice.current.identifierForVendor?.uuidString ?? NSUUID.init().uuidString
        if items.count > 0,let uid = keychain[self.key] {
            uuid = uid
        } else {
            keychain[self.key] = uuid
        }
        return uuid
    }
}
