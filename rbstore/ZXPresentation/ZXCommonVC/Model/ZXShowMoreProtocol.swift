//
//  ZXShowMoreProtocol.swift
//  rbstore
//
//  Created by screson on 2017/7/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import Foundation

enum ZXShowMoreType {
    case categoryList
    case goodsDetail
    case none
}

protocol ZXShowMoreProtocol: class {
    func zxScrollToShowMore(type:ZXShowMoreType)
    func zxGoodsTopImageSelected(at index:Int,for cell:ZXGoodsTopImagesCell)

}

extension ZXShowMoreProtocol {
    func zxScrollToShowMore(type:ZXShowMoreType){}
    func zxGoodsTopImageSelected(at index:Int,for cell:ZXGoodsTopImagesCell){}
}
