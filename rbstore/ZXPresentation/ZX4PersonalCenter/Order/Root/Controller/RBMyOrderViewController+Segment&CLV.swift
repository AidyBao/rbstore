//
//  RBMyOrderViewController+Segment&CLV.swift
//  rbstore
//
//  Created by 120v on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension RBMyOrderViewController: ZXSegmentDelegate {

    func zxsegment(_ segment: ZXSegment, didSelectAt index: Int) {
        self.isSelectTitle = false
        self.collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
}

extension RBMyOrderViewController: ZXSegmentDataSource {
    
    func numberOfTitles(in segment: ZXSegment) -> Int {
        return self.segmentTitles.count
    }
    
    func zxsegment(_ segment: ZXSegment, titleOf index: Int) -> String {
        return self.segmentTitles[index] as! String
    }
}

extension RBMyOrderViewController: UICollectionViewDelegate {
    
}

extension RBMyOrderViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RBMyOrderRootCell = collectionView.dequeueReusableCell(withReuseIdentifier: RBMyOrderRootCell.RBMyOrderRootCellID, for: indexPath) as! RBMyOrderRootCell
        cell.delegate = self
        cell.loadData(self.orderStatus , self.orderStatus.hashValue)
        return cell
    }
}

extension RBMyOrderViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: ZXBOUNDS_WIDTH, height: ZXBOUNDS_HEIGHT - 35 - 5 - 64)
    }
}

extension RBMyOrderViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index: NSInteger = (NSInteger)(scrollView.contentOffset.x/(scrollView.bounds.size.width))%self.segmentTitles.count;
        let scrollToScrollStop: Bool = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if self.defaultSelectedIndex == index {
            return
        }
        self.defaultSelectedIndex = index
        if scrollToScrollStop {
            self.reloadData(index)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.isSelectTitle = true
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollToScrollStop: Bool = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        let index: NSInteger = (NSInteger)(scrollView.contentOffset.x/(scrollView.bounds.size.width))%self.segmentTitles.count;
        if scrollToScrollStop {
            self.defaultSelectedIndex = index
            self.reloadData(index)
        }
    }
    
    func reloadData(_ index: NSInteger) {
        switch index {
        case 0:
            self.orderStatus = .all
        case 1:
            self.orderStatus = .waitPay
        case 2:
            self.orderStatus = .waitSend
        case 3:
            self.orderStatus = .shipped
        default:
            break
        }
        if self.isSelectTitle {
            self.segmentCtrl.select(at: index)
        }
        self.collectionView.reloadItems(at: [IndexPath.init(row: index, section: 0)])
    }
}
