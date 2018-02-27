//
//  RBSearchRootViewController+TextFeild.swift
//  rbstore
//
//  Created by 120v on 2017/7/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

// MARK: - UISearchBarDelegate
extension RBSearchRootViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchField.resignFirstResponder()
        //
        self.saveHistorySearchRecord(textField.text!)
        //
        let listVC: RBCategoryListViewController = RBCategoryListViewController.init()
        listVC.hidesBottomBarWhenPushed = true
        listVC.searchName = textField.text!
        self.navigationController?.pushViewController(listVC, animated: true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.textInputMode?.primaryLanguage!.isEqual("emoji")) == true || ((textField.textInputMode?.primaryLanguage) == nil) {
            return false
        }
        return true
    }
    
    @objc fileprivate func textFieldDidChange(_ textField:UITextField) {
        if (textField.textInputMode?.primaryLanguage!.isEqual("emoji")) == false , ((textField.textInputMode?.primaryLanguage) != nil) , textField.text?.isEmpty == false{//关键字匹配
            self.maskView.isHidden = false
            self.requestForKeyWordMatch(textField.text!)
        }else{
            self.maskView.isHidden = true
        }
    }
}