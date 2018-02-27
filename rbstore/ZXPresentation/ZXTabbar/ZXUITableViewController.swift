//
//  ZXUITableViewController.swift
//  YDY_GJ_3_5
//
//  Created by 120v on 2017/5/5.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
class ZXUITableViewController: UITableViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.zx_clearNavbarBackButtonTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.zx_clearNavbarBackButtonTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open var prefersStatusBarHidden: Bool {
        return false
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
