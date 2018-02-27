//
//  RBModifyAgeViewController+TableView.swift
//  rbstore
//
//  Created by 120v on 2017/7/20.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension RBModifyAgeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataArray.count != 0 {
            for model in self.dataArray {
                (model as! RBAgeGroupModel).isSelected = false
            }
            self.selectedModel = (self.dataArray.object(at: indexPath.row) as? RBAgeGroupModel)!
            self.selectedModel.isSelected = true
            
            if self.selectedModel.value != ZXUser.user.ageGroupsStr {
                self.saveButton?.isEnabled = true
                self.saveButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
            }else{
                self.saveButton?.isEnabled = false
                self.saveButton?.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControlState.normal)
            }
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51.5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension RBModifyAgeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rootCell: RBAgeRootCell = tableView.dequeueReusableCell(withIdentifier: RBAgeRootCell.RBAgeRootCellID, for: indexPath) as! RBAgeRootCell
        if self.dataArray.count != 0 {
            rootCell.loadCell(indexPath: indexPath, self.dataArray.object(at: indexPath.row) as! RBAgeGroupModel)
        }
        return rootCell
    }
}

