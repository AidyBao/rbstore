//
//  RBMyOrderViewController.swift
//  rbstore
//
//  Created by 120v on 2017/7/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

//enum RBOrderStatus {
//    case all
//    case waitPay
//    case waitSend
//    case shipped
//}

class RBMyOrderViewController: ZXUIViewController {
    
    @IBOutlet weak var segmentMaskView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var segmentCtrl:ZXSegment!
    var isSelectTitle: Bool = true
    var orderStatus: RBOrderStatus = RBOrderStatus.all
    var defaultSelectedIndex: NSInteger = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的订单"
        
        self.setUIStyle()
    }
    
    private func setUIStyle() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        self.segmentMaskView.layer.shadowOffset = CGSize.init(width: 0, height: 2.0)
        self.segmentMaskView.layer.shadowColor = UIColor.lightGray.cgColor
        self.segmentMaskView.layer.shadowOpacity = 0.8
        
        segmentCtrl = ZXSegment(origin: CGPoint.zero)
        segmentCtrl.delegate = self
        segmentCtrl.dataSource = self
        segmentCtrl.selectedIndex = self.orderStatus.hashValue
        self.defaultSelectedIndex = self.orderStatus.hashValue
        segmentMaskView.addSubview(segmentCtrl)
        
        
        collectionView.register(UINib(nibName: String.init(describing: RBMyOrderRootCell.self), bundle: nil), forCellWithReuseIdentifier: RBMyOrderRootCell.RBMyOrderRootCellID)
    }

   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //默认选中
        self.scrollToSelectedPage(at: self.orderStatus.hashValue)
    }

    private func scrollToSelectedPage(at index: NSInteger) {
        self.collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    lazy var segmentTitles: NSMutableArray = {
        let titles: NSMutableArray = NSMutableArray.init(array: ["全部","待付款","待发货","已发货"])
        return titles
    }()
}

extension RBMyOrderViewController: RBMyOrderRootCellDelegate {
    
    func didSelectRowAt(_ tableView: UITableView,_ orderRootModel: RBOrderRootModel ,didSelectRowAt indexPath: IndexPath) {
        self.pushToDetailController(orderRootModel)
    }
    
    func didSelectHeaderAction(_ model: RBOrderRootModel) {
        self.pushToDetailController(model)
    }
    
    func didSelectFooterAction(_ model: RBOrderRootModel) {
        self.pushToDetailController(model)
    }
    
    func pushToDetailController(_ model: RBOrderRootModel) {
        let detialVC: RBOrderDetailRootController = RBOrderDetailRootController.init()
        detialVC.hidesBottomBarWhenPushed = true
        detialVC.orderId = model.orderId
        self.navigationController?.pushViewController(detialVC, animated: true)
    }
    
    func didSelectedOrderButtonAction(_ sender: UIButton,_ model: RBOrderRootModel,_ scrollCurrentIndex: NSInteger) {
        
        switch sender.tag {
        case RBMyOrderFooterCell.OrderButton.checkTag:
            if (sender.titleLabel?.text?.isEqual(ButtonStatus.nowPay))! {//立即付款
                self.nowPayOrder(model,scrollCurrentIndex)
            }
            if (sender.titleLabel?.text?.isEqual(ButtonStatus.confirm))! {//确认收货
                self.confirmReceive(model,scrollCurrentIndex)
            }
            if (sender.titleLabel?.text?.isEqual(ButtonStatus.checkLogistics))! {//查看物流
                self.checkLogistics(model,scrollCurrentIndex)
            }
            
            break
        case RBMyOrderFooterCell.OrderButton.deleteTag:
            if (sender.titleLabel?.text?.isEqual(ButtonStatus.cancelOrder))! {//取消订单
                ZXAlertUtils.showAlert(wihtTitle: "", message: "要取消此订单吗?", buttonTexts: ["取消","确认"], action: { (index) in
                    switch index {
                    case 1:
                        self.cancelOrder(model,scrollCurrentIndex)
                    default:
                        break
                    }
                })
            }
            
            if (sender.titleLabel?.text?.isEqual(ButtonStatus.deleteOrder))! {//删除订单
                ZXAlertUtils.showAlert(wihtTitle: "", message: "要删除此订单吗?", buttonTexts: ["取消","确认"], action: { (index) in
                    switch index {
                    case 1:
                        self.deleteOrder(model,scrollCurrentIndex)
                    default:
                        break
                    }
                })
            }
            
            if (sender.titleLabel?.text?.isEqual(ButtonStatus.checkLogistics))! {//产看物流
                self.checkLogistics(model,scrollCurrentIndex)
            }

        default:
            break
        }
    }
    
    //MARK: - 立即付款
    func nowPayOrder(_ model: RBOrderRootModel,_ scrollCurrentIndex: NSInteger) {
        print("立即付款")
        
        let payModel = ZXBSPayModel.init()
        payModel.orderId = "\(model.orderId)"
        payModel.orderNo = model.orderNo
        ZXBSControl.payOrder(payModel)
    }
    
    //MARK: - 确认收货
    func confirmReceive(_ model: RBOrderRootModel,_ scrollCurrentIndex: NSInteger) {
        print("确认收货")
        let operateFlag: Int = 2
        ZXHUD.showLoading(in: self.view, text: "确认中", delay: ZXHUD_MBDELAY_TIME)
        RBOrderCenter.requestForUpdateOrderStatus(orderId: model.orderId, operateFlag: operateFlag, completion: { (success,status) in
            ZXHUD.hide(for: self.view, animated: true)
            if success {
                if status == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: "确认成功", delay: ZXHUD_MBDELAY_TIME)
                    self.collectionView.reloadItems(at: [IndexPath.init(row: scrollCurrentIndex, section: 0)])
                }else{
                    ZXHUD.showFailure(in: self.view, text: "确认失败", delay: ZXHUD_MBDELAY_TIME)
                }
            }
        }) { (status, error) in
            if status != ZXAPI_LOGIN_INVALID {
                ZXHUD.showFailure(in: self.view, text: "确认失败", delay: ZXHUD_MBDELAY_TIME)
            }
        }
    }
    
    //MARK: - 查看物流
    func checkLogistics(_ model: RBOrderRootModel,_ scrollCurrentIndex: NSInteger) {
        print("查看物流")
    }
    
    //MARK: - 取消订单
    func cancelOrder(_ model: RBOrderRootModel,_ scrollCurrentIndex: NSInteger) {
        print("取消订单")
        let operateFlag: Int = 1
        ZXHUD.showLoading(in: self.view, text: "正在取消订单", delay: ZXHUD_MBDELAY_TIME)
        RBOrderCenter.requestForUpdateOrderStatus(orderId: model.orderId, operateFlag: operateFlag, completion: { (success,status) in
            ZXHUD.hide(for: self.view, animated: true)
            if success {
                if status == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: "取消订单成功", delay: ZXHUD_MBDELAY_TIME)
                    self.collectionView.reloadItems(at: [IndexPath.init(row: scrollCurrentIndex, section: 0)])
                }else{
                    ZXHUD.showFailure(in: self.view, text: "取消订单失败", delay: ZXHUD_MBDELAY_TIME)
                }
            }
        }) { (status, error) in
            if status != ZXAPI_LOGIN_INVALID {
                ZXHUD.showFailure(in: self.view, text: "取消订单失败", delay: ZXHUD_MBDELAY_TIME)
            }
        }
    }
    
    //MARK: - 删除订单
    func deleteOrder(_ model: RBOrderRootModel,_ scrollCurrentIndex: NSInteger) {
        print("删除")
        ZXHUD.showLoading(in: self.view, text: "删除中", delay: ZXHUD_MBDELAY_TIME)
        RBOrderCenter.requestForDeleteOrder(orderId: model.orderId, completion: { (success,status) in
            if success {
                if status == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: "删除订单成功", delay: ZXHUD_MBDELAY_TIME)
                    self.collectionView.reloadItems(at: [IndexPath.init(row: scrollCurrentIndex, section: 0)])
                }else{
                    ZXHUD.showFailure(in: self.view, text: "删除订单失败", delay: ZXHUD_MBDELAY_TIME)
                }
            }
        }) { (status, error) in
             ZXHUD.showFailure(in: self.view, text: "删除订单失败", delay: ZXHUD_MBDELAY_TIME)
        }
    }
}


