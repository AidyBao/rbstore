//
//  ZXGoodsDetail+CCVList.swift
//  rbstore
//
//  Created by screson on 2017/7/31.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension ZXGoodsSpecViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = self.goodsDetailModel?.specList.count ?? 1
        if indexPath.section < count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZXSpecCell.reuseIdentifier, for: indexPath) as! ZXSpecCell
            cell.reloadData(self.goodsDetailModel?.specList[indexPath.section].specOptionList[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZXBuyCountCCVCell.reuseIdentifier, for: indexPath) as! ZXBuyCountCCVCell
            cell.delegate = self
            cell.lbNum.text = "\(self.buyCount)"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let model = self.goodsDetailModel {
            if section == model.specList.count { // 数量
//                if self.type == .changeSpec { // 购物车修改规格不修改数量
//                    return 0
//                }
                return 1
            }
            return model.specList[section].specOptionList.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let model = self.goodsDetailModel,model.specList.count > 0 {
            return model.specList.count + 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ZXSpecHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as! ZXSpecHeaderCollectionReusableView
        if let model = self.goodsDetailModel {
            header.lbText.text = model.specList[indexPath.section].name
        } else {
            header.lbText.text = ""
        }
        
        return header
    }
}

extension ZXGoodsSpecViewController: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.goodsDetailModel,indexPath.section < model.zx_allSpecKeys.count  {
            let key = model.zx_allSpecKeys[indexPath.section]
            if !self.specKeyIndex.contains(key) {
                specKeyIndex.append(key)
            }
            self.selectSpec(at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let model = self.goodsDetailModel,indexPath.section < model.zx_allSpecKeys.count {
            let key = model.zx_allSpecKeys[indexPath.section]
            
            if let index = self.specKeyIndex.index(of: key) {
                specKeyIndex.remove(at: index)
            }
            self.selectSpec(at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let model = self.goodsDetailModel,model.specList.count > 0 {
            if indexPath.section == model.specList.count {//数量cell
                return CGSize(width: ZXBOUNDS_WIDTH - 54, height: 60)
            }
            let spec = model.specList[indexPath.section]
            return spec.specOptionList[indexPath.row].zx_size
            //return CGSize(width: 60, height: 24) //规格选择项
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let model = self.goodsDetailModel {
            if section == model.specList.count {//数量cell header 为空
                return CGSize.zero
            }
            return CGSize(width: ZXBOUNDS_WIDTH - 54, height: 45)//规格选择项 header
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
