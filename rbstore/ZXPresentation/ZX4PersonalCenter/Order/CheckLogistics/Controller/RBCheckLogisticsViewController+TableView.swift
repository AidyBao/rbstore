//
//  RBCheckLogisticsViewController+TableView.swift
//  rbstore
//
//  Created by 120v on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension RBCheckLogisticsViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellH: CGFloat = 0
        switch indexPath.section {
        case 0:
            cellH = 48.0
        case 1:
            cellH = 59.0
        default:
            break
        }
        return cellH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

}


extension RBCheckLogisticsViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellCount: NSInteger = 0
        switch section {
        case 0:
            cellCount = 1
        case 1:
            cellCount = 4
        default:
            break
        }
        
        return cellCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let headerCell: RBCheckLogisticsHeader = tableView.dequeueReusableCell(withIdentifier: RBCheckLogisticsHeader.RBCheckLogisticsHeaderID, for: indexPath) as! RBCheckLogisticsHeader
            return headerCell
        case 1:
            let rootCell: RBCheckLogisticsCell = tableView.dequeueReusableCell(withIdentifier: RBCheckLogisticsCell.RBCheckLogisticsCellID, for: indexPath) as! RBCheckLogisticsCell
            rootCell.loadCellStyle(indexPath)
            return rootCell
        default:
            break
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "UNKnow")
    }
    
}
