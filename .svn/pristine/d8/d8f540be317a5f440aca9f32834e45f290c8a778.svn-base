//
//  RBSearchRootViewController+TableView.swift
//  rbstore
//
//  Created by 120v on 2017/7/31.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension RBSearchRootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.searchField.resignFirstResponder()
        
        if self.matchArray.count != 0 {
            let categoryVC: RBCategoryListViewController = RBCategoryListViewController.init()
            categoryVC.hidesBottomBarWhenPushed = true
            categoryVC.searchName = self.matchArray.object(at: indexPath.row) as! String
            categoryVC.categoryTitle = self.matchArray.object(at: indexPath.row) as! String
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}


extension RBSearchRootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RBSearchCell = tableView.dequeueReusableCell(withIdentifier: RBSearchCell.RBSearchCellID, for: indexPath) as! RBSearchCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if self.matchArray.count != 0 {
            cell.loadData(self.matchArray.object(at: indexPath.row) as! String)
        }
        return cell
    }
}
