//
//  RBAddressViewController+TableView.swift
//  rbstore
//
//  Created by 120v on 2017/7/20.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension RBAddressViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if callBack != nil,self.dataArray.count > 0 {
            if let addr = self.dataArray.object(at: indexPath.row) as? RBAddressModel {
                self.zx_checked = true
                callBack?(addr)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension RBAddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rootCell: RBAddressRootCell = tableView.dequeueReusableCell(withIdentifier: RBAddressRootCell.RBAddressRootCellID, for: indexPath) as! RBAddressRootCell
        rootCell.delegate = self
        if self.dataArray.count != 0 {
            rootCell.reloadData(self.dataArray.object(at: indexPath.row) as! RBAddressModel)
        }
        return rootCell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
   
}
