//
//  ZXCategoryRootViewController.swift
//  rbstore
//
//  Created by 120v on 2017/7/14.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

//筛选页距左边距与屏幕宽度比
let TableViewGap_Scale:CGFloat = 0.22

class ZXCategoryRootViewController: ZXUIViewController {
    
    @IBOutlet weak var tableViewMask: UIView!
    @IBOutlet weak var tableViewMaskGap: NSLayoutConstraint!
    @IBOutlet weak var collectionMask: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var lastSelectedIndex: NSInteger = 0

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
        self.view.backgroundColor = UIColor.zx_backgroundColor
        
        self.setUIStyle()
    }
    
    func setUIStyle() {
        self.tableViewMaskGap.constant = ZXBOUNDS_WIDTH * TableViewGap_Scale
        
        //NavView
        self.zxTitleView.addSubview(self.searchButton)
        self.searchButton.addTarget(self, action: #selector(showSearchView), for: .touchUpInside)
        self.navigationItem.titleView = self.zxTitleView
        self.messageButton.addTarget(self, action: #selector(showMessageList), for: .touchUpInside)
        self.messageView.addSubview(self.messageButton)
        self.messageView.addSubview(self.redDot)
        self.redDot.isHidden = true
        if UIDevice.zx_DeviceSizeType() == .s_5_5_Inch {
            self.zx_addNavBarButtonItems(customView: self.messageView, at: .right,offset: -10)
        } else {
            self.zx_addNavBarButtonItems(customView: self.messageView, at: .right,offset: -3)
        }
        
        
        //TableView
        self.tableView.register(UINib.init(nibName:String.init(describing: RBCategorySuperCell.self), bundle: nil), forCellReuseIdentifier: RBCategorySuperCell.RBCategorySuperCellID)
        //CollectionView
        self.collectionView.register(UINib(nibName: String.init(describing: RBCategorySubCell.self), bundle: nil), forCellWithReuseIdentifier: RBCategorySubCell.RBCategorySubCellID)
        self.collectionView.register(UINib(nibName: String.init(describing: RBCategorySubHeader.self), bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: RBCategorySubHeader.RBCategorySubHeaderID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.lastSelectedIndex = RBCateoryCenter.getLastCategorySelectedIndex()
        
        if ZXUser.user.isLogin {
            self.requestForGetPushNum()
        }
        
        self.requestForGetCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 属性
    lazy var dataSource: NSMutableArray = {
        let arr: NSMutableArray = NSMutableArray.init(capacity: 10)
        return arr
    }()
    
    lazy var childrenArray: NSMutableArray = {
        let arr: NSMutableArray = NSMutableArray.init(capacity: 10)
        return arr
    }()
    
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
    
    //MARK: - 搜索
    func showSearchView() {
        let searchVC: RBSearchRootViewController = RBSearchRootViewController.init()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    //MARK: - 消息
    func showMessageList() {
        ZXRouter.showDetail(type: .messageList, model: nil)
    }
}

//MARK: - HTTP
extension ZXCategoryRootViewController {
    
    func requestForGetCategory() {
        self.tableView.isHidden = true
        self.collectionView.isHidden = true
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD_MBDELAY_TIME)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Category.getCategory), params: nil, method: .post) { (success, status, content, string, error) in
            ZXHUD.hide(for: self.view, animated: true)
            if success {
                if status == ZXAPI_SUCCESS{
                    if let arr: Array<Any> = content["data"] as? Array {
                        let mArr: NSMutableArray = NSMutableArray.init(array: arr)
                        self.dataSource = RBCategoryRootModel.mj_objectArray(withKeyValuesArray: mArr)
                    }else{
                        ZXEmptyView.show(in: self.view, type: .noData, text: "暂无分类数据", retry: { 
                            ZXEmptyView.hide(from: self.view)
                        })
                    }
                }
                
                if self.dataSource.count != 0 {
                    self.tableView.isHidden = false
                    self.collectionView.isHidden = false
                    
                    self.tableView.reloadData()
                    self.tableView.selectRow(at: IndexPath.init(row: self.lastSelectedIndex, section: 0), animated: true, scrollPosition: .none)
                    
                    if self.dataSource.count != 0 {
                        let rootModel = self.dataSource.object(at: self.lastSelectedIndex) as! RBCategoryRootModel
                        self.childrenArray = rootModel.children
                    }
                    self.collectionView.reloadData()
                }else{
                    ZXEmptyView.show(in: self.view, type: .noData, text: "暂无分类数据", retry: {
                        ZXEmptyView.hide(from: self.view)
                        self.requestForGetCategory()
                    })
                }
            }else if status != ZXAPI_LOGIN_INVALID{
                ZXNetwork.errorCodeParse(status, httpError: {
                    ZXEmptyView.show(in: self.view, type: .networkError, text: "请检查您的网路", retry: {
                        ZXEmptyView.hide(from: self.view)
                        self.requestForGetCategory()
                    })
                }, serverError: {
                    ZXEmptyView.show(in: self.view, type: .networkError, text: error?.description, retry: {
                        ZXEmptyView.hide(from: self.view)
                        self.requestForGetCategory()
                    })
                })
            }
        }
    }
    
    //MARK: - 消息未读数
    func requestForGetPushNum() {
        RBCateoryCenter.requestForGetPushNum { (pushNum) in
            if pushNum > 0 {
                self.redDot.isHidden = false
            }else{
                self.redDot.isHidden = true
            }
        }
    }
}