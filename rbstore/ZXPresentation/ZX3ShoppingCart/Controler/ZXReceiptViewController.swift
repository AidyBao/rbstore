//
//  ZXReceiptViewController.swift
//  rbstore
//
//  Created by screson on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

struct ZXReceiptInfo {
    static var selected = false
    static var title    = ""
    static func clear () {
        self.selected = false
        self.title = ""
    }
}

class ZXReceiptViewController: ZXUIViewController {

    fileprivate var companyType = false
    @IBOutlet weak var txtInvoiceTitle: UITextField!
    
    @IBOutlet weak var numberInputBackView: UIView!
    
    @IBOutlet weak var numBackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var txtNumber: UITextField!
    
    @IBOutlet weak var btnPersonalTitle: UIButton!
    
    @IBOutlet weak var btnCompanyTitle: UIButton!
    
    @IBOutlet weak var lbInvocieInfomation: ZXUILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "填写发票"
        // Do any additional setup after loading the view.
        self.txtInvoiceTitle.font = UIFont.zx_bodyFont
        self.txtInvoiceTitle.textColor = UIColor.zx_textColorBody
        self.txtInvoiceTitle.delegate = self
        self.txtInvoiceTitle.clearButtonMode = .whileEditing
        
        self.txtNumber.font = UIFont.zx_bodyFont
        self.txtNumber.textColor = UIColor.zx_textColorBody
        self.txtNumber.delegate = self
        self.txtNumber.clearButtonMode = .whileEditing
        
        self.btnPersonalTitle.titleLabel?.font = UIFont.zx_bodyFont
        self.btnPersonalTitle.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        self.btnPersonalTitle.setImage(#imageLiteral(resourceName: "zx-uncheck"), for: .normal)
        self.btnPersonalTitle.setImage(#imageLiteral(resourceName: "zx-check"), for: .highlighted)
        self.btnPersonalTitle.setImage(#imageLiteral(resourceName: "zx-check"), for: .selected)
        
        self.btnCompanyTitle.titleLabel?.font = UIFont.zx_bodyFont
        self.btnCompanyTitle.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        self.btnCompanyTitle.setImage(#imageLiteral(resourceName: "zx-uncheck"), for: .normal)
        self.btnCompanyTitle.setImage(#imageLiteral(resourceName: "zx-check"), for: .highlighted)
        self.btnCompanyTitle.setImage(#imageLiteral(resourceName: "zx-check"), for: .selected)
        
        
        self.numberInputBackView.clipsToBounds = true
        self.btnPersonalTitle.isSelected = true
        self.numBackViewHeight.constant = 0
        self.numberInputBackView.isHidden = true
        self.txtInvoiceTitle.text = "个人"
        
        self.zx_addNavBarButtonItems(textNames: ["取消"], font: nil, color: nil, at: .left)
        self.zx_addNavBarButtonItems(textNames: ["确定"], font: nil, color: nil, at: .right)
        
        if ZXInvoiceInputCache.type == 1 {
            self.changeCompanyType(false)
            self.txtInvoiceTitle.text = "个人"
            self.txtInvoiceTitle.isEnabled = false
            self.txtNumber.text = nil
        } else {
            self.changeCompanyType(true)
            self.txtInvoiceTitle.text = ZXInvoiceInputCache.companyTitle
            self.txtInvoiceTitle.isEnabled = true
            self.txtNumber.text = ZXInvoiceInputCache.taxNum
        }
        self.lbInvocieInfomation.text = ZXInvoiceInputCache.infomation
    }
    
    override func zx_leftBarButtonAction(index: Int) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func zx_rightBarButtonAction(index: Int) {
        if let text = self.txtInvoiceTitle.text,text.characters.count > 0 {
            ZXInvoiceInputCache.needOpenInvoice = true
            if self.btnPersonalTitle.isSelected {//个人
                ZXInvoiceInputCache.type = 1
                ZXInvoiceInputCache.personalTitle = "个人"
                //ZXInvoiceInputCache.taxNum = nil
            } else {//公司
                ZXInvoiceInputCache.type = 2
                ZXInvoiceInputCache.companyTitle = self.txtInvoiceTitle.text
                if let text = self.txtNumber.text,text.characters.count > 0 {
                    ZXInvoiceInputCache.taxNum = text
                } else {
                    ZXInvoiceInputCache.taxNum = nil
                }
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            ZXHUD.showFailure(in: self.view, text: "请填写发票抬头", delay: ZXConst.zxdelayTime)
        }
    }

    @IBAction func personalTitleAction(_ sender: Any) {
        self.changeCompanyType(false)
    }
    
    @IBAction func companyTitleAction(_ sender: Any) {
        self.changeCompanyType(true)
    }
    
    fileprivate func changeCompanyType(_ t:Bool) {
        self.txtInvoiceTitle.resignFirstResponder()
        if t == companyType {
            return
        }
        companyType = t
        if t {//公司
            self.txtInvoiceTitle.isEnabled = true
            self.txtInvoiceTitle.text = ZXInvoiceInputCache.companyTitle
            self.txtNumber.text = ZXInvoiceInputCache.taxNum
            self.numberInputBackView.isHidden = false
            self.btnCompanyTitle.isSelected = true
            self.btnPersonalTitle.isSelected = false
            self.numBackViewHeight.constant = 46
            UIView.animate(withDuration: 0.25, animations: { 
                self.view.layoutIfNeeded()
            })
        } else {//个人
            self.txtInvoiceTitle.isEnabled = false
            self.txtInvoiceTitle.text = "个人"
            self.txtNumber.resignFirstResponder()
            self.btnCompanyTitle.isSelected = false
            self.btnPersonalTitle.isSelected = true
            self.numBackViewHeight.constant = 0
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            }) { (finished) in
                self.numberInputBackView.isHidden = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ZXReceiptViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtInvoiceTitle.resignFirstResponder()
        self.txtNumber.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.textInputMode?.primaryLanguage == nil ||
            textField.textInputMode?.primaryLanguage! == "emoji" {
            return false
        }
        if string.characters.count > 0,string.zx_inValidText() {
            return false
        }
        if textField == self.txtInvoiceTitle {
            if range.location > 63 {
                return false
            }
        } else if textField == self.txtNumber {
            let cs = CharacterSet.init(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }
            if range.location > 19 {
                return false
            }
        }

        return true
    }
}
