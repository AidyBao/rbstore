//
//  ZXGoodsDetailModel.swift
//  rbstore
//
//  Created by screson on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

enum ZXGoodsStatus:Int {
    case invalid = 0
    case outofSale = 1
    case inSale = 2
    case outofStock = 99  //全部商品无货
    
    func description() -> String {
        switch self {
            case .invalid:
                return "商品已失效"
            case .outofSale:
                return "商品已下架"
            case .inSale:
                return "商品销售中"
            case .outofStock:
                return "商品缺货"
        }
    }
}

class ZXGoodsDetailModel: ZXShowModel {
    var product:ZXProduct?
    var productParameterList = [ZXGoodsParams]()        //商品详情参数
    var sortRecommendList = [ZXRecommendGoodsModel]()   //同类商品列表
    var specList = [ZXGoodsSpec]()                      //大规格项
    var specProductList = [ZXSpecCombo]()               //所有有效规格组合列表
    var specPictureList = [ZXSpecPicture]()             //组合规格 图片
    var dictList = [ZXFreight]()    //运费
    
    
    var zx_selectedSpecCombo:ZXSpecCombo?
    
    
    var zx_defaultSpecValid:Bool {
        get {
            var spec = self.zx_selectedSpecCombo
            if spec == nil {
                spec = self.product?.zx_defaultSpec
            }
            if let spec = spec {
                if self.zx_specCombo(by: spec.zx_sortedIdsStr) != nil {
                    //存在改规格组合 没有失效
                    //商品详情显示 组合文字
                    return true
                }
            }
            //商品详情 显示 （规格数量选择）
            return false
        }
    }
    
    //订单状态
    var zx_status: ZXGoodsStatus {
        get {
            if let product = product {
                if product.zx_status == .inSale {
                    if specProductList.count == 0 { //无任何有效组合
                        return .invalid //商品失效
                    } else {
                        var outofStock = true
                        for specCombo in specProductList {
                            if specCombo.stock > 0 {
                                outofStock = false
                                break
                            }
                        }
                        if outofStock {//全部组合无货
                            return .outofStock
                        }
                        return .inSale
                    }
                }
                return product.zx_status //下架 失效
            }
            return .invalid
        }
    }
    //运费
    var zx_freight:String {
        get {
            if dictList.count > 0 {
                var type1:ZXFreight?
                var type2:ZXFreight?
                for f in dictList {
                    if f.key == 1 {
                        type1 = f
                    } else if f.key == 2 {
                        type2 = f
                    }
                }
                if let type1 = type1,let type2 = type2 {
                    if let value = Double(type1.value),value == 0 {
                        return "包邮"
                    } else {
                        return type2.description
                    }
                }
            }
            return "无"
        }
    }
    //运费说明
    var zx_freightRemark:String {
        get {
            if dictList.count > 0 {
                var fRemark:ZXFreight?
                for f in dictList {
                    if f.key == 3 {
                        fRemark = f
                        break
                    }
                }
                if let f = fRemark {
                    return f.remark
                }
            }

            return "无"
        }
    }
    /// 多重规格大标题
    fileprivate var _allSpecKeys:[String]?
    var zx_allSpecKeys:[String] {
        get {
            if let allkeys = _allSpecKeys {
                return allkeys
            } else {
                var keys = [String]()
                for spec in self.specList {
                    keys.append(spec.name)
                }
                _allSpecKeys = keys
                return keys
            }
            
        }
    }
    
    /// 规格选项 大标题
    ///
    /// - Parameter section: section description
    /// - Returns: return value description
    func zx_SpecKeyAtSection(_ section:Int) -> String? {
        if section < self.zx_allSpecKeys.count {
            return self.zx_allSpecKeys[section]
        }
        return nil
    }
    
    /// 查询规格选项位置
    ///
    /// - Parameter spec: spec description
    /// - Returns: return value description
    func zx_specItemIndexpath(_ specImteId:String) -> IndexPath? {
        var indexPath: IndexPath?
        if self.specList.count > 0 {
            for (section,goodsSpec) in self.specList.enumerated() {
                for (row,item) in goodsSpec.specOptionList.enumerated() {
                    if specImteId == item.id {
                        indexPath = IndexPath(row: row, section: section)
                        break
                    }
                }
            }
        }
        return indexPath
    }
    
    //不同规格---所有规格选项
    fileprivate var _allSpecItems:[ZXSpecItem]?
    var zx_allSpecItem:[ZXSpecItem] {
        get {
            if let allSpecItems = _allSpecItems {
                return allSpecItems
            } else {
                var items = [ZXSpecItem]()
                for list in self.specList {
                    for item in list.specOptionList {
                        items.append(item)
                    }
                }
                _allSpecItems = items
                return items
            }
            
        }
    }
    //同一组Id
    func zx_specItemsAt(section:Int) -> [ZXSpecItem]? {
        if self.specList.count > 0 {
            return self.specList[section].specOptionList
        }
        return nil
    }
    
    //根据规格选项id 获取规格项
    func zx_specItem(from sid:String) -> ZXSpecItem? {
        var item: ZXSpecItem?
        let items = self.zx_allSpecItem
        for spec in items {
            if sid == spec.id {
                item = spec
                break
            }
        }
        return item
    }
    
    
    
    /// 通过规格组合排序Id 获取规格商品
    ///
    /// - Parameter sortedIdsStr: sortedIdsStr description
    /// - Returns: return value description
    func zx_specCombo(by sortedIdsStr:String) -> ZXSpecCombo? {
        var specCombo:ZXSpecCombo?
        
        for c in self.specProductList {
//            if c.specOptionIds == sortedIdsStr { //specOptionIds 数值排序 1,7,14  sortedIdsStr 字符排序1,14,7
//                specCombo = c
//                break
//            }
            let optionIds = Set.init(c.zx_ids)
            let sIds = Set.init(sortedIdsStr.components(separatedBy: ","))
            if optionIds.intersection(sIds) == sIds {
                specCombo = c
                break
            }
        }
        return specCombo
    }
    /// 通过规格组合排序Id 获取规格商品图片
    ///
    /// - Parameter sortedIdsStr: sortedIdsStr description
    /// - Returns: return value description
    func zx_specComboPic(by sortedIdsStr:String) -> String? {
        var strURL:String?
        for c in self.specPictureList {
            let a = c.specOptionIds.components(separatedBy: ",")
            let b = sortedIdsStr.components(separatedBy: ",")
            if b.count == a.count {//数量相同 绝对匹配规格
//                if c.specOptionIds == sortedIdsStr { //specOptionIds 数值排序 1,7,14  sortedIdsStr 字符排序1,14,7
//                    strURL = c.mainUrlStr
//                    break
//                }
                let optionIds = Set.init(c.zx_ids)
                let sIds = Set.init(sortedIdsStr.components(separatedBy: ","))
                if optionIds.intersection(sIds) == sIds {
                    strURL = c.mainUrlStr
                    break
                }
                
            } else {
                let setA = Set.init(a)
                let setB = Set.init(b)
                if setB.intersection(setA).count > 0 {
                    strURL = c.mainUrlStr
                    break
                }
            }
        }
        return strURL
    }
    
    func markSpec(for sid:String,mark:Bool) {
        if let spec = self.zx_specCombo(by: sid) {
            spec.isFavorite = mark ? "1" : "0"
        }
    }
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["specList":ZXGoodsSpec.self,
                "productParameterList":ZXGoodsParams.self,
                "sortRecommendList":ZXRecommendGoodsModel.self,
                "specProductList":ZXSpecCombo.self,
                "specPictureList":ZXSpecPicture.self,
                "dictList":ZXFreight.self]
    }
    
    var zx_paramsInfo:String {
        get {
            if self.productParameterList.count > 0 {
                var str = "<body style=\"margin : 0\"><table style=\"border-spacing: 0;width:100%\">"
                for p in self.productParameterList {
                    str += "<tr>"
                    str += "<td style=\"word-wrap: break-word;word-break: break-all;font-size:13px; padding:10px; color: #777;border-bottom: 0.5px solid #e0e0e0;width:50%\" >\(p.name)</td>"
                    str += "<td style=\"word-wrap: break-word;word-break: break-all;font-size:13px; padding:10px; color: #777;text-align:left;border-bottom: 0.5px solid #e0e0e0;\">\(p.value)</td>"
                    str += "</tr>"
                }
                str += "</table></body>"
                return str
            } else {
                var str = "<body style=\"margin : 0\"><table style=\"border-spacing: 0;width:100%\">"
                str += "<tr>"
                str += "<td style=\"font-size:13px; padding:10px; color: #777; \" >无相关参数</td>"
                str += "</tr>"
                str += "</table></body>"
                return str
            }
        }
    }
    
    static var zx_emptyHtml:String {
        get {
            var str = "<body style=\"margin : 0\"><table style=\"border-spacing: 0;width:100%\">"
            str += "<tr>"
            str += "<td style=\"font-size:13px; padding:10px; color: #777; \" >无相关信息</td>"
            str += "</tr>"
            str += "</table></body>"
            return str
        }
    }
}

class ZXProduct: NSObject {
    var id:String = "" //商品ID
    var sortId:String = ""
    var sortName:String = ""
    var title:String = ""
    var subtitle:String = ""
    var status:Int = 0                      // 0 作废 1 下架 2 上架
    var mainUrlStr:String = ""              //主图 未选择规格时显示
    var subPicsList = [ZXGoodsPicture]()    //主图+商品图片
    var detailPicsList = [ZXGoodsPicture]() //商品详情图片
    
    var zx_status:ZXGoodsStatus {
        get {
            return ZXGoodsStatus.init(rawValue: self.status) ?? .invalid
        }
    }
    
    //默认规格
    var salePrice:Double = 0
    var stock:Int = 0
    var specOptionIds:String = ""           //当前商品默认规格 "1,4" 寻找规格商品ID
    var isFavorite:String = ""
    var specProductId:String = ""           //  规格商品id
    
    var zx_defaultSpec:ZXSpecCombo? {
        get {
            if self.specOptionIds.characters.count > 0 {
                let specCombo = ZXSpecCombo()
                specCombo.specOptionIds = self.specOptionIds
                specCombo.salePrice = self.salePrice
                specCombo.stock = self.stock
                specCombo.isFavorite = self.isFavorite
                specCombo.id = self.specProductId
                return specCombo
            }
            return nil
        }
    }
    
    var zx_detailInfo:String {
        get {
            if self.detailPicsList.count > 0 {
                var str = "<body style=\"margin : 0\"><div style=\"border-spacing: 0;width:100%\">"
                for p in self.detailPicsList {
                    str += "<div>"
                    str += "<img style=\"width:100%; height:auto;\" src=\"\(p.urlStr)\">"
                    str += "</div>"
                }
                str += "</div></body>"
                return str
            } else {
                var str = "<body style=\"margin : 0\"><table style=\"border-spacing: 0;width:100%\">"
                str += "<tr>"
                str += "<td style=\"font-size:13px; padding:10px; color: #777; \" >无相关详情</td>"
                str += "</tr>"
                str += "</table></body>"
                return str
            }
        }
    }
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["subPicsList":ZXGoodsPicture.self,
                "detailPicsList":ZXGoodsPicture.self]
    }
}


/// 商品、规格图片
class ZXGoodsPicture: NSObject {
    var name: String = ""   //附件名称
    var urlStr: String = "" //附件地址
}

/// 商品参数
class ZXGoodsParams: NSObject {
    var productId:String = ""
    var name:String = ""
    var value:String = ""
}

/// 商品规格
class ZXGoodsSpec: NSObject {
    var id:String = ""
    var name:String = ""                //规格名称
    var specOptionList = [ZXSpecItem]() //规格选项
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["specOptionList":ZXSpecItem.self]
    }
}

/// 规格选项值

enum ZXSpecItemType {
    case valid      //可选
    case soldOut    //无库存 可点击
    case notExist   //不存在 不可点击 规格商家编码为空
}

class ZXSpecItem: NSObject {
    var id:String = ""          //规格选项Id
    //var specId:String = ""
    var value:String = ""       //规格-选项值
    
    var zx_isSelected = false
    var zx_selectType:ZXSpecItemType = ZXSpecItemType.valid
    
    var zx_size:CGSize {
        get {
            if value.characters.count > 0 {
                //var size = value.zx_textRectSize(toFont: UIFont.zx_bodyFont, limiteSize: CGSize(width: ZXBOUNDS_WIDTH - 54 - 10, height: 100))
                var size = value.zx_textRectSize(toFont: UIFont.zx_bodyFont, limiteSize: CGSize(width: ZXBOUNDS_WIDTH - 54 - 10, height: 24))//一行
                if size.width < 60 {
                    size.width = 60
                } else {
                    size.width += 10
                }
                if size.height < 24 {
                    size.height = 24
                }
                return size
            }
            return CGSize(width: 60, height: 24)
        }
    }
}


/// 规格组合 - 有效的规格 库存 id 价格
class ZXSpecCombo: NSObject {
    var skuCode:String?             //商家编码（为空--表示无次规格）
    var id:String = ""              //规格商品Id
    var productId:String = ""
    var stock:Int = 0               //库存
    var specOptionIds:String = ""   //规格组合列表  排序之后 比对字符串 1,2 3,5
    var salePrice:Double = 0        //该规格对应的价格
    var isFavorite:String = ""      //
    
    var zx_buyNum:Int = 1           //
    
    var zx_isFavorite:Bool {
        get {
            if self.isFavorite == "1" {
                return true
            }
            return false
        }
    }
    
    //组合拆分 规格项id
    var zx_ids:[String] {
        get {
            var ids = [String]()
            ids = specOptionIds.components(separatedBy: ",")
            return ids
        }
    }
    
    var zx_sortedIdsStr:String {
        get {
            var ids = self.zx_ids
            ids.sort { $0 < $1 }
            return ids.joined(separator: ",")
        }
    }
    
    var zx_specOptionValues:String = "" //规格组合名称 由于购物车修改规格
    
    func zx_descriptionIn(_ items:[ZXSpecItem]) -> String {
        var desc = [String]()
        var ids = self.zx_ids
        ids.sort { $0 < $1 } //确保描述文字顺序一致
        for sId in ids {
            for spec in items {
                if sId == spec.id {
                    desc.append(spec.value)
                    break
                }
            }
        }
        return desc.joined(separator: ",")
    }
    
    var zx_selectType:ZXSpecItemType {
        get {
            if let code = self.skuCode,code.characters.count > 0 {
                if self.stock > 0 {
                    return ZXSpecItemType.valid
                } else {
                    return ZXSpecItemType.soldOut
                }
            }
            return ZXSpecItemType.notExist
        }
    }
}

/// 规格组合 - 有效的规格 图片
class ZXSpecPicture: NSObject {
    var specOptionIds:String = ""   //规格组合列表  排序之后 比对字符串 1,2 3,5
    var mainUrlStr:String = ""      //该规格对应的图片
    
    var zx_ids:[String] {
        get {
            var ids = [String]()
            ids = specOptionIds.components(separatedBy: ",")
            return ids
        }
    }
}

class ZXFreight: NSObject {
    var key:Int = 1         //1 包邮说明(value = 0 包邮，> 0 运费x元) 2 满免 3 运费说明
    var value:String = ""   //运费价格
    var remark:String = ""
    
    override var description: String {
        get {
            if key == 1 {
                if let value = Double(self.value),value == 0 {
                    return "包邮"
                }
                return "运费\(value)元"
            } else {
                if let value = Double(self.value),value == 0 {
                    return "包邮"
                } else {
                    return "满\(value)元包邮"
                }
            }
        }
    }
}
