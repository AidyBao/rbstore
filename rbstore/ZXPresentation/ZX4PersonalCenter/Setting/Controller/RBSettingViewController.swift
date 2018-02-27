//
//  RBSetteingViewController.swift
//  rbstore
//
//  Created by 120v on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBSettingViewController: ZXUITableViewController {
    
    @IBOutlet weak var clearLB: UILabel!
    @IBOutlet weak var aboutLB: UILabel!
    @IBOutlet weak var logoutLB: UILabel!
    @IBOutlet weak var cacheLB: UILabel!
    @IBOutlet weak var logoutView: ZXUIView!
    
    
    class func loadStoryBoard() -> RBSettingViewController{
        let settingVC:RBSettingViewController = UIStoryboard.init(name: "Setting", bundle: nil).instantiateViewController(withIdentifier:String.init(describing: RBSettingViewController.classForCoder())) as! RBSettingViewController
        return settingVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置"
        
        self.clearLB.font = UIFont.zx_bodyFont
        self.clearLB.textColor = UIColor.zx_textColorBody
        
        self.aboutLB.font = UIFont.zx_bodyFont
        self.aboutLB.textColor = UIColor.zx_textColorBody
        
        self.cacheLB.font = UIFont.zx_bodyFont
        self.cacheLB.textColor = UIColor.zx_textColorMark
        
        self.logoutLB.font = UIFont.zx_bodyFont
        self.logoutLB.textColor = UIColor.white
        
        self.logoutView.layer.insertSublayer(self.bgGradientLayer, at: 0)
        self.logoutView.layer.cornerRadius = 21.0
        self.logoutView.layer.shadowColor = UIColor(red: 108 / 255.0, green: 112 / 255.0, blue: 225 / 255.0, alpha: 1.0).cgColor
        self.logoutView.layer.shadowRadius = 3
        self.logoutView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.logoutView.layer.shadowOpacity = 0.50

        
        //缓存
        self.cacheLB.text = String.init(format: "%@M", ZXCache.returnCacheSize())
    }
    
    func logout() {
         ZXUser.user.logout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - 渐变色
    fileprivate var bgGradientLayer:CAGradientLayer = {
        let gradLayer:CAGradientLayer = CAGradientLayer.init(layer: CALayer())
        gradLayer.frame = CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 2*14, height: 42)
        gradLayer.startPoint = CGPoint.init(x: 0, y: 1)
        gradLayer.endPoint = CGPoint.init(x: 1, y: 1)
        gradLayer.colors = [UIColor(red: 108 / 255.0, green: 112 / 255.0, blue: 225 / 255.0, alpha: 1.0).cgColor,UIColor(red: 77 / 255.0, green: 83 / 255.0, blue: 216 / 255.0, alpha: 1.0).cgColor]
        gradLayer.cornerRadius = 21.0
        return gradLayer
    }()
}

extension RBSettingViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0://清理缓存
                ZXAlertUtils.showAlert(wihtTitle: "提示", message: "确定清除缓存数据吗？", buttonTexts: ["取消","确定"], action: { (buttonIndex) in
                    switch (buttonIndex) {
                    case 1:
                        //清除缓存数据
                        ZXCache.cleanCache {}
                        self.cacheLB.text = String.init(format: "%@M", ZXCache.returnCacheSize())
                    default:
                        break;
                    }
                })

            case 1://关于仁博
                let webVC:RBWebViewController = RBWebViewController.init()
                webVC.title = "关于仁博"
                webVC.webUrl = "\(ZXURLConst.Web.about)"
                webVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(webVC, animated: true)
            default:
                break
            }
        case 1://退出
            ZXAlertUtils.showAlert(wihtTitle: "提示", message: "确认退出登录？", buttonTexts: ["取消","确定"], action: { (buttonIndex) in
                switch (buttonIndex) {
                case 1:
                    //清除缓存数据
                    self.logout()
                default:
                    break;
                }
            })
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellH: CGFloat = 0
        switch indexPath.section {
        case 0:
            cellH = 51.5
        case 1:
            cellH = 52
        default:
            break
        }
        return cellH
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerH: CGFloat = 0
        switch section {
        case 0:
            headerH = 15
        case 1:
            headerH = 10
        default:
            break
        }
        return headerH
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
