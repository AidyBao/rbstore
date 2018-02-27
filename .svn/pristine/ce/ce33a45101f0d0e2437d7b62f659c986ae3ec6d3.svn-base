//
//  ZXFreightInfoViewController.swift
//  rbstore
//
//  Created by screson on 2017/7/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXFreightInfoViewController: ZXUIViewController,UIViewControllerTransitioningDelegate,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tblList: UITableView!
    //var list = [ZXFreight]()
    var remark = ""
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
        self.tblList.rowHeight = UITableViewAutomaticDimension
        self.tblList.estimatedRowHeight = 35
        self.tblList.register(UINib(nibName: ZXSingleTextCell.NibName, bundle: nil), forCellReuseIdentifier: ZXSingleTextCell.reuseIdentifier)
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: ZXNotification.UI.reload.zx_noticeName(), object: nil)
    }
    
//    fileprivate func isFreeFreight() -> Bool {
//        var free = false
//        for f in self.list {
//            if let value = Double(f.value),value == 0 {
//                free = true
//                break
//            }
//        }
//        return free
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZXSingleTextCell.reuseIdentifier, for: indexPath) as! ZXSingleTextCell
        cell.lbText.font = UIFont.zx_bodyFont
        cell.lbText.textColor = UIColor.zx_textColorBody
        cell.lbText.textAlignment = .left
        cell.lbText.numberOfLines = 0
        cell.lbText.lineBreakMode = .byWordWrapping
        //cell.lbText.text = "\(indexPath.row + 1)、\(self.list[indexPath.row].description)"
        cell.lbText.text = remark
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if list.count > 0 {
//            if self.isFreeFreight() { //包邮 只显示一条
//                return 1
//            }
//            return self.list.count
//        }
//        return 0
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ZXDimmingPresentationController.init(presentedViewController: presented, presenting: presenting)
    }
}
