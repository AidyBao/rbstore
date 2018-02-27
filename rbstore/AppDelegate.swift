//
//  AppDelegate.swift
//  rbstore
//
//  Created by screson on 2017/7/12.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import Kingfisher
import MJExtension

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        //MARK: - UIConfig
        ZXStructs.loadUIConfig()
        //MARK: - Load Tabbar's controllers
        ZXRootController.reload()
        //MARK: - Set RootViewController
        ZXRouter.changeRootViewController(ZXRootController.zx_tabbarVC())
        //MARK: -
        #if DEBUG
            ZXNetwork.showRequestLog = true
        #endif
        self.zxnoticeSubject()
        //MARK: - getArea
        RBPersonalCenter.requestForGetArea { (array) in }
        //MARK: - resetCategorySelectedIndex
        RBCateoryCenter.resetCategorySelectedIndex()
        
        self.window?.makeKeyAndVisible()
        ZXUser.user.active(nil)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        ZXUser.user.sync()
        //ZXGlobalData.enterBackground() //多任务模式不进入后台ResignActive->BecomeActive
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        ZXUser.user.sync()
        ZXGlobalData.enterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        ZXGlobalData.enterForeground()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        ZXUser.user.sync()
    }
}

extension AppDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let list = tabBarController.viewControllers {
            var index = 0
            for (idx,vc) in list.enumerated() {
                if vc == viewController {
                    index = idx
                    break
                }
            }
            if index == 2 || index == 3 {
                if !ZXUser.user.isLogin {
                    ZXLoginViewController.show({ 
                        ZXRouter.tabbarSelect(at: index)
                    })
                    return false
                }
            }
            if index == 3 {
                if let nav = viewController as? UINavigationController {
                    nav.setNavigationBarHidden(true, animated: false)
                } else {
                    viewController.navigationController?.setNavigationBarHidden(true, animated: false)
                }
            }
        }
        return true
    }
}
