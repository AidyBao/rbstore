//
//  RBMyCollectViewController.swift
//  rbstore
//
//  Created by 120v on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBMyCollectViewController: ZXUIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var currentPageIndex: NSInteger = 0
    var totalPageNum: NSInteger     = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的收藏"
        
        self.tableView.register(UINib.init(nibName:String.init(describing: RBCollectCell.self), bundle: nil), forCellReuseIdentifier: RBCollectCell.RBCollectCellID)
        
        self.setRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.refreshForHeader()
    }
    
    func setRefresh() ->Void{
        self.tableView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.tableView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForFooter))
    }
    
    func refreshForHeader() -> Void{
        self.currentPageIndex = 1
        self.httpRequestForMycollect()
    }
    
    func refreshForFooter() -> Void{
        self.currentPageIndex += 1
        self.httpRequestForMycollect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    lazy var dataArray: NSMutableArray = {
        let array: NSMutableArray = NSMutableArray.init(capacity: 3)
        return array
    }()

}

//MARK: - Http
extension RBMyCollectViewController {
    //MARK: - 收藏列表
    func httpRequestForMycollect() ->Void{
        var params:Dictionary<String,Any> = Dictionary.init()
        params["pageNum"] = self.currentPageIndex
        params["pageSize"] = ZX_PAGE_SIZE
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD_MBDELAY_TIME)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.myCollectList), params: params, method: .post) { (success, status, content, string, error) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tableView, animated: true)
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            ZXEmptyView.hide(from: self.view)
            if success {
                if status == ZXAPI_SUCCESS{
                    if let dict:Dictionary<String,Any> = content["data"] as? Dictionary {
                        self.totalPageNum = dict["pageTotal"] as! NSInteger
                        let tempArray:NSMutableArray = NSMutableArray.init(capacity: 5)
                        if let list = dict["listData"] as? Array<Any> {
                            for dict in list{
                                let model:RBMyCollectModel = RBMyCollectModel.mj_object(withKeyValues: dict)
                                tempArray.add(model)
                            }
                            
                            if self.currentPageIndex == 1 {
                                if tempArray.count != 0 {
                                    self.dataArray = tempArray.mutableCopy() as! NSMutableArray
                                }else{
                                    ZXEmptyView.show(in: self.view, type: .noData, text: "暂无收藏", retry: {
                                        ZXEmptyView.hide(from: self.view)
                                        self.refreshForHeader()
                                    })
                                }
                            }else{
                                if tempArray.count != 0 {
                                    self.dataArray.addObjects(from: tempArray as! [Any])
                                }
                            }
                            
                            if self.dataArray.count == 0 {
                                ZXEmptyView.show(in: self.view, type: .noData, text: "暂无收藏", retry: {
                                    ZXEmptyView.hide(from: self.view)
                                    self.refreshForHeader()
                                })
                            }else if self.currentPageIndex >= self.totalPageNum {
                                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                            }
                        }else{
                            ZXEmptyView.show(in: self.view, type: .noData, text: "暂无收藏", retry: {
                                ZXEmptyView.hide(from: self.view)
                                self.refreshForHeader()
                            })
                        }
                    }else{
                        ZXEmptyView.show(in: self.view, type: .noData, text: "暂无收藏", retry: {
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
                        self.httpRequestForMycollect()
                    })
                }, serverError: {
                    ZXEmptyView.show(in: self.view, type: .networkError, text: error?.description, retry: {
                        ZXEmptyView.hide(from: self.view)
                        self.httpRequestForMycollect()
                    })
                })
            }
        }
    }
    
    //MARK: - 删除收藏
    func requestForDeleteCollect(_ specProductId: Int , _ indexPath: IndexPath) ->Void{
        var params:Dictionary<String,Any> = Dictionary.init()
        params["specProductId"] = specProductId
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.deleteCollect), params: params, method: .post) { (success, status, content, string, error) in
            ZXHUD.hide(for: self.view, animated: true)
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            ZXEmptyView.hide(from: self.view)
            if success {
                if status == ZXAPI_SUCCESS{
                    ZXHUD.showSuccess(in: self.view, text: "删除成功", delay: ZXHUD_MBDELAY_TIME)
                    
                    self.dataArray.removeObject(at: indexPath.section)
                    self.tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: UITableViewRowAnimation.automatic)
                    self.tableView.endUpdates()
                    
                    self.refreshForHeader()
                }else{
                   ZXHUD.showFailure(in: self.view, text: "删除失败", delay: ZXHUD_MBDELAY_TIME)
                }
            }else if status != ZXAPI_LOGIN_INVALID{
                    ZXHUD.showFailure(in: self.view, text: (error?.errorMessage)!, delay: 1.5)
            }
        }
    }

}
