//
//  ZXRootRouter.swift
//  YDY_GJ_3_5
//
//  Created by screson on 2017/4/17.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit



class ZXRootController: NSObject {
    
    private static var xxxTabbarVC:UITabBarController?
    class func zx_tabbarVC() -> UITabBarController! {
        guard let tabbarvc = xxxTabbarVC else {
            xxxTabbarVC = UITabBarController()
            //xxxTabbarVC?.tabBar.layer.shadowColor = UIColor.zx_colorWithHexString("4f8ee5").cgColor
            xxxTabbarVC?.tabBar.layer.shadowColor = UIColor.gray.cgColor
            xxxTabbarVC?.tabBar.layer.shadowRadius = 1
            xxxTabbarVC?.tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
            xxxTabbarVC?.tabBar.layer.shadowOpacity = 0.3
            return xxxTabbarVC!
        }
        return tabbarvc
    }
    
    class func selectedNav() -> UINavigationController {
        var nav = self.zx_tabbarVC().selectedViewController as! UINavigationController
        if let presentedvc = nav.presentedViewController as? UINavigationController {
            nav = presentedvc
        }
        return nav
    }
    
    static func zx_nav(at index:Int) -> UINavigationController {
        return self.zx_tabbarVC().viewControllers![index] as! UINavigationController
    }
    
    static func topVC() -> UIViewController {
        var topVC = self.zx_tabbarVC().selectedViewController!
        while topVC.presentedViewController != nil {
            topVC = topVC.presentedViewController!
        }
        return topVC

    }
    
    class func reload() {
        xxxTabbarVC = nil
        let tabbarvc = self.zx_tabbarVC()
        tabbarvc?.zx_addChildViewController(ZXHomepageViewController(), fromPlistItemIndex: 0)
        tabbarvc?.zx_addChildViewController(ZXCategoryRootViewController(), fromPlistItemIndex: 1)
        tabbarvc?.zx_addChildViewController(ZXShoppingCartViewController(), fromPlistItemIndex: 2)
        tabbarvc?.zx_addChildViewController(ZXPersonalCenterViewController(), fromPlistItemIndex: 3)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            tabbarvc?.delegate = delegate
        }
    }
    
    class func appWindow() -> UIWindow? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate.window
        }
        return self.topVC().view.window
    }
}

extension UINavigationController {
    override open var prefersStatusBarHidden: Bool {
        return false
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override open var childViewControllerForStatusBarStyle: UIViewController? {
        return visibleViewController
        //self.topViewController
    }
    
    override open var childViewControllerForStatusBarHidden: UIViewController? {
        return visibleViewController
    }
}
