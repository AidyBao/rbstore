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
        if indexPath.section < 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZXSpecCell.reuseIdentifier, for: indexPath) as! ZXSpecCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZXBuyCountCCVCell.reuseIdentifier, for: indexPath) as! ZXBuyCountCCVCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 3 {
            if self.type == .changeSpec { // 不修改数量
                return 0
            }
            return 1
        }
        return 7
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ZXSpecHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as! ZXSpecHeaderCollectionReusableView
        switch indexPath.section {
            case 0:
                header.lbText.text = "颜色："
            case 1:
                header.lbText.text = "内存："
            case 2:
                header.lbText.text = "产地："
            default:
                header.lbText.text = ""
        }
        
        return header
    }
}

extension ZXGoodsSpecViewController: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 3 {
            return CGSize(width: ZXBOUNDS_WIDTH - 54, height: 60)
        }
        return CGSize(width: 60, height: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 3 {
            return CGSize.zero
        }
        return CGSize(width: ZXBOUNDS_WIDTH - 54, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
