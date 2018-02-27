//
//  ZXGoodsTopImagesCell.swift
//  rbstore
//
//  Created by screson on 2017/7/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXGoodsTopImagesCell: UITableViewCell {

    weak var delegate: ZXShowMoreProtocol?
    fileprivate var list = [ZXGoodsPicture]()
    @IBOutlet weak var pageControl: UIPageControl!
    let lbShowDetail = ZXUILabel()
    @IBOutlet weak var ccvImgList: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.white
        self.ccvImgList.delegate = self
        self.ccvImgList.dataSource = self
        self.ccvImgList.register(UINib(nibName: ZXGoodsImgCCVCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ZXGoodsImgCCVCell.reuseIdentifier)
        lbShowDetail.typeIndex = 2
        lbShowDetail.textColor = UIColor.zx_textColorBody
        lbShowDetail.textAlignment = .center
        lbShowDetail.numberOfLines = 0
        lbShowDetail.lineBreakMode = .byWordWrapping
        lbShowDetail.text = "查\n看\n商\n品\n详\n情"
        lbShowDetail.frame = CGRect(x: 0, y: 0, width: 40, height: 270)
        self.ccvImgList.addSubview(lbShowDetail)
        self.ccvImgList.alwaysBounceHorizontal = true
        
        self.pageControl.currentPageIndicatorTintColor = UIColor.zx_tintColor
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        self.updateUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func reloadData(_ model:[ZXGoodsPicture]?) {
        if let m = model {
            self.list = m
        } else {
            self.list = []
        }
        self.ccvImgList.reloadData()
        self.updateUI()
    }
    
    fileprivate func updateUI() {
        let count = self.list.count
        if count > 0 {
            self.pageControl.isHidden = false
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = count
            self.lbShowDetail.isHidden = false
            self.lbShowDetail.x = CGFloat(count) * ZXBOUNDS_WIDTH
            
            var index = Int(self.ccvImgList.contentOffset.x / ZXBOUNDS_WIDTH)
            if index > count {
                index = count - 1
            }
            self.pageControl.currentPage = index
        } else {
            self.lbShowDetail.isHidden = true
            self.pageControl.isHidden = true
            self.pageControl.currentPage = 0
            self.pageControl.numberOfPages = 0
            self.ccvImgList.contentOffset = CGPoint.zero
        }
    }
    
}

extension ZXGoodsTopImagesCell: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.zxGoodsTopImageSelected(at: indexPath.row, for: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: ZXBOUNDS_WIDTH, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
}

extension ZXGoodsTopImagesCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZXGoodsImgCCVCell.reuseIdentifier, for: indexPath) as! ZXGoodsImgCCVCell
        let m = self.list[indexPath.row]
        cell.imgvIcon.kf.setImage(with: URL(string:m.urlStr), placeholder: UIImage.Default.goods, options: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ZXGoodsTopImagesCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.list.count > 0 {
            let offsetx = scrollView.contentOffset.x
            if offsetx > ZXBOUNDS_WIDTH * CGFloat(self.list.count - 1) + 45 {
                lbShowDetail.text = "松\n开\n立\n即\n查\n看"
            } else {
                lbShowDetail.text = "查\n看\n商\n品\n详\n情"
            }
            let page = Int(offsetx / ZXBOUNDS_WIDTH)
            self.pageControl.currentPage = page
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.list.count > 0 {
            if scrollView.contentOffset.x >= ZXBOUNDS_WIDTH * CGFloat(self.list.count - 1) + 45 {
                delegate?.zxScrollToShowMore(type: .none)
            }
        }
    }
}
