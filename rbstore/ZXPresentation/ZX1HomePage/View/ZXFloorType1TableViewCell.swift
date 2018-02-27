//
//  ZXFloorType1TableViewCell.swift
//  rbstore
//
//  Created by screson on 2017/8/8.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

/// 类别+商品楼层Type1
class ZXFloorType1TableViewCell: UITableViewCell {

    @IBOutlet weak var ccvList: UICollectionView!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imgvMainIcon: UIImageView!
    fileprivate var floorModel:ZXHomeFloorsModel?
    fileprivate var goodsList = [ZXRecommendGoodsModel]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageHeight.constant = ZX_FLOOR_IMAGE_HEIGHT
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = UIColor.clear
        self.ccvList.backgroundColor = UIColor.clear
        
        self.ccvList.contentInset = UIEdgeInsetsMake(0, 8, 0, 8)
        self.ccvList.register(UINib(nibName: ZXGoodsWithNameCCVCell.NibName, bundle: nil), forCellWithReuseIdentifier: ZXGoodsWithNameCCVCell.reuseIdentifier)
        self.ccvList.register(UINib(nibName: ZXSeeMoreCCVCell.NibName, bundle: nil), forCellWithReuseIdentifier: ZXSeeMoreCCVCell.reuseIdentifier)
        self.ccvList.delegate = self
        self.ccvList.dataSource = self

        self.imgvMainIcon.backgroundColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func imgLinkAction(_ sender: Any) {
        if let model = self.floorModel {
            ZXRouter.showLinkType(.floorGoodsList, model: model)
        }
    }
    
    func reloadData(_ model:ZXHomeFloorsModel) {
        self.floorModel = model
        self.imgvMainIcon.image = nil
        self.imgvMainIcon.kf.setImage(with: URL(string:model.mainUrlStr), placeholder: UIImage.Default.goods, options: nil, progressBlock: nil, completionHandler: nil)
        self.goodsList = model.promotionDetailList
        self.ccvList.reloadData()
    }
}

extension ZXFloorType1TableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == self.goodsList.count {//查看更多
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZXSeeMoreCCVCell.reuseIdentifier, for: indexPath) as! ZXSeeMoreCCVCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZXGoodsWithNameCCVCell.reuseIdentifier, for: indexPath) as! ZXGoodsWithNameCCVCell
        cell.reloadData(self.goodsList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.goodsList.count > 0 {
            return self.goodsList.count + 1
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ZXFloorType1TableViewCell: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.goodsList.count {
            if let floor = self.floorModel {
                ZXRouter.showLinkType(floor.zx_linkType, model: floor)
            }
        } else {
            ZXRouter.showDetail(type: .goodsDetail, model: self.goodsList[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == self.goodsList.count {//查看更多
            return CGSize(width: 30, height: ZXHorizontalTableCell.height)
        }
        return CGSize(width: ZXHorizontalTableCell.width, height: ZXHorizontalTableCell.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension ZXFloorType1TableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentWidth = scrollView.contentSize.width
        let offsetx = scrollView.contentOffset.x + ZXBOUNDS_WIDTH
        if contentWidth - offsetx <= -30 {
            if let model = self.floorModel {
                ZXRouter.showLinkType(.floorGoodsList, model: model)
            }
        }
    }
}
