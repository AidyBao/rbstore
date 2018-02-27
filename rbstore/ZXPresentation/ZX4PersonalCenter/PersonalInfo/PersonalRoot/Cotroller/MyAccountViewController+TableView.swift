//
//  MyAccountViewController+TableView.swift
//  rbstore
//
//  Created by 120v on 2017/7/19.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension MyAccountViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0://头像
                self.setupUserHeadPortraits()
                break
            case 1://昵称
                self.performSegue(withIdentifier: RBModifyNameViewController.ModifyName_Segue, sender: "")
            case 2://性别
                let mSexVC: RBModifySexViewController = RBModifySexViewController.init()
                mSexVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(mSexVC, animated: true)
            case 3://年龄段
                let ageVC: RBModifyAgeViewController = RBModifyAgeViewController.init()
                ageVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(ageVC, animated: true)
            default:
                break
            }
            break
        case 1://密码
            switch indexPath.row {
            case 0://绑定手机号
                self.performSegue(withIdentifier: RBModifyTelViewController.ModifyTel_Segue, sender: "")
            case 1://修改密码
                let vc = ZXRegistViewController.create(withType: .changePassword)
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
            break
        case 2://收货地址
            let addressVC: RBAddressViewController = RBAddressViewController.init()
            addressVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(addressVC, animated: true)
        default:
            break
        }
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51.5
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}


