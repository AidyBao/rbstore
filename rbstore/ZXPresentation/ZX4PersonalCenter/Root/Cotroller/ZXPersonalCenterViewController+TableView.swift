//
//  ZXPersonalCenterViewController+TableView.swift
//  rbstore
//
//  Created by 120v on 2017/7/18.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension ZXPersonalCenterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            switch indexPath.row {
            case 0://我的收藏
                let collectVC:RBMyCollectViewController = RBMyCollectViewController.init()
                collectVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(collectVC, animated: true)
            case 1://我的消息
                let messgeVC:RBMessageViewController = RBMessageViewController.init()
                messgeVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(messgeVC, animated: true)
            case 2://系统设置
                let settingVC:RBSettingViewController = RBSettingViewController.loadStoryBoard()
                settingVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(settingVC, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat = 0
        switch indexPath.section {
        case 0:
            rowHeight = 243
        case 1:
            rowHeight = 52.5
        default:
            break
        }
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
}

extension ZXPersonalCenterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellRow: NSInteger = 0
        switch section {
        case 0:
            cellRow = 1
        case 1:
            cellRow = 3
        default:
            break
        }
        return cellRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let headerCell: RBPersonalHeaderCell = tableView.dequeueReusableCell(withIdentifier: RBPersonalHeaderCell.RBPersonalHeaderCellID, for: indexPath) as! RBPersonalHeaderCell
            headerCell.selectionStyle = UITableViewCellSelectionStyle.none
            headerCell.delegate = self
            if self.userHeadIcon.isEmpty == false {
                headerCell.loadHeadIcon(self.userHeadIcon)
            }
            headerCell.loadData(self.conerMarkModel)
            return headerCell
        case 1:
            let rootCell: RBPersonalRootCell = tableView.dequeueReusableCell(withIdentifier: RBPersonalRootCell.RBPersonalRootCellID, for: indexPath) as! RBPersonalRootCell
            rootCell.selectionStyle = UITableViewCellSelectionStyle.none
            rootCell.loadCell(indexPath: indexPath , self.conerMarkModel)
            return rootCell
        default:
            break
        }
       return UITableViewCell.init(style: .default, reuseIdentifier: "UnKnowCell")
    }
}
