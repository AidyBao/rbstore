//
//  ZXMyOrderRootViewController.swift
//  rbstore
//
//  Created by 120v on 2017/8/14.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

enum RBOrderStatus {
    case all
    case waitPay
    case waitSend
    case shipped
}

class ZXMyOrderRootViewController: ZXUIViewController {
    
    var orderStatus: RBOrderStatus = RBOrderStatus.all
    var selectIndex: NSInteger = 0
    var contentViews: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的订单"
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        self.addSegmentView()
    }
    
    func addSegmentView() {
        
        //分段控制器
        for _ in 0..<4 {
            let VC = ZXMyOrderViewController.init()
            contentViews.append(VC)
            addChildViewController(VC)
        }
        let sliderView = MQSliderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ZXBOUNDS_HEIGHT), titles: ["全部", "待付款", "待发货", "待收货"], contentViews: contentViews)
        sliderView.delegate = self
        sliderView.sliderWidth = 55
        sliderView.sliderColor = UIColor.zx_tintColor
        sliderView.btnFontColorNormal = UIColor.zx_textColorBody
        sliderView.btnFontColorSelected = UIColor.zx_tintColor
        sliderView.isShowVerticalLine = false
        sliderView.selectedIndex = self.orderStatus.hashValue // 默认选中第2个
        self.selectIndex = self.orderStatus.hashValue
        view.addSubview(sliderView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //更新默认数据
        let defaultVC = contentViews[self.selectIndex] as! ZXMyOrderViewController
        defaultVC.loadDataWithIndex(self.selectIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ZXMyOrderRootViewController:MQSliderViewDelegate {
    func didSelectedSliderViewItem(_ index: NSInteger,_ selectedVC: UIViewController) {
        self.selectIndex = index
        let orderVC = selectedVC as! ZXMyOrderViewController
        orderVC.loadDataWithIndex(index)
    }
}
