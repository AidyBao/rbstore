//
//  ZXCommonGoodsCCVDataSource.swift
//  rbstore
//
//  Created by screson on 2017/7/21.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXCommonGoodsCCVDataSource:NSObject, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZXCommonGoodsCCVCell.reuseIdentifier, for: indexPath) as! ZXCommonGoodsCCVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
