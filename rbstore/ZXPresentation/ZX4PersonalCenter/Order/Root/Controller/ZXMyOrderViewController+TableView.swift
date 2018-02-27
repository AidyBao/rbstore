//
//  ZXMyOrderViewController+TableView.swift
//  rbstore
//
//  Created by 120v on 2017/8/14.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension ZXMyOrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSoure.count != 0 {
            let superModel = self.dataSoure.object(at: indexPath.section) as! RBOrderRootModel
            self.pushToDetailController(superModel)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var subArray = NSMutableArray()
        var superModel = RBOrderRootModel()
        if self.dataSoure.count != 0 {
            superModel = self.dataSoure.object(at: indexPath.section) as! RBOrderRootModel
            subArray = superModel.orderDetailList
        }
        
        var cellH: CGFloat = 0
        switch indexPath.row {
        case 0:
            cellH = 40.0
        case subArray.count + 2 - 1:
            if superModel.orderStatus == 1,superModel.payStatus == 1 || superModel.orderStatus == 2 {
                cellH = 40.0
            }else{
                cellH = 72.5
            }
        default:
            cellH = OrderCell_Height
        }
        return cellH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5.0
        }
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension ZXMyOrderViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dataSoure.count != 0 {
            return self.dataSoure.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSoure.count != 0 {
            let superModel = self.dataSoure.object(at: section) as! RBOrderRootModel
            let subArray = superModel.orderDetailList
            if subArray.count != 0 {
                return subArray.count + 2
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var subArray = NSMutableArray()
        var superModel = RBOrderRootModel()
        var subModel = RBOrderDetailModel()
        if self.dataSoure.count != 0 {
            superModel = self.dataSoure.object(at: indexPath.section) as! RBOrderRootModel
            subArray = superModel.orderDetailList
        }
        
        switch indexPath.row {
        case 0:
            let headerCell: RBMyOrderHeader = tableView.dequeueReusableCell(withIdentifier: RBMyOrderHeader.RBMyOrderHeaderID, for: indexPath) as! RBMyOrderHeader
            headerCell.selectionStyle = UITableViewCellSelectionStyle.none
            headerCell.loadData(superModel)
            return headerCell
        case subArray.count + 2 - 1:
            let footerCell: RBMyOrderFooter = tableView.dequeueReusableCell(withIdentifier: RBMyOrderFooter.RBMyOrderFooterID, for: indexPath) as! RBMyOrderFooter
            footerCell.selectionStyle = UITableViewCellSelectionStyle.none
            footerCell.delegate = self
            footerCell.loadData(superModel)
            return footerCell
        default:
            let rootCell: RBMyOrderCell = tableView.dequeueReusableCell(withIdentifier: RBMyOrderCell.RBMyOrderCellID, for: indexPath) as! RBMyOrderCell
            rootCell.selectionStyle = UITableViewCellSelectionStyle.none
            if subArray.count != 0 {
                subModel = subArray.object(at: indexPath.row - 1) as! RBOrderDetailModel
                rootCell.loadData(subModel)
            }
            return rootCell
        }
    }
}

extension ZXMyOrderViewController: RBMyOrderFooterDelegate {
    
    func didSelectedButtonAction(_ sender: UIButton,_ model: RBOrderRootModel) {
        
        switch sender.tag {
        case RBMyOrderFooter.OrderButton.checkTag:
            if (sender.titleLabel?.text?.isEqual(ButtonStatus.nowPay))! {//立即付款
                self.nowPayOrder(model)
            }
            if (sender.titleLabel?.text?.isEqual(ButtonStatus.confirm))! {//确认收货
                self.confirmReceive(model)
            }
            if (sender.titleLabel?.text?.isEqual(ButtonStatus.checkLogistics))! {//查看物流
                self.checkLogistics(model)
            }
            break
        case RBMyOrderFooter.OrderButton.deleteTag:
            if (sender.titleLabel?.text?.isEqual(ButtonStatus.cancelOrder))! {//取消订单
                ZXAlertUtils.showAlert(wihtTitle: "", message: "要取消此订单吗?", buttonTexts: ["取消","确认"], action: { (index) in
                    switch index {
                    case 1:
                        self.cancelOrder(model)
                    default:
                        break
                    }
                })
            }
            
            if (sender.titleLabel?.text?.isEqual(ButtonStatus.deleteOrder))! {//删除订单
                ZXAlertUtils.showAlert(wihtTitle: "", message: "要删除此订单吗?", buttonTexts: ["取消","确认"], action: { (index) in
                    switch index {
                    case 1:
                        self.deleteOrder(model)
                    default:
                        break
                    }
                })
            }
            
            if (sender.titleLabel?.text?.isEqual(ButtonStatus.checkLogistics))! {//产看物流
                self.checkLogistics(model)
            }
            
        default:
            break
        }
    }
}

//MARK: - HTTP
extension ZXMyOrderViewController {
   
    func requestForOrderList(_ isHUD: Bool) {
        var params:Dictionary<String,Any> = Dictionary.init()
        if self.orderStatus?.hashValue != 0 {
            params["orderStatus"] = self.orderStatus?.hashValue
        }
        params["pageNum"] = (self.currentPageIndex <= 0 ? 1 : self.currentPageIndex)
        params["pageSize"] = (ZX_PAGE_SIZE <= 0 ? 0 : ZX_PAGE_SIZE)
        if isHUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD_MBDELAY_TIME)
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.getOrderList), params: params.zx_signDic(), method: .post) { (success, status, content, string, error) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tableView, animated: true)
            ZXEmptyView.hide(from: self.tableView)
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if success {
                if status == ZXAPI_SUCCESS{
                    let dict:Dictionary<String,Any> = content["data"] as! Dictionary
                    self.totalPageNum = dict["pageTotal"] as! NSInteger
                    let tempArray:NSMutableArray = NSMutableArray.init(capacity: 5)
                    if let list = dict["listData"] as? Array<Any> {
                        for dict in list{
                            let model:RBOrderRootModel = RBOrderRootModel.mj_object(withKeyValues: dict)
                            tempArray.add(model)
                        }
                        
                        if self.currentPageIndex == 1 {
                            if tempArray.count != 0 {
                                self.dataSoure = tempArray.mutableCopy() as! NSMutableArray
                            }else{
                                ZXEmptyView.show(in: self.view, type: .noData, text: "您还没有相关订单", retry: {
                                    ZXEmptyView.hide(from: self.view)
                                    self.refreshForHeader()
                                })
                            }
                        }else{
                            if tempArray.count != 0 {
                                self.dataSoure.addObjects(from: tempArray as! [Any])
                            }
                        }
                        
                        if self.dataSoure.count == 0 {
                            ZXEmptyView.show(in: self.view, type: .noData, text: "您还没有相关订单", retry: {
                                ZXEmptyView.hide(from: self.view)
                                self.refreshForHeader()
                            })
                        }else if self.currentPageIndex >= self.totalPageNum {
                            self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        }
                    }else{
                        ZXEmptyView.show(in: self.view, type: .noData, text: "您还没有相关订单", retry: {
                            ZXEmptyView.hide(from: self.view)
                            self.refreshForHeader()
                        })
                    }
                    self.tableView.reloadData()
                }
            }else if status != ZXAPI_LOGIN_INVALID{
                ZXNetwork.errorCodeParse(status, httpError: {
                    ZXEmptyView.show(in: self.view, type: .networkError, text: "请检查您的网路", retry: {
                        ZXEmptyView.hide(from: self.view)
                        self.requestForOrderList(true)
                    })
                }, serverError: {
                    ZXEmptyView.show(in: self.view, type: .networkError, text: error?.description, retry: {
                        ZXEmptyView.hide(from: self.view)
                        self.requestForOrderList(true)
                    })
                })
            }
        }
    }
}
