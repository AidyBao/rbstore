//
//  RBCheckLogisticsViewController.swift
//  rbstore
//
//  Created by 120v on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class RBCheckLogisticsViewController: ZXUIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "查看物流"
        
        self.tableView.register(UINib.init(nibName:String.init(describing: RBCheckLogisticsCell.self), bundle: nil), forCellReuseIdentifier: RBCheckLogisticsCell.RBCheckLogisticsCellID)
        self.tableView.register(UINib.init(nibName:String.init(describing: RBCheckLogisticsHeader.self), bundle: nil), forCellReuseIdentifier: RBCheckLogisticsHeader.RBCheckLogisticsHeaderID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
