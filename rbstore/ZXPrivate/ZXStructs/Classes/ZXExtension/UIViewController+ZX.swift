//
//  UIViewController+ZX.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/5.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension UIViewController {
    func zx_addKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(xxx_baseKeyboardWillShow(notice:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(xxx_baseKeyboardWillHide(notice:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(xxx_baseKeyboardWillChangeFrame(notice:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func zx_removeKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    open func zx_keyboardWillShow(duration dt: Double,userInfo:Dictionary<String,Any>) {
        
    }
    
    open func zx_keyboardWillHide(duration dt: Double,userInfo:Dictionary<String,Any>) {
        
    }
    
    open func zx_keyboardWillChangeFrame(beginRect:CGRect,endRect: CGRect,duration dt:Double,userInfo:Dictionary<String,Any>) {
        
    }
    
    //MARK: - 
    final func xxx_baseKeyboardWillShow(notice:Notification) {
        if let userInfo = notice.userInfo as? Dictionary<String, Any> {
            let dt = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            zx_keyboardWillShow(duration: dt, userInfo:userInfo )
        }
    }
    
    final func xxx_baseKeyboardWillHide(notice:Notification) {
        if let userInfo = notice.userInfo as? Dictionary<String, Any> {
            let dt = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            zx_keyboardWillHide(duration: dt, userInfo: userInfo)
        }
    }
    
    final func xxx_baseKeyboardWillChangeFrame(notice:Notification) {
        if let userInfo = notice.userInfo as? Dictionary<String, Any> {
            let beginRect   = userInfo[UIKeyboardFrameBeginUserInfoKey] as! CGRect
            let endRect     = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let dt          = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            zx_keyboardWillChangeFrame(beginRect: beginRect, endRect: endRect, duration: dt, userInfo: userInfo)
        }
    }
    
    //MARK: - Common
    class func zx_keyController() -> UIViewController! {
        var keyVC = UIApplication.shared.keyWindow?.rootViewController
        repeat{
            if let presentedVC = keyVC?.presentedViewController {
                keyVC = presentedVC
            }else {
                break
            }
        } while ((keyVC?.presentedViewController) != nil)
        return keyVC
    }
    
    //MARK: - 
    open func zx_refresh() {
        
    }
    
    open func zx_loadmore() {
        
    }
    
    func zx_push(to vc:UIViewController,removeCount:Int,animated:Bool) {
        var nav:UINavigationController?
        if let nv = self as? UINavigationController {
            nav = nv
        } else if let nv = self.navigationController {
            nav = nv
        }
        if let nav = nav {
            var controllers = nav.viewControllers
            for _ in 0..<removeCount {
                controllers.removeLast()
            }
            controllers.append(vc)
            nav.setViewControllers(controllers, animated: animated)
        } else {
            ZXAlertUtils.showAlert(withTitle: nil, message: "无法完成PUSH操作")
        }
    }
}
