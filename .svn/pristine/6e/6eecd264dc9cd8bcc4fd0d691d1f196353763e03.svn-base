//
//  RBSortRootView+CLV.swift
//  rbstore
//
//  Created by 120v on 2017/7/17.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension RBSortRootView: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}


extension RBSortRootView: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellNum: NSInteger = 0
        if self.dataSource.count != 0 {
            let rootModel: RBSortRootModel = self.dataSource.object(at: section) as! RBSortRootModel
            if rootModel.isSelected == false {//收起
                if rootModel.fieldOptionList.count != 0 && rootModel.fieldOptionList.count > 6 {
                    cellNum = 6
                }else{
                    cellNum = rootModel.fieldOptionList.count
                }
            }else{//展开
                cellNum = rootModel.fieldOptionList.count
            }
        }
        return cellNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var rbSortChildModel: RBSortChrildModel?
        if self.dataSource.count != 0 {
            let rootModel: RBSortRootModel = self.dataSource.object(at: indexPath.section) as! RBSortRootModel
            if rootModel.fieldOptionList.count != 0 {
                rbSortChildModel = rootModel.fieldOptionList.object(at: indexPath.row) as? RBSortChrildModel
            }
        }
        let rootCell: GoodsPropertyRootCell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsPropertyRootCell.GoodsPropertyRootCellID, for: indexPath) as! GoodsPropertyRootCell
        rootCell.delegate = self
        if rbSortChildModel != nil {
            rootCell.loadData(rbSortChildModel: rbSortChildModel!, indexPath: indexPath)
        }
        return rootCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let cell: RBSortHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: RBSortHeader.RBSortHeaderID, for: indexPath) as! RBSortHeader
            cell.delegate = self
            if self.dataSource.count != 0 {
                cell.loadData(self.dataSource.object(at: indexPath.section) as! RBSortRootModel , indexPath.section)
            }
            return cell
        }
        return UICollectionReusableView.init()
    }
}

extension RBSortRootView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.dataSource.count != 0 {
            let rootModel: RBSortRootModel = self.dataSource.object(at:section) as! RBSortRootModel
            if rootModel.fieldOptionList.count != 0 {
                return UIEdgeInsets.init(top: 10, left: 14, bottom: 10, right: 14)
            }
        }
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (ZXBOUNDS_WIDTH * (1 - SortViewGap_Scale) - 14 * 2 - 10 * 2) / 3.0
        return CGSize(width: cellWidth, height: 26)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.dataSource.count != 0 {
            let rootModel: RBSortRootModel = self.dataSource.object(at:section) as! RBSortRootModel
            if rootModel.fieldOptionList.count != 0 {
                return CGSize.init(width: ZXBOUNDS_WIDTH * (1 - SortViewGap_Scale), height: 40)
            }
        }
        return CGSize.init(width: 0, height: 0)
    }
}

extension RBSortRootView: GoodsPropertyRootCellDelegate {
    func didSelectedNameButtonAction(_ sender: UIButton, _ model: RBSortChrildModel , _ indexPath: IndexPath) {
 
    }
}

extension RBSortRootView: RBSortHeaderDelegate {
    func didMoreButtonAction(_ sender: UIButton,_ sectionIndex: NSInteger) {

        if self.dataSource.count != 0 {
            let selectedModel = self.dataSource.object(at: sectionIndex) as! RBSortRootModel
            
            if sender.isSelected == true {
                selectedModel.isSelected = true
            }else{
                selectedModel.isSelected = false
            }
            
            self.collectionView.reloadData()
        }
    }
}
