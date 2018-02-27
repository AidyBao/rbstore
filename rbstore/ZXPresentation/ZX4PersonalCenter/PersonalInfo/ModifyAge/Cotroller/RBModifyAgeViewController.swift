//
//  RBModifyAgeViewController.swift
//  rbstore
//
//  Created by 120v on 2017/7/20.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBModifyAgeViewController: ZXUIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedArr: NSMutableArray = []
    var saveButton:UIButton?
    var defaultAge: Int = -1
    var selectedModel: RBAgeGroupModel = RBAgeGroupModel.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "修改年龄段"
        
        self.requestForAgeGroup()

        self.setNavgationView()
        
//        self.defaultAge = ZXUser.user.ageGroups
        
        self.tableView.register(UINib.init(nibName: String.init(describing: RBAgeRootCell.self), bundle: nil), forCellReuseIdentifier: RBAgeRootCell.RBAgeRootCellID)

    }
    
    func setNavgationView() -> Void {
        self.saveButton = UIButton.init(type: UIButtonType.custom)
        self.saveButton?.frame.size = CGSize.init(width: 40, height: 40)
        self.saveButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.saveButton?.setTitle("保存", for: UIControlState.normal)
        self.saveButton?.addTarget(self, action: #selector(saveButtonClick(_:)), for: UIControlEvents.touchUpInside)
        self.saveButton?.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControlState.normal)
        self.saveButton?.isEnabled = false
        let rightItem:UIBarButtonItem = UIBarButtonItem.init(customView: self.saveButton!)
        let rightSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        rightSpace.width = -7
        self.navigationItem.rightBarButtonItems = [rightSpace,rightItem]
    }
    
    //MARK: - saveButtonClick
    func saveButtonClick(_ sender:UIButton) -> Void {
        self.httpRequestForModifyAge()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var dataArray: NSMutableArray = {
        let array: NSMutableArray = NSMutableArray.init()
        return array
    }()
}

extension RBModifyAgeViewController {
    //MARK: - 请求年龄段
    func requestForAgeGroup() -> Void {
        var params:Dictionary<String,Any> = Dictionary.init()
        params["type"] = "1"
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD_MBDELAY_TIME)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.getAgeGroup), params: params, method: .post) { (success, status, content, string, error) in
            ZXHUD.hide(for: self.view, animated: true)
            if success {
                if status == ZXAPI_SUCCESS {
                    if let listData = content["data"] as? Array<Any> {
                       self.dataArray = RBAgeGroupModel.mj_objectArray(withKeyValuesArray: listData)
                        
                        for model in self.dataArray {
                            if (model as! RBAgeGroupModel).key == ZXUser.user.ageGroups {
                                (model as! RBAgeGroupModel).isSelected = true
                            }
                        }
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: "暂无年龄段", delay: ZXHUD_MBDELAY_TIME)
                }
                self.tableView.reloadData()
            }else if status != ZXAPI_LOGIN_INVALID {
                if status == NSURLErrorNotConnectedToInternet {
                    ZXEmptyView.show(in: self.view, type: .networkError, text: "网络连接失败", retry: {
                        self.requestForAgeGroup()
                    })
                } else {
                    ZXEmptyView.show(in: self.view, type: .networkError, text: error?.description, retry: {
                        self.requestForAgeGroup()
                    })
                }
            }
        }
    }

    
    
    //MARK: - 修改性别
    func httpRequestForModifyAge() -> Void {
        var params:Dictionary<String,Any> = Dictionary.init()
        if self.selectedModel.key != -1 {
            params["ageGroups"] = "\(self.selectedModel.key)"
        }
        
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD_MBDELAY_TIME)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.updateAgeGroups), params: params, method: .post) { (success, status, content, string, error) in
            ZXHUD.hide(for: self.view, animated: true)
            if success {
                if status == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: content["msg"] as! String, delay: ZXHUD_MBDELAY_TIME)
                    
                    self.modifyAge()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }else{
                    ZXHUD.showFailure(in: self.view, text: content["msg"] as! String, delay: ZXHUD_MBDELAY_TIME)
                }
            }else if status != ZXAPI_LOGIN_INVALID {
                ZXHUD.showFailure(in: self.view, text: (error?.description)!, delay: ZXHUD_MBDELAY_TIME)
            }
        }
    }
    
    func modifyAge() {
        let zxUser = ZXUser.user
        zxUser.ageGroupsStr = self.selectedModel.value
        zxUser.ageGroups = self.selectedModel.key
    }
}
