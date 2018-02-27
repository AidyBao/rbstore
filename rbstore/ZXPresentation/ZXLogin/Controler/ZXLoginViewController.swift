//
//  LoginViewController.swift
//  rbstore
//
//  Created by screson on 2017/7/19.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXLoginViewController: ZXUIViewController {
//    static func show(_ success:(() -> Void)?,_ failure:((_ code:Int,_ msg:String) -> Void)?) {
//        let sb = UIStoryboard.init(name: "ZXLoginStoryBoard", bundle: nil)
//        if let nav = sb.instantiateInitialViewController() {
//            ZXRootController.selectedNav().present(nav, animated: true, completion: nil)
//        }
//    }
    
    static func show(_ login:(ZXClosure_Empty)? = nil) {
        
        let sb = UIStoryboard.init(name: "ZXLoginStoryBoard", bundle: nil)
        if let nav = sb.instantiateInitialViewController() as? UINavigationController {
            var vc:UIViewController = ZXRootController.selectedNav()
            while (vc.presentedViewController != nil) {
                vc = vc.presentedViewController!
            }
            ZXGlobalData.loginProcessed = false
            vc.present(nav, animated: true, completion: nil)
            if let root = nav.viewControllers.first as? ZXLoginViewController {
                root.loginCallBack = login
            }
        }
    }
    
    @IBOutlet weak var lbTel: UILabel!
    @IBOutlet weak var lbPwd: UILabel!
    @IBOutlet weak var txtTel: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var btnShowPwd: UIButton!
    
    @IBOutlet weak var btnCommit: UIButton!
    @IBOutlet weak var btnRetriverPwd: UIButton!
    @IBOutlet weak var btnTelCodeLogin: UIButton!
    
    var loginCallBack:ZXClosure_Empty?
    
    var waitRegistTel:String?
    
    @IBOutlet weak var sLine: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.zx_addNavBarButtonItems(textNames: ["注册"], font: nil, color: nil, at: .right)
        self.zx_addNavBarButtonItems(textNames: ["关闭"], font: nil, color: nil, at: .left)
        self.sLine.backgroundColor = UIColor.zx_borderColor
        
        self.lbTel.font = UIFont.zx_bodyFont
        self.lbTel.textColor = UIColor.zx_textColorTitle
        self.lbPwd.font = UIFont.zx_bodyFont
        self.lbPwd.textColor = UIColor.zx_textColorTitle
        
        self.txtTel.textColor = UIColor.zx_textColorTitle
        self.txtTel.font = UIFont.zx_bodyFont
        self.txtPwd.textColor = UIColor.zx_textColorTitle
        self.txtPwd.font = UIFont.zx_bodyFont
        
        self.btnRetriverPwd.setTitleColor(UIColor.zx_tintColor, for: .normal)
        self.btnRetriverPwd.titleLabel?.font = UIFont.zx_bodyFont
        
        self.btnTelCodeLogin.setTitleColor(UIColor.zx_tintColor, for: .normal)
        self.btnTelCodeLogin.titleLabel?.font = UIFont.zx_bodyFont
        
        self.txtTel.delegate = self
        self.txtPwd.delegate = self
        
        self.setCommitButton(false)
        
        self.btnShowPwd.setImage(#imageLiteral(resourceName: "zx-closeEye"), for: .normal)
        self.btnShowPwd.setImage(#imageLiteral(resourceName: "zx-eye"), for: .highlighted)
        self.btnShowPwd.setImage(#imageLiteral(resourceName: "zx-eye"), for: .selected)
        
//        self.txtTel.text = "18081000000"
//        self.txtPwd.text = "admin"
//        self.btnCommit.isEnabled = true
        
        if let tel = ZXUserModel.lasetUserTel() {
            self.txtTel.text = tel
            self.txtPwd.becomeFirstResponder()
        } else {
            self.txtTel.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(zxTextFieldValueChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    fileprivate func setCommitButton(_ enable:Bool) {
        if enable {
            self.btnCommit.isEnabled = true
        } else {
            self.btnCommit.isEnabled = false
        }
    }
    
    override func zx_leftBarButtonAction(index: Int) {
        self.dismiss(animated: true) {
            //避免动画过程中,其他接口检测
            ZXGlobalData.loginProcessed = true
        }
    }
    
    override func zx_rightBarButtonAction(index: Int) {
        self.waitRegistTel = nil
        self.performSegue(withIdentifier: "ZXRegist", sender: nil)
    }
    
    @IBAction func showPwdAction(_ sender: Any) {
        self.btnShowPwd.isSelected = !self.btnShowPwd.isSelected
        self.txtPwd.isSecureTextEntry = !self.btnShowPwd.isSelected
    }

    @IBAction func retrivePwdAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ZXRegist", sender: sender)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.view.endEditing(true)
        
        let tel = self.txtTel.text!
        let pwd = self.txtPwd.text!
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: nil)
        
        ZXUserViewModel.login(tel: tel, password: pwd, type: .password, success: { 
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.showSuccess(in: self.view, text: "登录成功", delay: ZXConst.zxcallDelay)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + ZXConst.zxcallDelay, execute: {
                self.dismiss(animated: true, completion: {
                    self.loginCallBack?()
                })
            })
        }, unregist: {
            ZXHUD.hide(for: self.view, animated: true)
            ZXAlertUtils.showAlert(wihtTitle: nil, message: "手机号\(tel)未注册", buttonTexts: ["重新输入","去注册"], action: { (index) in
                if index == 0 {
                    self.txtTel.becomeFirstResponder()
                } else {
                    self.waitRegistTel = tel
                    self.performSegue(withIdentifier: "ZXRegist", sender: sender)
                }
            })
        }) { (code, errorMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXNetwork.errorCodeParse(code, httpError: {
                ZXHUD.showFailure(in: self.view, text: "连接失败请检查网络或重试", delay: ZXConst.zxdelayTime)
            }, serverError: {
                ZXHUD.showFailure(in: self.view, text: errorMsg, delay: ZXConst.zxdelayTime)
            })
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        self.view.endEditing(true)
        if let vc = segue.destination as? ZXRegistViewController {
            if let btn = sender as? UIButton, btn == self.btnRetriverPwd {
                vc.type = .retrivePassword
            } else {
                vc.waitRegistTel = self.waitRegistTel
                vc.loginCallBack = self.loginCallBack
            }
        } else if let vc = segue.destination as? ZXTelCodeLoginViewController {
            vc.loginCallBack = self.loginCallBack
        }
    }
 
    func zxTextFieldValueChange(_ notice: Notification) {
        if (notice.object as? UITextField) != nil {
            let bTel = !(self.txtTel.text ?? "").isEmpty
            let bCode = !(self.txtPwd.text ?? "").isEmpty
            if bTel,bCode,self.txtTel.text?.characters.count == 11 {
                self.setCommitButton(true)
            } else {
                self.setCommitButton(false)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
}

extension ZXLoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtTel {
            let cs = CharacterSet.init(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }
            if range.location > 10 {
                return false
            }
            let str = textField.text ?? ""
            let str2 = (str as NSString).replacingCharacters(in: range, with: string)
            if str2.characters.count == 1 && str2 != "1" {
                return false
            }
            if range.location == 10 && str2.characters.count == 11 {
                self.txtTel.text = str2
                self.txtPwd.becomeFirstResponder()
                let bTel = !(self.txtTel.text ?? "").isEmpty
                let bCode = !(self.txtPwd.text ?? "").isEmpty
                if bTel,bCode,self.txtTel.text?.characters.count == 11 {
                    self.setCommitButton(true)
                } else {
                    self.setCommitButton(false)
                }
                return false
            }
        } else {
            let cs = CharacterSet.init(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }
            
            if range.location > 15 {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}