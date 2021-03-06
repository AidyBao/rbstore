//
//  ZXHomeCategoryTableViewCell.swift
//  rbstore
//
//  Created by screson on 2017/7/21.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXHomeCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ccView: UICollectionView!
    fileprivate var list = [ZXShortCategoryModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.ccView.register(UINib(nibName: ZXHomeCategoryCollectionViewCell.NibName, bundle: nil), forCellWithReuseIdentifier: ZXHomeCategoryCollectionViewCell.reuseIdentifier)
        self.ccView.delegate = self
        self.ccView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadData(_ lists:[ZXShortCategoryModel]) {
        self.list = lists
        self.ccView.reloadData()
    }
}

extension ZXHomeCategoryTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZXHomeCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! ZXHomeCategoryCollectionViewCell
        cell.reloadData(self.list[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension ZXHomeCategoryTableViewCell: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ZXRouter.showDetail(type: .categoryList, model: self.list[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ZXBOUNDS_WIDTH / 4
        return CGSize(width: width, height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
