//
//  ZXHomepageViewController.swift
//  rbstore
//
//  Created by screson on 2017/7/12.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import ZXAutoScrollView

let ZX_FLOOR_IMAGE_HEIGHT = ceil((ZXBOUNDS_WIDTH - 8 * 2) / 4)

class ZXHomepageViewController: ZXUIViewController {
    fileprivate var hasSuccess = false
    fileprivate var failedCode = 0
    fileprivate var failedMsg = ""
    fileprivate var finishCount = 0
    
    //(ZXBOUNDS_WIDTH - 8 * 2) / 4 楼层图片比例 4 ： 1
    //楼层1  图片（ 4 ： 1） + 商品
    let floorType1Height:CGFloat = ZX_FLOOR_IMAGE_HEIGHT + ZXHorizontalTableCell.height + 5
    //楼层2 图片（2.5 ： 1）
    let floorType2Height:CGFloat = ceil((ZXBOUNDS_WIDTH - 8 * 2) / 5 * 2)
    
    @IBOutlet weak var tblHhomePage: UITableView!
    var bannerList  =   [ZXBannerModel]()
    var shortCategoryList   =   [ZXShortCategoryModel]()
    var active:ZXActivityModel?
    var floorList   =   [ZXHomeFloorsModel]()
    var floorCount  =   0
    
    fileprivate var pageIndex = 1
    var recommendGoodsList   =   [ZXRecommendGoodsModel]()
    
    var topBanner:ZXAutoScrollView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.zx_emptyColor
        
//        self.zx_addNavBarButtonItems(textNames: ["消息"], font: nil, color: nil, at: .right)
        
        self.zxTitleView.addSubview(self.searchButton)
//        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
//        let leading = NSLayoutConstraint(item: self.searchButton, attribute: .leading, relatedBy: .equal, toItem: self.zxTitleView, attribute: .leading, multiplier: 1, constant: 0)
//        let trailing = NSLayoutConstraint(item: self.searchButton, attribute: .trailing, relatedBy: .equal, toItem: self.zxTitleView, attribute: .trailing, multiplier: 1, constant: 0)
//        let centerY = NSLayoutConstraint(item: self.searchButton, attribute: .centerY, relatedBy: .equal, toItem: self.zxTitleView, attribute: .centerY, multiplier: 1, constant: 0)
//        let height = NSLayoutConstraint(item: self.searchButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 22)
//        self.zxTitleView.addConstraints([leading,trailing,centerY,height])
        self.searchButton.addTarget(self, action: #selector(showSearchView), for: .touchUpInside)
        self.navigationItem.titleView = self.zxTitleView
        self.messageButton.addTarget(self, action: #selector(showMessageList), for: .touchUpInside)
        self.messageView.addSubview(self.messageButton)
        self.messageView.addSubview(self.redDot)
//        self.zx_addNavBarButtonItems(customView: self.messageView, at: .right,offset: -3)
        if UIDevice.zx_DeviceSizeType() == .s_5_5_Inch {
            self.zx_addNavBarButtonItems(customView: self.messageView, at: .right,offset: -10)
        } else {
            self.zx_addNavBarButtonItems(customView: self.messageView, at: .right,offset: -3)
        }
        self.redDot.isHidden = true
        
        //Banner
        topBanner = ZXAutoScrollView(frame: CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH, height: ceil(ZXBOUNDS_WIDTH * 0.4))) // 宽高比例 5:2
        topBanner.backgroundColor = UIColor.zx_backgroundColor
        topBanner.delegate = self
        topBanner.dataSource = self
        topBanner.flipInterval = 5
        topBanner.pageControl.currentPageIndicatorTintColor = UIColor.zx_tintColor
        
        //self.tblHhomePage.tableHeaderView = self.topBanner
        self.tblHhomePage.backgroundColor = UIColor.zx_emptyColor
        self.tblHhomePage.delegate = self
        self.tblHhomePage.dataSource = self
        //分类
        self.tblHhomePage.register(UINib(nibName: ZXHomeCategoryTableViewCell.NibName, bundle: nil), forCellReuseIdentifier: ZXHomeCategoryTableViewCell.reuseIdentifier)
        //标题
        self.tblHhomePage.register(ZXSingleTextCellHeader.self, forHeaderFooterViewReuseIdentifier: ZXSingleTextCellHeader.reuseIdentifier)
        //最新活动
        self.tblHhomePage.register(UINib(nibName: ZXHorizontalTableCell.NibName, bundle: nil), forCellReuseIdentifier: ZXHorizontalTableCell.reuseIdentifier)

        //楼层Type1
        self.tblHhomePage.register(UINib(nibName: ZXFloorType1TableViewCell.NibName, bundle: nil), forCellReuseIdentifier: ZXFloorType1TableViewCell.reuseIdentifier)
        //单张图片Cell 楼层Type2
        self.tblHhomePage.register(UINib(nibName: ZXSingleImageTableViewCell.NibName, bundle: nil), forCellReuseIdentifier: ZXSingleImageTableViewCell.reuseIdentifier)
        //推荐
        self.tblHhomePage.register(UINib(nibName: ZXRecommendGoodsCell.NibName, bundle: nil), forCellReuseIdentifier: ZXRecommendGoodsCell.reuseIdentifier)
        
        self.tblHhomePage.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(zx_refresh))
        self.tblHhomePage.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(zx_loadmore))
        
        //badge update
        NotificationCenter.default.addObserver(self, selector: #selector(updateMsgInfo), name: ZXNotification.UI.badgeReload.zx_noticeName(), object: nil)
        // load data
        self.loadAction()
        
        ZXCommonViewModel.commonDicList(with: .seviceTel) { (model) in
            if let model = model {
                ZXGlobalData.serviceTel = model.value
            }
        }
    }
    
    func updateMsgInfo() {
        if ZXUser.user.zx_unreadMsg > 0 {
            self.redDot.isHidden = false
            UIApplication.shared.applicationIconBadgeNumber = ZXUser.user.zx_unreadMsg
        } else {
            self.redDot.isHidden = true
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    override func zx_refresh() {
        ZXHomePageViewModel.badgeUpdate()
        self.loadAction(false)
    }
    
    override func zx_loadmore() {
        self.loadGoodsList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            if firstLoad {
                firstLoad = false
                delegate.registRemoteNotification()
            }
        }
    }
    
    let redDot: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 28, y: 8, width: 6, height: 6)
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.red
        return view
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("     请输入商品名字", for: UIControlState.normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        button.titleLabel?.textAlignment = NSTextAlignment.left
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.titleLabel?.font = UIFont.zx_bodyFont(UIFont.zx_bodyFontSize - 2)
        button.backgroundColor = UIColor.zx_colorRGB(60, 60, 209, 1.0)
        button.frame = CGRect(x: 0, y: 12, width: ZXBOUNDS_WIDTH - 80, height: 22)
        button.layer.cornerRadius = 11
        button.layer.masksToBounds = true
        let imgvIcon = UIImageView(frame: CGRect(x: 5, y: 4, width: 13, height: 13))
        imgvIcon.contentMode = .scaleAspectFit
        imgvIcon.backgroundColor = UIColor.clear
        imgvIcon.image = #imageLiteral(resourceName: "search")
        button.addSubview(imgvIcon)
        return button
    }()
    
    let zxTitleView: UIView = {
        let tView = UIView(frame: CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 80, height: 44))
        tView.backgroundColor = UIColor.clear
        return tView
    }()
    
    let messageButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.clear
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
        btn.setImage(#imageLiteral(resourceName: "message-white"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "message-white"), for: .selected)
        btn.setImage(#imageLiteral(resourceName: "message-white"), for: .highlighted)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -3)
        return btn
    }()
    
    let messageView: UIView = {
        let tView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        tView.backgroundColor = UIColor.clear
        return tView
    }()
    
    func showSearchView() {
        let searchVC: RBSearchRootViewController = RBSearchRootViewController.init()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func showMessageList() {
        ZXRouter.showDetail(type: .messageList, model: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: ZXNotification.UI.badgeReload.zx_noticeName(), object: nil)
    }
}

extension ZXHomepageViewController {
    func loadAction(_ showAnimation:Bool = true) {
        if showAnimation {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: nil)
        }
        hasSuccess = false
        failedCode = 0
        failedMsg = ""
        finishCount = 0
        
        self.getBanner()
        self.getCategoryList()
        self.getActive()
        self.getFloorList()
        pageIndex = 1
        self.tblHhomePage.mj_footer.resetNoMoreData()
        self.loadGoodsList()
    }
    //MARK: - Banner
    fileprivate func getBanner() {
        ZXHomePageViewModel.getBannerList({ (list) in
            if let list = list {
                self.bannerList = list
                self.topBanner.reloadData()
            } else {
                self.bannerList.removeAll()
                self.topBanner.reloadData()
            }
            if self.bannerList.count > 0 {
                self.tblHhomePage.tableHeaderView = self.topBanner
            }
            self.hasSuccess = true
            self.checkEnd()
        }) { (code, errorMsg) in
            self.failedCode = code
            self.failedMsg = errorMsg
            self.checkEnd()
        }
    }
    //MARK: - Category
    fileprivate func getCategoryList() {
        ZXHomePageViewModel.getShortCategoryList({ (list) in
            if let list = list {
                self.shortCategoryList = list
                self.tblHhomePage.reloadData()
            } else {
                self.shortCategoryList.removeAll()
                self.tblHhomePage.reloadData()
            }
            self.hasSuccess = true
            self.checkEnd()
        }) { (code, errorMsg) in
            self.failedCode = code
            self.failedMsg = errorMsg
            self.checkEnd()
        }
    }
    //MARK: - Active
    fileprivate func getActive() {
        ZXHomePageViewModel.getActiveGoodsList({ (active) in
            if let active = active {
                self.active = active
                self.tblHhomePage.reloadData()
            } else {
                self.active = nil
                self.tblHhomePage.reloadData()
            }
            self.hasSuccess = true
            self.checkEnd()
        }) { (code, errorMsg) in
            self.failedCode = code
            self.failedMsg = errorMsg
            self.checkEnd()
        }
    }
    //MARK: - Floor
    fileprivate func getFloorList() {
        ZXHomePageViewModel.getFloorList({ (floorList) in
            if let floorList = floorList {
                self.floorList = floorList
                self.floorCount = floorList.count
                self.tblHhomePage.reloadData()
            } else {
                self.floorList.removeAll()
                self.floorCount = 0
                self.tblHhomePage.reloadData()
            }
            self.hasSuccess = true
            self.checkEnd()
        }) { (code, errorMsg) in
            self.failedCode = code
            self.failedMsg = errorMsg
            self.checkEnd()
        }
    }
    
    //MARK: - RecommendGoodsList
    fileprivate func loadGoodsList() {
        ZXHomePageViewModel.getRecommendGoodsList(pageNum: pageIndex, pageSize: ZX_PAGE_SIZE, completion: { (list) in
            self.hasSuccess = true
            if self.pageIndex == 1 {
                self.checkEnd()
            }
            
            self.tblHhomePage.mj_footer.endRefreshing()
            if let list = list,list.count < ZX_PAGE_SIZE {
                self.tblHhomePage.mj_footer.endRefreshingWithNoMoreData()
            }
            if self.pageIndex == 1 {
                self.recommendGoodsList.removeAll()
                self.recommendGoodsList = list ?? []
                if let list = list,list.count > 0 {
                    self.pageIndex += 1
                }
            } else {
                if let list = list {
                    self.recommendGoodsList.append(contentsOf: list)
                    self.pageIndex += 1
                } else {
                    self.tblHhomePage.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            self.tblHhomePage.reloadData()
        }) { (code, errorMsg) in
            self.failedCode = code
            self.failedMsg = errorMsg
            if self.pageIndex == 1 {
                self.checkEnd()
            }
        }
    }
    
    func checkEnd() {
        finishCount += 1
        if finishCount >= 5 {
            ZXHUD.hide(for: self.view, animated: true)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.tblHhomePage)
            self.tblHhomePage.mj_header.endRefreshing()
            if !hasSuccess {
                ZXNetwork.errorCodeParse(failedCode, httpError: { 
                    ZXEmptyView.show(in: self.view, type: .networkError, text: "网络连接失败", retry: {
                        self.loadAction(true)
                    })
                }, serverError: {
                    ZXEmptyView.show(in: self.view, type: .networkError, text: self.failedMsg, retry: {
                        self.loadAction(true)
                    })

                })
            } else {
                if self.active == nil,
                    self.bannerList.count == 0,
                    self.shortCategoryList.count == 0,
                    self.floorList.count == 0,
                    self.recommendGoodsList.count == 0 {
                    ZXEmptyView.show(in: self.view, type: .noData, text: "暂无相关数据", retry:  {
                        self.loadAction(true)
                    })
                }
            }
        }
    }
}
