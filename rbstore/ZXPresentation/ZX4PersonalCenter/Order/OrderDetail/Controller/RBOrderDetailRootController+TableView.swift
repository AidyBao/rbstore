//
//  RBOrderDetailRootController+TableView.swift
//  rbstore
//
//  Created by 120v on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension RBOrderDetailRootController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 2:
            if self.orderRootModel != nil {
                let arr = self.orderRootModel.orderDetailList
                if arr.count != 0 {
                    let detailModel = arr.object(at: indexPath.row) as! RBOrderDetailModel
                    let zxGoodModel = ZXGoodsModel.init()
                    zxGoodModel.productId = "\(detailModel.productId)"
                    zxGoodModel.specProductId = "\(detailModel.specProductId)"
                    zxGoodModel.salePrice = Double(detailModel.price)
                    zxGoodModel.title = detailModel.productName
                    zxGoodModel.mainUrlStr = detailModel.mainUrl
                    ZXRouter.showDetail(type: .goodsDetail, model: zxGoodModel)
                }
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellH: CGFloat = 0
        switch indexPath.section {
        case 0:
            cellH = 70.0
        case 1:
            cellH = UITableViewAutomaticDimension
        case 2:
            cellH = OrderCell_Height
        case 3:
            if indexPath.row == 4 {
                if self.orderRootModel != nil,self.orderRootModel.remark != "" {
                    cellH = UITableViewAutomaticDimension
                }else{
                    cellH = 31.5
                }
            }else{
                cellH = 31.5
            }
        default:
            break
        }
        return cellH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var cellH: CGFloat = 0
        switch section {
        case 0:
            cellH = CGFloat.leastNormalMagnitude
        case 1:
            cellH = 10.0
        case 2:
            cellH = 10.0
        case 3:
            cellH = 10.0
        default:
            break
        }
        return cellH
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 3 {
            return 10
        }
        return CGFloat.leastNormalMagnitude
    }
}

extension RBOrderDetailRootController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellCount: NSInteger = 0
        switch section {
        case 0:
            cellCount = 1
        case 1:
            cellCount = 1
        case 2:
            if self.orderRootModel != nil {
                let arr = self.orderRootModel.orderDetailList
                if arr.count != 0 {
                    cellCount = arr.count
                }
            }
        case 3:
            if self.orderRootModel != nil,(self.orderRootModel.orderStatus == 3 || self.orderRootModel.orderStatus == 6) {
                cellCount = 8
            }else{
                cellCount = 7
            }
        default:
            break
        }
        
        return cellCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let headerCell: RBOrderStatusCell = tableView.dequeueReusableCell(withIdentifier: RBOrderStatusCell.RBOrderStatusCellID, for: indexPath) as! RBOrderStatusCell
            if self.orderRootModel != nil {
                headerCell.loadData(self.orderRootModel)
            }
            return headerCell
        case 1:
            let rootCell: RBOrderAddressCell = tableView.dequeueReusableCell(withIdentifier: RBOrderAddressCell.RBOrderAddressCellID, for: indexPath) as! RBOrderAddressCell
            if self.orderRootModel != nil {
                rootCell.loadData(self.orderRootModel)
            }
            return rootCell
        case 2:
            let rootCell: RBOrderItemCell = tableView.dequeueReusableCell(withIdentifier: RBOrderItemCell.RBOrderItemCellID, for: indexPath) as! RBOrderItemCell
            rootCell.selectionStyle = UITableViewCellSelectionStyle.none
            if self.orderRootModel != nil {
                let arr = self.orderRootModel.orderDetailList
                if arr.count != 0 {
                    rootCell.loadData(arr.object(at: indexPath.row) as! RBOrderDetailModel, indexPath.row, arr)
                }
            }
            return rootCell
        case 3:
            let rootCell: RBOrderDetailView = tableView.dequeueReusableCell(withIdentifier: RBOrderDetailView.RBOrderDetailViewID, for: indexPath) as! RBOrderDetailView
            if self.orderRootModel != nil {
                rootCell.loadData(indexPath.row, self.orderRootModel)
            }
            return rootCell
        default:
            break
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "UNKnow")
    }

    
}
