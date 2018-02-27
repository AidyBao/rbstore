//
//  ZXHomepageViewController+Banner.swift
//  rbstore
//
//  Created by screson on 2017/7/21.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import ZXAutoScrollView

extension ZXHomepageViewController: ZXAutoScrollViewDelegate {
    func zxAutoScrolView(_ scrollView: ZXAutoScrollView, selectAt index: Int) {
        let model = self.bannerList[index]
        ZXRouter.showLinkType(model.zx_linkType, model: model)
    }
}

extension ZXHomepageViewController: ZXAutoScrollViewDataSource {
    func numberofPages(_ inScrollView: ZXAutoScrollView) -> Int {
        return self.bannerList.count
    }
    
    func zxAutoScrollView(_ scrollView: ZXAutoScrollView, pageAt index: Int) -> UIView {
        let imgv = UIImageView.init()
        imgv.contentMode = .scaleAspectFill
        imgv.clipsToBounds = true
        let url = self.bannerList[index].mainUrlStr
        imgv.kf.setImage(with: URL(string:url), placeholder: UIImage.Default.goods, options: nil, progressBlock: nil, completionHandler: nil)
        return imgv
    }
}
