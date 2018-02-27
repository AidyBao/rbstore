//
//  RBAddressViewController.swift
//  rbstore
//
//  Created by 120v on 2017/7/20.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBAddressViewController: ZXUIViewController {
    
    var callBack: ((_ addr:RBAddressModel?) -> Void)?
    var zx_defaultAddress:RBAddressModel?
    var zx_checked = false
    @IBOutlet weak var tableView: UITableView!
    var currentPageNum:NSInteger   = 0
    var totalPageNum:NSInteger     = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "管理收货地址"
        
        //右边按钮
        self.addRightView()
        
        //刷新控件
        self.addRefreshView()

        self.tableView.register(UINib.init(nibName:String.init(describing: RBAddressRootCell.self), bundle: nil), forCellReuseIdentifier: RBAddressRootCell.RBAddressRootCellID)
    }
    
    //MARK: - 添加右边+按钮
    func addRightView() -> Void {
        let addButton:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addBtnAction(_:)))
        self.navigationItem.rightBarButtonItem = addButton;
    }
    
    //MARK: - 添加收货地址
    func addBtnAction(_ sender:UIBarButtonItem) -> Void {
        let editVC: RBEditAddressViewController = RBEditAddressViewController.loadStoryBoard()
        editVC.hidesBottomBarWhenPushed = true
        editVC.isNewAdd = true
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.refreshForHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !self.zx_checked,self.callBack != nil,dataArray.count > 0 {
            if dataArray.count == 1 {
                if let addr = dataArray.firstObject as? RBAddressModel {
                    self.callBack?(addr)
                }
            } else {
                for addr in dataArray {
                    if let addr = addr as? RBAddressModel,addr.addrId == self.zx_defaultAddress?.addrId {
                        self.callBack?(addr)
                        break
                    }
                }
            }
            
        }
    }
    
    //MARK: - Refresh
    private func addRefreshView() ->Void{
        self.tableView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.tableView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForFooter))
    }
    
    @objc func refreshForHeader() -> Void{
        self.currentPageNum = 1
        self.requestForReceiverAddressList()
    }
    
    @objc func refreshForFooter() -> Void{
        self.currentPageNum += 1
        self.requestForReceiverAddressList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Lazy
    lazy var dataArray: NSMutableArray = {
        let dataArray:NSMutableArray = NSMutableArray.init(capacity: 5)
        return dataArray
    }()

}

extension RBAddressViewController: RBAddressRootCellDelegate {
    func didSelectedAddressAction(_ sender: UIButton, _ model: RBAddressModel) {
        switch sender.tag {
        case RBAddressRootCell.ToolButtonTag.statusBtnTag://设置默认
            self.requestForSettingDefaultAddress(model.addrId)
        case RBAddressRootCell.ToolButtonTag.editBtnTag://编辑
            let eidtVC:RBEditAddressViewController = RBEditAddressViewController.loadStoryBoard()
            eidtVC.hidesBottomBarWhenPushed = true
            eidtVC.addressModel = model
            self.navigationController?.pushViewController(eidtVC, animated: true)
            break
        case RBAddressRootCell.ToolButtonTag.deletedBtnTag://删除
            self.selectedRootCelldeletedButtonAction(sender, model)
        default:
            break
        }
    }
    
    //MARK: - 删除
    func selectedRootCelldeletedButtonAction(_ sender: UIButton,_ model: RBAddressModel){
        let alertController:UIAlertController = UIAlertController.init(title: "提示", message: "确定删除地址吗？", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction:UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        
        var addrsModel:RBAddressModel = RBAddressModel.init()
        let moreAction:UIAlertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action) in
            self.dataArray.enumerateObjects({ (obj : Any, idx: Int, stop:UnsafeMutablePointer<ObjCBool>) in
                addrsModel = obj as! RBAddressModel
                if addrsModel.addrId == model.addrId {
                    stop[0] = true
                    DispatchQueue.main.async {
                        self.requestForRemoveReceiverAddress(model.addrId, idx)
                    }
                }
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(moreAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}

// MARK: - HTTP
extension RBAddressViewController {
    //MARK:收货地址
    func requestForReceiverAddressList() -> Void {
        ZXEmptyView.hide(from: self.view)
        var params:Dictionary<String,Any> = Dictionary.init()
        params["pageNum"] = (self.currentPageNum <= 0 ? 0 : self.currentPageNum)
        params["pageSize"] = (ZX_PAGE_SIZE <= 0 ? 0 : ZX_PAGE_SIZE)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.userAddressList), params: params, method: .post) { (success, status, content, string, error) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXEmptyView.hide(from: self.view)
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if success {
                if status == ZXAPI_SUCCESS {
                    if let data = content["data"] as? Dictionary<String,Any> {
                        if let totalPageNum = data["pageTotal"] as? NSInteger {
                            self.totalPageNum = totalPageNum
                        }
                        let tempArray: NSMutableArray = NSMutableArray.init(capacity: 5)
                        if let listData = data["listData"] as? Array<Any>,listData.count > 0 {
                            for dict in listData {
                                let model:RBAddressModel = RBAddressModel.mj_object(withKeyValues: dict)
                                tempArray.add(model)
                            }
                            
                            if self.currentPageNum == 1 {
                                if tempArray.count != 0 {
                                    self.dataArray = tempArray.mutableCopy() as! NSMutableArray
                                }else{
                                    ZXHUD.showFailure(in: self.view, text: "没有更多地址了", delay: ZXHUD_MBDELAY_TIME)
                                }
                            }else{
                                if tempArray.count != 0 {
                                    self.dataArray.addObjects(from: tempArray as! [Any])
                                }
                            }
                            if self.dataArray.count == 0 {
                                ZXEmptyView.show(in: self.view, type: .noData, text: "请添加地址", retry: {
                                    ZXEmptyView.hide(from: self.view)
                                    self.refreshForHeader()
                                })
                            }else if self.currentPageNum >= self.totalPageNum {
                                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                            }
                        }else{
                            var showStr: String = ""
                            if self.currentPageNum == 1 {
                                showStr = "请添加地址"
                            }else{
                                showStr = "没有更多地址了"
                            }
                            ZXEmptyView.show(in: self.view, type: .noData, text: showStr, retry: {
                                ZXEmptyView.hide(from: self.view)
                                self.refreshForHeader()
                            })
                        }
                    }else{
                        ZXEmptyView.show(in: self.view, type: .noData, text: "请添加地址", retry: {
                            ZXEmptyView.hide(from: self.view)
                            self.refreshForHeader()
                        })
                    }
                }else {
                    ZXHUD.showFailure(in: self.view, text: content["msg"] as! String, delay: ZXHUD_MBDELAY_TIME)
                }
                self.tableView.reloadData()
            }else if status != ZXAPI_LOGIN_INVALID {
                if self.currentPageNum == 1 {
                    ZXEmptyView.show(in: self.view, type: .networkError, text: nil, retry: {
                        ZXEmptyView.hide(from: self.view)
                        self.requestForReceiverAddressList()
                    })
                }else{
                    ZXHUD.showFailure(in: self.view, text: (error?.errorMessage)!, delay: 1.5)
                }
            }
        }
    }
    //MARK:删除收货地址
    func requestForRemoveReceiverAddress(_ addressId:Int,_ index:NSInteger) -> Void {
        var params:Dictionary<String,Any> = Dictionary.init()
        if addressId != 0 {
            params["id"] = "\(addressId)"
        }
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.removeUserAddress), params: params, method: .post) { (success, status, content, string, error) in
            ZXHUD.hide(for: self.view, animated: true)
            if success {
                if status == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: content["msg"] as! String, delay: 1.2)
                    DispatchQueue.main.async {
                        self.dataArray.removeObject(at: index)
                        if self.dataArray.count == 0 {
                            ZXEmptyView.show(in: self.view, type: .noData, text: "请添加地址", retry: {
                                ZXEmptyView.hide(from: self.view)
                                self.refreshForHeader()
                            })
                        }
                        self.tableView.reloadData()
                    }
                    if let defaultAddress = self.zx_defaultAddress,defaultAddress.addrId == addressId {
                        self.callBack?(nil)
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: content["msg"] as! String, delay: 1.2)
                }
            }else if status != ZXAPI_LOGIN_INVALID {
                ZXHUD.showFailure(in: (ZXRootController.appWindow()?.rootViewController?.view)!, text: (error?.description)!, delay: ZXHUD_MBDELAY_TIME)
            }
        }
    }
    //MARK:默认收货地址
    func requestForSettingDefaultAddress(_ addrId:Int) -> Void {
        var params:Dictionary<String,Any> = Dictionary.init()
        if addrId != -1 {
            params["id"] = "\(addrId)"
        }
        
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.setDefaultAddress), params: params, method: .post) { (success, status, content, string, error) in
            ZXHUD.hide(for: self.view, animated: true)
            if success {
                if status == ZXAPI_SUCCESS {
                    if status == ZXAPI_SUCCESS {
                        ZXHUD.showSuccess(in: self.view, text: content["msg"] as! String, delay: 1.2)
                        
                        self.refreshForHeader()
                        
                    }else{
                        ZXHUD.showFailure(in: self.view, text: content["msg"] as! String, delay: 1.2)
                    }
                }
            }else if status != ZXAPI_LOGIN_INVALID {
                ZXHUD.showFailure(in: (ZXRootController.appWindow()?.rootViewController?.view)!, text: (error?.description)!, delay: ZXHUD_MBDELAY_TIME)
            }
        }
    }
}

