//
//  RBModifySexViewController.swift
//  rbstore
//
//  Created by 120v on 2017/7/20.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBModifySexViewController: ZXUIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedArr: NSMutableArray = []
    var sex: String = ""
    var saveButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "修改性别"
        self.tableView.register(UINib.init(nibName:String.init(describing: RBModifySexCell.self), bundle: nil), forCellReuseIdentifier: RBModifySexCell.RBModifySexCellID)
        
        self.setNavgationView()
        
        self.sex = ZXUser.user.sexStr
        
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
    @objc private func saveButtonClick(_ sender:UIButton) -> Void {
        self.requestForModifySex()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - Http
extension RBModifySexViewController {
    //MARK: - 修改性别
    func requestForModifySex() -> Void {
        var params:Dictionary<String,Any> = Dictionary.init()
        if self.sex != "" {
            if self.sex.isEqual("男") {
                params["sex"] = "1"
            }else{
                params["sex"] = "0"
            }
        }
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD_MBDELAY_TIME)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.updateSex), params: params, method: .post) { (success, status, content, string, error) in
            ZXHUD.hide(for: self.view, animated: true)
            if success {
                if status == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: content["msg"] as! String, delay: ZXHUD_MBDELAY_TIME)
                    
                    self.modifySex()
                    
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
    
    func modifySex() {
        let zxUser = ZXUser.user
        zxUser.sexStr = self.sex
        if self.sex.isEqual("男") {
            zxUser.sex = 1
        }else{
            zxUser.sex = 0
        }
    }
}
