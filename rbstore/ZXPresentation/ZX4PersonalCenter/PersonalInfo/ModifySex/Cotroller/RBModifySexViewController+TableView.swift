//
//  RBModifySexViewController+TableView.swift
//  rbstore
//
//  Created by 120v on 2017/7/20.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension RBModifySexViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newCell: RBModifySexCell = tableView.cellForRow(at: indexPath) as! RBModifySexCell
        newCell.selectedBTN.isSelected = !newCell.selectedBTN.isSelected
        if newCell.selectedBTN.isSelected {
            self.sex = newCell.tileLB.text!
            self.selectedArr.add(indexPath)
        }
        
        if self.sex != ZXUser.user.sexStr {
            self.saveButton?.isEnabled = true
            self.saveButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
        }else{
            self.saveButton?.isEnabled = false
            self.saveButton?.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControlState.normal)
        }

        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let oldCell: RBModifySexCell = tableView.cellForRow(at: indexPath) as! RBModifySexCell
        if oldCell.selectedBTN.isSelected {
            oldCell.selectedBTN.isSelected = false
            self.selectedArr.remove(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51.5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}


extension RBModifySexViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rootCell: RBModifySexCell = tableView.dequeueReusableCell(withIdentifier: RBModifySexCell.RBModifySexCellID, for: indexPath) as! RBModifySexCell
        rootCell.selectionStyle = UITableViewCellSelectionStyle.none
        if self.selectedArr.contains(indexPath) {
            rootCell.selectedBTN.isSelected = false
        }
        rootCell.loadCell(indexPath: indexPath,sex: self.sex)
        
        return rootCell
    }
    
}
