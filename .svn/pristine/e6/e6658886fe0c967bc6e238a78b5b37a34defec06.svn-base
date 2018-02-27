//
//  RBEditAddressViewController.swift
//  rbstore
//
//  Created by 120v on 2017/7/21.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBEditAddressViewController: ZXUITableViewController {
    
    var isNewAdd:Bool = false
    
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var telLB: UILabel!
    @IBOutlet weak var telTextField: UITextField!
    
    @IBOutlet weak var areaLB: UILabel!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var areaDetailLB: UILabel!
    
    @IBOutlet weak var addrDetailLB: UILabel!
    @IBOutlet weak var addrDetailTextView: ZXTextView!
    
    @IBOutlet weak var defaultButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    var addressView: ZXAddressView?
    var addressModel: RBAddressModel?
    
    var cityAddress: String     = ""
    var cityAddressCode: String = ""
    var isDefault:  Int         = 0
    
    class func loadStoryBoard() -> RBEditAddressViewController{
        let editVC:RBEditAddressViewController = UIStoryboard.init(name: "MyAddress", bundle: nil).instantiateViewController(withIdentifier:String.init(describing: RBEditAddressViewController.classForCoder())) as! RBEditAddressViewController
        return editVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isNewAdd {
            self.navigationItem.title = "添加收货地址"
        }else {
            self.navigationItem.title = "编辑收货地址"
        }
        
        self.setUIStyle()
        
        self.zx_addNavBarButtonItems(textNames: ["取消"], font: nil, color: nil, at: .right)
        
        self.setDefultData()
        
        self.setSaveButtonStyle()
        
        //手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(touch))
        self.tableView.addGestureRecognizer(tap)
    }
    
    private func setUIStyle() {
        self.nameLB.font = UIFont.zx_bodyFont
        self.nameLB.textColor = UIColor.zx_textColorBody
        self.nameTextField.font = UIFont.zx_bodyFont
        self.nameTextField.textColor = UIColor.zx_textColorBody
        
        self.telLB.font = UIFont.zx_bodyFont
        self.telLB.textColor = UIColor.zx_textColorBody
        self.telTextField.font = UIFont.zx_bodyFont
        self.telTextField.textColor = UIColor.zx_textColorBody
        
        self.areaLB.font = UIFont.zx_bodyFont
        self.areaLB.textColor = UIColor.zx_textColorBody
        
        self.areaDetailLB.font = UIFont.zx_bodyFont
        self.areaDetailLB.textColor = UIColor.zx_textColorBody
        if self.isNewAdd {
            self.addrDetailTextView.placeText = "请填写详细地址"
        }
        self.addrDetailTextView.delegate = self
        self.addrDetailTextView.limitTextNum = 64
        
        self.addrDetailLB.font = UIFont.zx_bodyFont
        self.addrDetailLB.textColor = UIColor.zx_textColorBody
        
        self.defaultButton.titleLabel?.font = UIFont.zx_bodyFont
        self.defaultButton.setTitleColor(UIColor.zx_textColorBody, for: UIControlState.normal)
        
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        
//        self.saveButton.layer.insertSublayer(self.bgGradientLayer, at: 0)
//        self.saveButton.layer.cornerRadius = 21.0
//        self.saveButton.layer.shadowColor = UIColor(red: 108 / 255.0, green: 112 / 255.0, blue: 225 / 255.0, alpha: 1.0).cgColor
//        self.saveButton.layer.shadowRadius = 3
//        self.saveButton.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.saveButton.layer.shadowOpacity = 0.50
    }
    
    //MARK: - 赋值
    func setDefultData() -> Void {
        if self.addressModel != nil , self.isNewAdd == false {
            
            self.nameTextField.text = self.addressModel?.consignee
            
            self.telTextField.text = self.addressModel?.tel
            
            let aArray: Array = (self.addressModel?.cityAddress.components(separatedBy: "-"))!
            let newStr: String = aArray.joined(separator: "")
            self.areaDetailLB.text = newStr
            
            self.addrDetailTextView.textView.text = self.addressModel?.address
            
            self.cityAddress = (self.addressModel?.cityAddress)!
            
            self.cityAddressCode = (self.addressModel?.code)!
            
            self.isDefault = (self.addressModel?.isDefault)!
            if self.isDefault == 1 {
                self.defaultButton.isSelected = true
            }else{
                self.defaultButton.isSelected = false
            }
        }else{
            self.nameTextField.text = ZXUser.user.name
            self.telTextField.text = ZXUser.user.tel
            self.defaultButton.isSelected = false
        }
        self.setSaveButtonStyle()
    }
    
    func setSaveButtonStyle() {
        if self.isNewAdd {
            if self.nameTextField.text?.characters.count == 0 || self.telTextField.text?.characters.count == 0 || self.areaDetailLB.text?.characters.count == 0 || self.addrDetailTextView.textView.text.characters.count == 0 {
                self.saveButton?.isEnabled = false
            }else{
                self.saveButton?.isEnabled = true
            }
        }else{
            if (self.nameTextField.text?.characters.count == 0 || self.telTextField.text?.characters.count == 0 || self.areaDetailLB.text?.characters.count == 0 || self.addrDetailTextView.textView.text.characters.count == 0) {
                self.saveButton?.isEnabled = false
             }else{
                let aArray:Array = self.addressModel!.cityAddress.components(separatedBy: "-")
                let cityStr:String = aArray.joined(separator: "")
                
                if (self.nameTextField.text?.isEqual(self.addressModel?.consignee))!,(self.telTextField.text?.isEqual(self.addressModel?.tel))! ,(self.areaDetailLB.text?.isEqual(cityStr))!,(self.addrDetailTextView.textView.text?.isEqual(self.addressModel?.address))!,self.defaultButton.isSelected.hashValue == self.addressModel?.isDefault {
                    self.saveButton?.isEnabled = false
                }else{
                    self.saveButton?.isEnabled = true
                }
            }
        }
    }

    //MARK: - 取消
    override func zx_rightBarButtonAction(index: Int) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func touch() -> Void {
        self.view.endEditing(true)
        self.nameTextField.resignFirstResponder
        self.telTextField.resignFirstResponder
        self.addressView?.endEditing(true)
    }
    
    //MARK: - 设置默认
    @IBAction func setDefaultButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.telTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        self.addressView?.resignFirstResponder()
        
        if sender.isSelected {
            self.isDefault = 1
        }else{
            self.isDefault = 0
        }
        
        self.setSaveButtonStyle()
    }
    
    //MARK: - 保存
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.telTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        self.addressView?.resignFirstResponder()
        
        self.requestForUpdateReceiverAddress()
    }
    
    //MARK: - 所在地区
    @IBAction func selectAreaAction(_ sender: UIButton) {
        self.telTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        self.addrDetailTextView.textView.resignFirstResponder()
        
        let addressVC = ZXAddressViewController.init()
        addressVC.hidesBottomBarWhenPushed = true
        addressVC.navigationController?.setNavigationBarHidden(true, animated: true)
        addressVC.delegate = self
        self.present(addressVC, animated: true, completion: nil)
        
        if self.cityAddressCode.isEmpty == false {
            addressVC.setDefaultAddress(self.cityAddressCode)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 渐变色
    fileprivate var bgGradientLayer:CAGradientLayer = {
        let gradLayer:CAGradientLayer = CAGradientLayer.init(layer: CALayer())
        gradLayer.frame = CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 2*14, height: 42)
        gradLayer.startPoint = CGPoint.init(x: 0, y: 1)
        gradLayer.endPoint = CGPoint.init(x: 1, y: 1)
        gradLayer.colors = [UIColor(red: 108 / 255.0, green: 112 / 255.0, blue: 225 / 255.0, alpha: 1.0).cgColor,UIColor(red: 77 / 255.0, green: 83 / 255.0, blue: 216 / 255.0, alpha: 1.0).cgColor]
        gradLayer.cornerRadius = 21.0
        return gradLayer
    }()
}

//MARK: - ZXAddressViewControllerDelegate 
extension RBEditAddressViewController: ZXAddressViewControllerDelegate {
    func didSelectedAddressView(_ proviceStr:String,_ proCode:Int,_ cityStr:String,_ cityCode:Int,_ disStr:String,_ disCode:Int) {
        if proviceStr != "", cityStr != "",cityStr != "" {
            let areaStr: String = NSString.init(format: "%@%@%@", proviceStr,cityStr,disStr) as String
//            self.cityAddress = NSString.init(format: "%@-%@-%@", proviceStr,cityStr,disStr) as String
            self.cityAddress = areaStr
            self.areaDetailLB.text = areaStr
        }
        
        if proCode != -1,cityCode != -1,disCode != -1 {
            self.cityAddressCode = NSString.init(format: "%d-%d-%d", proCode,cityCode,disCode) as String
        }
        self.setSaveButtonStyle()
    }
}

//MARK: - ZXTextViewDelegate
extension RBEditAddressViewController:ZXTextViewDelegate {
    func getTextNum(textNum: Int) {
        if textNum == 0 {
            self.addrDetailTextView.placeLabel.isHidden = false
            self.addrDetailTextView.placeText = "请填写详细地址"
        }else{
            self.addrDetailTextView.placeLabel.isHidden = true
        }
        self.setSaveButtonStyle()
    }
}


extension RBEditAddressViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.telTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        self.addrDetailTextView.textView.resignFirstResponder()
    }
    
    
    //添加手势后此方法无效
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 , indexPath.row == 3 {
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowH: CGFloat = 0
        switch indexPath.section {
        case 0:
            rowH = 50.5
        default:
            rowH = 52.0
        }
        return rowH
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerH: CGFloat = 0
        switch section {
        case 0:
            headerH = 15.0
        default:
            headerH = 15.0
        }
        return headerH
    }
}

extension RBEditAddressViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.addressView?.resignFirstResponder()
        if textField == self.nameTextField {
            self.telTextField.resignFirstResponder()
            self.nameTextField.becomeFirstResponder()
        }else if textField == self.telTextField {
            self.nameTextField.resignFirstResponder()
            self.telTextField.becomeFirstResponder()
        }
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField.resignFirstResponder
        self.telTextField.resignFirstResponder
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let existedLength:Int = (textField.text?.characters.count)!
        let _:Int = range.location
        let replaceLength:Int = string.characters.count
        if textField == self.nameTextField {
            if existedLength+replaceLength > 16 {
                ZXHUD.showFailure(in: self.view, text: "姓名不能超过16个字", delay: ZXHUD_MBDELAY_TIME)
                return false
            }
            
            if string != "",!(string.zx_predicateNickname()) || (textField.textInputMode?.primaryLanguage!.isEqual("emoji")) == true || ((textField.textInputMode?.primaryLanguage) == nil){
                return false
            }
        }
        if textField == telTextField {
            if range.location > 10 {
                ZXHUD.showFailure(in: self.view, text: "请输入正确的手机号", delay: ZXHUD_MBDELAY_TIME)
                return false
            }
        }
        return true
    }
    
    @objc fileprivate func textFieldDidChange(_ textField: UITextField) {
        self.setSaveButtonStyle()
    }
}

//MARK: - HTTP
extension RBEditAddressViewController {
    //MARK: - 新增&编辑收货地址
    func requestForUpdateReceiverAddress() -> Void {
        var params:Dictionary<String,Any> = Dictionary.init()
        params["consignee"] = self.nameTextField.text
        if (self.telTextField.text?.zx_mobileValid())! {
            params["tel"] = self.telTextField.text
        }else{
            ZXHUD.showFailure(in: self.view, text: "请输入正确的手机号", delay: ZXHUD_MBDELAY_TIME)
            return
        }
        params["cityAddress"] = self.cityAddress
        params["address"] = self.addrDetailTextView.textView.text
        
        if self.cityAddressCode.isEmpty == false {
            params["code"] = self.cityAddressCode
        }
        
        if self.isDefault != 0 {
            params["isDefault"] = self.isDefault
        }
        
        if self.isNewAdd == false , self.addressModel?.addrId != -1 {
            params["id"] = self.addressModel?.addrId
        }
        
        var urlStr: String = ""
        if self.isNewAdd {
            urlStr = ZXAPIConst.Personal.addAddress
        }else{
            urlStr = ZXAPIConst.Personal.updateAddress
        }
        
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD_MBDELAY_TIME)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: urlStr), params: params, method: .post) { (success, status, content, string, error) in
            ZXHUD.hide(for: self.view, animated: true)
            if success {
                if status == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: content["msg"] as! String, delay: ZXHUD_MBDELAY_TIME)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
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
}

