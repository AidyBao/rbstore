//
//  ZXSingleImageTableViewCell.swift
//  rbstore
//
//  Created by screson on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit


/// 单张图片楼层Cell
class ZXSingleImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imgvIcon: UIImageView!
    fileprivate var floorModel:ZXHomeFloorsModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.imgvIcon.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        self.imgvIcon.addGestureRecognizer(tap)
    }
    
    func reload(_ model:ZXHomeFloorsModel) {
        self.floorModel = model
        self.imgvIcon.image = nil
        self.imgvIcon.kf.setImage(with: URL(string:model.mainUrlStr), placeholder: UIImage.Default.goods, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func tapAction(_ sender: UITapGestureRecognizer) {
        if let model = self.floorModel {
            ZXRouter.showLinkType(model.zx_linkType, model: model)
        }
    }
}
