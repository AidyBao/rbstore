//
//  ZXCategoryRootViewController+CLV.swift
//  rbstore
//
//  Created by 120v on 2017/7/27.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension ZXCategoryRootViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.childrenArray.count != 0 {
            let model = self.childrenArray.object(at: indexPath.section) as! RBCatetoryChildrenModel
            if model.children.count != 0 {
                let subModel = model.children.object(at: indexPath.row) as! RBCatetorySubModel
                let listVC: RBCategoryListViewController = RBCategoryListViewController.init()
                listVC.hidesBottomBarWhenPushed = true
                listVC.sortId = subModel.subId
                listVC.categoryTitle = subModel.name
                    self.navigationController?.pushViewController(listVC, animated: true)
            }
        }
    }
}

extension ZXCategoryRootViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RBCategorySubCell = collectionView.dequeueReusableCell(withReuseIdentifier: RBCategorySubCell.RBCategorySubCellID, for: indexPath) as! RBCategorySubCell
        if self.childrenArray.count != 0 {
            let model = self.childrenArray.object(at: indexPath.section) as! RBCatetoryChildrenModel
            if model.children.count != 0 {
                cell.loadData(model.children.object(at: indexPath.row) as! RBCatetorySubModel)
            }
        }
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.childrenArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellNum: NSInteger = 0
        if self.childrenArray.count != 0 {
            let model = self.childrenArray.object(at: section) as! RBCatetoryChildrenModel
            cellNum = model.children.count
        }
        return cellNum
    }
}

extension ZXCategoryRootViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.collectionView.width - 20 * 2 - 25 - 15)/3, height: 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8.5, 25, 8.5, 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: self.collectionView.width, height: 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerCell: RBCategorySubHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: RBCategorySubHeader.RBCategorySubHeaderID, for: indexPath) as! RBCategorySubHeader
            if self.childrenArray.count != 0 {
                let model = self.childrenArray.object(at: indexPath.section) as! RBCatetoryChildrenModel
                headerCell.loadData(model)
            }
            return headerCell
        }
        return UICollectionReusableView.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
}
