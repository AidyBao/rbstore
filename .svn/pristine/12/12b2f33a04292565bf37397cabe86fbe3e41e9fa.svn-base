//
//  ZXShoppingCartViewController.swift
//  rbstore
//
//  Created by screson on 2017/7/12.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXSelectedCartItem: NSObject {
    var item: ZXCartModel?
    var section:Int = 0
}

class ZXShoppingCartViewController: ZXUIViewController {
    var editSectionIndex = -1
    var bEditing = false
    var cartList = [ZXCartModel]()
    @IBOutlet weak var tblOrderList: UITableView!
    
    @IBOutlet weak var bntCheckAll: UIButton!
    
    @IBOutlet weak var bottomControlView: UIView!
    @IBOutlet weak var commitBottomBackView: UIView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBOutlet weak var lbTotalPrice: UILabel!
    
    
    @IBOutlet weak var deleteBottomBackView: UIView!
    @IBOutlet weak var btnMoveToMark: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    fileprivate var isListLoading = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = false
        self.title = "购物车"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.zx_emptyColor
        
        self.tblOrderList.backgroundColor = UIColor.clear        
        self.tblOrderList.register(UINib(nibName: ZXCartTableViewCell.NibName, bundle: nil), forCellReuseIdentifier: ZXCartTableViewCell.reuseIdentifier)
        self.tblOrderList.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(zx_refresh))
        
        self.bntCheckAll.isSelected = false
        self.bntCheckAll.setImage(#imageLiteral(resourceName: "zx-uncheck"), for: .normal)
        self.bntCheckAll.setImage(#imageLiteral(resourceName: "zx-check"), for: .highlighted)
        self.bntCheckAll.setImage(#imageLiteral(resourceName: "zx-check"), for: .selected)
        
        self.btnMoveToMark.titleLabel?.font = UIFont.zx_bodyFont
        self.btnMoveToMark.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        self.lbTotalPrice.font = UIFont.zx_bodyFont
        self.lbTotalPrice.textColor = UIColor.zx_textColorBody
        self.setPriceText(0)
        
        self.changeToEditing(false,updateTable: false)
        self.bottomControlView.isHidden = true
    }
    
    func setPriceText(_ price:Double) {
        let price = "\(price)".zx_priceFormat(color: nil)
        let total = "合计:"
        let attr = NSAttributedString.zx_fontFormat(total, font: UIFont.zx_bodyFont, at: NSMakeRange(0, 3))
        attr.append(price)
        self.lbTotalPrice.attributedText = attr

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstLoad {
            firstLoad = false
            self.loadList()
        } else {
            self.loadList(false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.changeToEditing(false,updateTable: true)
    }
    
    override func zx_refresh() {
        self.loadList()
    }
    //编辑 完成
    override func zx_rightBarButtonAction(index: Int) {
        if self.cartList.count == 0 {
            self.changeToEditing(false,updateTable: false)
            return
        }
        self.changeToEditing(!bEditing,updateTable: true)
    }
    //MARK: - 获取列表
    fileprivate func loadList(_ showHUD:Bool = true) {
        if isListLoading {
            return isListLoading = true
        }
        self.isListLoading = true
        if showHUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: nil)
        }
        ZXCartViewModel.getCartList { (code, success, list, errorMsg) in
            ZXEmptyView.hide(from: self.view)
            ZXHUD.hide(for: self.view, animated: true)
            if self.tblOrderList.mj_header != nil {
                self.tblOrderList.mj_header.endRefreshing()
            }
            self.isListLoading = false
            if success {
                if let list = list {
                    self.cartList = list
                }
                self.updateUIAction()
            } else {
                ZXNetwork.errorCodeParse(code, httpError: {
                    if self.cartList.count == 0 {
                        ZXEmptyView.show(in: self.view, type: .networkError, text: ZX_NETWORK_ERROR, retry: {
                            self.loadList()
                        })
                    } else {
                        ZXHUD.showFailure(in: self.view, text: ZX_NETWORK_ERROR, delay: ZXConst.zxdelayTime)
                    }
                }, serverError: {
                    if self.cartList.count == 0 {
                        ZXEmptyView.show(in: self.view, type: .networkError, text: errorMsg, retry: {
                            self.loadList()
                        })
                    } else {
                        ZXHUD.showFailure(in: self.view, text: errorMsg, delay: ZXConst.zxdelayTime)
                    }
                })
            }
        }
    }
    
    func updateUIAction(needUpdateTable:Bool = true) {
        if self.cartList.count == 0 {
            ZXEmptyView.show(in: self.view, type: .cartEmpty, text: nil, retry: {
                self.loadList()
            })
            self.changeToEditing(false, updateTable: false)
        }
        self.bottomControlView.isHidden = false
        if needUpdateTable {
            self.tblOrderList.reloadData()
        }
        
        if self.zx_isAllGoodsChecked() {
            self.bntCheckAll.isSelected = true
        } else {
            self.bntCheckAll.isSelected = false
        }
        
        self.setPriceText(self.zx_totalPrice())
        
        //更新数字
        ZXHomePageViewModel.badgeUpdate()
    }

    fileprivate func changeToEditing(_ editing:Bool,updateTable:Bool) {
        if editing {//切换到编辑中状态 （便感觉）
            self.tblOrderList.mj_header.endRefreshing()
            self.tblOrderList.mj_header = nil
            self.zx_addNavBarButtonItems(textNames: ["完成"], font: nil, color: nil, at: .right)
            bEditing = true
            self.deleteBottomBackView.isHidden = false
            self.commitBottomBackView.isHidden = true
        } else {//非编辑状态 （完成）
            if self.tblOrderList.mj_header == nil {
                self.tblOrderList.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(zx_refresh))
            }
            self.zx_addNavBarButtonItems(textNames: ["编辑"], font: nil, color: nil, at: .right)
            bEditing = false
            self.deleteBottomBackView.isHidden = true
            self.commitBottomBackView.isHidden = false
            
            self.clearEditSelectStatus()
        }
        
        if self.zx_isAllGoodsChecked() {
            self.bntCheckAll.isSelected = true
        } else {
            self.bntCheckAll.isSelected = false
        }
        
        if updateTable {
            self.tblOrderList.reloadData()
        }
    }

    //MARK: - 判断全部选中状态
    func zx_isAllGoodsChecked() -> Bool {
        if self.cartList.count > 0 {
            if self.cartList.count == 1 {//只有一条 非编辑状态下
                let c = self.cartList.first!
                if !bEditing {
                    if c.zx_status == .inSale,c.stock > 0,c.zx_isChosen {
                        return true
                    }
                } else {//编辑模式
                    if c.zx_editChecked {
                        return true
                    }
                }
                
                return false
            }
            var isAllChecked = true
            
            if bEditing {
                for c in self.cartList {
                    if !c.zx_editChecked {
                        isAllChecked = false
                        break
                    }
                }
            } else {
                var isAllInvalid = true//全部无效、无货
                for c in self.cartList {
                    //只检测有效状态的商品
                    if c.zx_status == .inSale {
                        isAllInvalid = false
                        if c.stock > 0,!c.zx_isChosen{
                            isAllChecked = false
                            break
                        }
                    }
                }
                if isAllInvalid {
                    isAllChecked = false
                }
            }
            
            return isAllChecked
        }
        return false
    }
    //MARK: - 已选中的商品列表
    func zx_selectedList() -> [ZXSelectedCartItem] {
        var list = [ZXSelectedCartItem]()
        if self.cartList.count > 0 {
            for (idx,c) in self.cartList.enumerated() {
                
                if bEditing {
                    if c.zx_editChecked {
                        let item = ZXSelectedCartItem()
                        item.item = c
                        item.section = idx
                        list.append(item)
                    }
                } else {//只检测有效的状态
                    if c.zx_status == .inSale,c.zx_isChosen {
                        let item = ZXSelectedCartItem()
                        item.item = c
                        item.section = idx
                        list.append(item)
                    }
                }
                
            }
        }
        return list
    }
    //MARK: - 清除编辑时的选中状态
    fileprivate func clearEditSelectStatus() {
        for c in self.cartList {
            c.clearEditCheckStatus()
        }
    }
    
    func zx_totalPrice() -> Double {
        var price:Double = 0
        let list = self.zx_selectedList()
        for c in list {
            if let item = c.item {
                price += item.salePrice * Double(item.num)
            }
        }
        return price
    }
    
    //MARK: - Button Action
    //MARK: - 全选
    @IBAction func checkAllAction(_ sender: UIButton) {
        //ZXEmptyView.show(in: self.tblOrderList, type: .cartEmtpy, text: "购物车空的哦\n去首页看看", retry: nil)
        if self.cartList.count > 0 {
            if bEditing {
                if self.bntCheckAll.isSelected {
                    self.bntCheckAll.isSelected = false
                    for c in self.cartList {
                        c.zx_editChecked = false
                    }
                } else {
                    self.bntCheckAll.isSelected = true
                    for c in self.cartList {
                        c.zx_editChecked = true
                    }

                }
                self.updateUIAction()
            } else {
                if self.cartList.count == 1 {
                    let c = self.cartList.first!
                    if c.zx_status != .inSale || c.stock <= 0 {//一件商品 并无效 不选中
                        self.bntCheckAll.isSelected = false
                        return
                    }
                }
                
                if self.bntCheckAll.isSelected {
                    ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: nil)
                    ZXCartViewModel.updateSelect(cartIds: [], select: false, completion: { (c, s, errorMsg) in
                        ZXHUD.hide(for: self.view, animated: true)
                        if s {
                            self.bntCheckAll.isSelected = false
                            for c in self.cartList {
                                c.isChosen = 0
                            }
                            self.updateUIAction()
                        } else {
                            ZXNetwork.errorCodeParse(c, httpError: {
                                ZXHUD.showFailure(in: self.view, text: ZX_NETWORK_ERROR, delay: ZXConst.zxdelayTime)
                            }, serverError: {
                                ZXHUD.showFailure(in: self.view, text: errorMsg, delay: ZXConst.zxdelayTime)
                            })
                        }
                    })
                } else {
                    ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: nil)
                    ZXCartViewModel.updateSelect(cartIds: [], select: true, completion: { (c, s, errorMsg) in
                        ZXHUD.hide(for: self.view, animated: true)
                        if s {
                            self.bntCheckAll.isSelected = true
                            for c in self.cartList {
                                c.isChosen = 1
                            }
                            self.updateUIAction()
                        } else {
                            ZXNetwork.errorCodeParse(c, httpError: {
                                ZXHUD.showFailure(in: self.view, text: ZX_NETWORK_ERROR, delay: ZXConst.zxdelayTime)
                            }, serverError: {
                                ZXHUD.showFailure(in: self.view, text: errorMsg, delay: ZXConst.zxdelayTime)
                            })
                        }
                    })
                }
            }
            
        } else {
            self.bntCheckAll.isSelected = false
        }
    }
    
    //MARK: - 结算
    @IBAction func commitAction() {
        let selectedList = self.zx_selectedList()
        if selectedList.count > 0 {
            var specIds = [String]()
            var nums = [String]()
            for c in selectedList {
                if let item = c.item {
                    specIds.append(item.specProductId)
                    nums.append("\(item.num)")
                }
            }
            if specIds.count > 0 {
                ZXHUD.showLoading(in: self.view, text: "", delay: nil)
                ZXCartViewModel.payMent(specProductIds: specIds, specNums: nums, success: { (paymentModel, errorMsg) in
                    ZXHUD.hide(for: self.view, animated: true)
                    ZXInvoiceInputCache.setInfo(with: paymentModel?.memberData)
                    let takeOrder = ZXTakeOrderViewController()
                    takeOrder.paymentModel = paymentModel
                    self.navigationController?.pushViewController(takeOrder, animated: true)
                }, failed: { (c, errorMsg) in
                    ZXHUD.hide(for: self.view, animated: true)
                    ZXNetwork.errorCodeParse(c, httpError: {
                        ZXHUD.showFailure(in: self.view, text: ZX_NETWORK_ERROR, delay: ZXConst.zxdelayTime)
                    }, serverError: {
                        ZXHUD.showFailure(in: self.view, text: errorMsg, delay: ZXConst.zxdelayTime)
                    })
                })
                
            } else {
                ZXHUD.showText(in: self.view, text: "请选择有效商品", delay: ZXConst.zxdelayTime)
            }
        } else {
            ZXHUD.showText(in: self.view, text: "请选择商品", delay: ZXConst.zxdelayTime)
        }
    }
    
    //MARK: - 删除
    @IBAction func deleteAction(_ sender: UIButton) {
        let list = self.zx_selectedList()
        if list.count > 0 {
            ZXAlertUtils.showActionSheet(withTitle: "", message: "确定删除这\(list.count)种商品", buttonTexts: ["确定"], cancelText: nil) { (index) in
                if index == 0 {
                    var array = [Int]()
                    for item in list {
                        array.append(item.section)
                    }
                    self.removeCell(at: array, type: .delete)
                }
            }
        } else {
            ZXHUD.showText(in: self.view, text: "请选择商品", delay: ZXConst.zxdelayTime)
        }
    }
    
    //MARK: - 移入收藏
    @IBAction func moveToMarkAction(_ sender: UIButton) {
        let list = self.zx_selectedList()
        if list.count > 0 {
            ZXAlertUtils.showActionSheet(withTitle: "", message: "确定将这\(list.count)种商品移入收藏夹", buttonTexts: ["确定"], cancelText: nil) { (index) in
                if index == 0 {
                    var array = [Int]()
                    for item in list {
                        array.append(item.section)
                    }
                    self.removeCell(at: array, type: .mark)
                }
            }
        } else {
            ZXHUD.showText(in: self.view, text: "请选择商品", delay: ZXConst.zxdelayTime)
        }
    }
}
