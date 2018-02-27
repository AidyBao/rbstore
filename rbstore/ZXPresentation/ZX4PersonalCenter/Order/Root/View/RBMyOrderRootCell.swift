//
//  RBMyOrderRootCell.swift
//  rbstore
//
//  Created by 120v on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

protocol RBMyOrderRootCellDelegate: NSObjectProtocol {
    func didSelectedOrderButtonAction(_ sender: UIButton,_ model: RBOrderRootModel,_ scrollCurrentIndex: NSInteger)
    func didSelectRowAt(_ tableView: UITableView, _ orderRootModle: RBOrderRootModel, didSelectRowAt indexPath: IndexPath)
    func didSelectHeaderAction(_ model: RBOrderRootModel)
    func didSelectFooterAction(_ model: RBOrderRootModel)
}

class RBMyOrderRootCell: UICollectionViewCell {
    
    static let RBMyOrderRootCellID:String = "RBMyOrderRootCell"
    weak var delegate: RBMyOrderRootCellDelegate?
    @IBOutlet weak var tableView: UITableView!
    var orderStatus: RBOrderStatus?
    var scrollViewIndex: NSInteger  = 0
    var currentPageIndex: NSInteger = 0
    var totalPageNum: NSInteger     = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUIStyle()
        
        self.setRefresh()
    }
    
    //MARK: - UI
    func setUIStyle() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName:String.init(describing: RBMyOrderCell.self), bundle: nil), forCellReuseIdentifier: RBMyOrderCell.RBMyOrderCellID)
        self.tableView.register(UINib.init(nibName:String.init(describing: RBMyOrderHeaderCell.self), bundle: nil), forHeaderFooterViewReuseIdentifier: RBMyOrderHeaderCell.RBMyOrderHeaderCellID)
        self.tableView.register(UINib.init(nibName:String.init(describing: RBMyOrderFooterCell.self), bundle: nil), forHeaderFooterViewReuseIdentifier: RBMyOrderFooterCell.RBMyOrderFooterCellID)
    }
    
    //MARK: - 数据源 
    func loadData(_ status: RBOrderStatus , _ newScrollIndex: NSInteger) {
        print(self.orderStatus ?? .all,status , newScrollIndex)
        
        if self.orderStatus == status {
            return
        }
        self.scrollViewIndex = newScrollIndex
        self.orderStatus = status
        //
        self.refreshForHeader()
    }
    
    //MARK: - 刷新
    func setRefresh() ->Void{
        self.tableView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.tableView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForFooter))
    }
    
    func refreshForHeader() -> Void{
        self.currentPageIndex = 1
        self.requestForOrderList(true)
    }
    
    func refreshForFooter() -> Void{
        self.currentPageIndex += 1
        self.requestForOrderList(false)
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    lazy var dataSoure: NSMutableArray = {
        let arr: NSMutableArray = NSMutableArray.init(capacity: 5)
        return arr
    }()
}

extension RBMyOrderRootCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSoure.count != 0 {
            let superModel = self.dataSoure.object(at: indexPath.section) as! RBOrderRootModel
            delegate?.didSelectRowAt(tableView,superModel,didSelectRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 45.0
        }
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var footerH: CGFloat = 0
        if self.dataSoure.count != 0 {
            let superModel = self.dataSoure.object(at: section) as! RBOrderRootModel
            if superModel.orderStatus == 2 {
                footerH = 40.0
            }else{
                footerH = 68.5
            }
        }
        return footerH
    }
}

extension RBMyOrderRootCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSoure.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSoure.count != 0 {
            let superModel = self.dataSoure.object(at: section) as! RBOrderRootModel
            let subArray = superModel.orderDetailList 
            if subArray.count != 0 {
                return subArray.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rootCell: RBMyOrderCell = tableView.dequeueReusableCell(withIdentifier: RBMyOrderCell.RBMyOrderCellID, for: indexPath) as! RBMyOrderCell
        rootCell.selectionStyle = UITableViewCellSelectionStyle.none
        if self.dataSoure.count != 0 {
            let superModel = self.dataSoure.object(at: indexPath.section) as! RBOrderRootModel
            let subArray = superModel.orderDetailList
            if subArray.count != 0 {
                let subModel = subArray.object(at: indexPath.row) as? RBOrderDetailModel
                rootCell.loadData(subModel!)
            }
        }
        return rootCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell: RBMyOrderHeaderCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: RBMyOrderHeaderCell.RBMyOrderHeaderCellID) as! RBMyOrderHeaderCell
        headerCell.delegate = self
        if self.dataSoure.count != 0 {
            let superModel = self.dataSoure.object(at: section) as! RBOrderRootModel
            headerCell.loadData(superModel)
        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell: RBMyOrderFooterCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: RBMyOrderFooterCell.RBMyOrderFooterCellID) as! RBMyOrderFooterCell
        footerCell.delegate = self
        if self.dataSoure.count != 0 {
            let superModel = self.dataSoure.object(at: section) as! RBOrderRootModel
            footerCell.loadData(superModel)
        }
        return footerCell
    }
}

extension RBMyOrderRootCell:RBMyOrderHeaderCellDelegate {
    func didHeaderCellAction(_ sender: UITapGestureRecognizer, _ model: RBOrderRootModel) {
        if delegate != nil {
            delegate?.didSelectHeaderAction(model)
        }
    }
}

extension RBMyOrderRootCell: RBMyOrderFooterCellDelegate {
    
    func didFooterCellAction(_ sender: UITapGestureRecognizer, _ model: RBOrderRootModel) {
        if delegate != nil {
            delegate?.didSelectFooterAction(model)
        }
    }
    
    func didSelectedButtonAction(_ sender: UIButton,_ model: RBOrderRootModel) {
        if delegate != nil {
            delegate?.didSelectedOrderButtonAction(sender,model,self.currentPageIndex)
        }
    }
}

//MARK: - HTTP
extension RBMyOrderRootCell {
    func requestForOrderList(_ isHUD: Bool) {
        var params:Dictionary<String,Any> = Dictionary.init()
        
        if self.orderStatus?.hashValue != 0 {
            params["orderStatus"] = self.orderStatus?.hashValue
        }
        params["pageNum"] = (self.currentPageIndex <= 0 ? 1 : self.currentPageIndex)
        params["pageSize"] = (ZX_PAGE_SIZE <= 0 ? 0 : ZX_PAGE_SIZE)
        if isHUD {
            ZXHUD.showLoading(in: self, text: ZX_LOADING_TEXT, delay: 0)
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.getOrderList), params: params.zx_signDic(), method: .post) { (success, status, content, string, error) in
            ZXHUD.hide(for: self, animated: true)
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            ZXEmptyView.hide(from: self)
            ZXEmptyView.hide(from: self.tableView)

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
                                ZXEmptyView.show(in: self, type: .noData, text: "您还没有相关订单", retry: nil)
                            }
                        }else{
                            if tempArray.count != 0 {
                                self.dataSoure.addObjects(from: tempArray as! [Any])
                            }
                        }
                        
                        if self.currentPageIndex >= self.totalPageNum {
                            self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        }
                        
                    }else{
                        ZXEmptyView.show(in: self, type: .noData, text: "您还没有相关订单", retry: nil)
                    }
                    self.tableView.reloadData()
                }
            }else if status != ZXAPI_LOGIN_INVALID{
                if self.currentPageIndex == 1 {
                    ZXEmptyView.show(in: self, type: .networkError, text: nil, retry: {
                        ZXEmptyView.hide(from: self)
                        self.requestForOrderList(true)
                    })
                }else{
                    ZXHUD.showLoading(in: self, text: (error?.errorMessage)!, delay: 1.5)
                }
            }
        }
    }
    
    func addTempData() {
        print(self.orderStatus!,self.currentPageIndex)
        
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
        
        self.dataSoure.removeAllObjects()
//        switch self.orderStatus {
//        case .all:
//            self.loadTempData(4)
//        case .waitPay:
//            self.loadTempData(2)
//        case .waitSend:
//            self.loadTempData(1)
//        case .shipped:
//            self.loadTempData(6)
//        default:
//            break
//        }
        
        self.tableView.reloadData()
    }
    
    func loadTempData(_ count: Int) {
//        for i in 0..<count {
//            let rootModel: RBOrderRootModel = RBOrderRootModel.init()
//            rootModel.status = i
//            for j in 0..<count {
//                let subModel: RBOrderDetailModel = RBOrderDetailModel.init()
//                subModel.status = j
//                rootModel.orderDetailList.add(subModel)
//            }
//            self.dataSoure.add(rootModel)
//        }
    }
}
