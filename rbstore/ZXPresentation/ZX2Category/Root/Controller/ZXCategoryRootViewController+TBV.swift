//
//  ZXCategoryRootViewController+TBV&CLV.swift
//  rbstore
//
//  Created by 120v on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension ZXCategoryRootViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        RBCateoryCenter.saveCategory(selectedIndex: indexPath.row)
        
        if self.dataSource.count != 0 {
            let rootModel = self.dataSource.object(at: indexPath.row) as! RBCategoryRootModel
            self.childrenArray = rootModel.children
        }
        
        ZXEmptyView.hide(from: self.collectionMask)
        if self.childrenArray.count == 0 {
            ZXEmptyView.show(in: self.collectionMask, type: .noData, text: "暂无分类")
        }
        self.collectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}


extension ZXCategoryRootViewController: UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rootCell: RBCategorySuperCell = tableView.dequeueReusableCell(withIdentifier: RBCategorySuperCell.RBCategorySuperCellID, for: indexPath) as! RBCategorySuperCell
        if self.dataSource.count != 0 {
            let rootModel = self.dataSource.object(at: indexPath.row) as! RBCategoryRootModel
            rootCell.loadData(rootModel)
        }
    
        return rootCell
    }
}
