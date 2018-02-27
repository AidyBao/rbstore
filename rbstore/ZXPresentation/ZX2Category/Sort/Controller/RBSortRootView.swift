//
//  RBSortRootView.swift
//  rbstore
//
//  Created by 120v on 2017/7/17.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

protocol RBSortRootViewDelegate: NSObjectProtocol {
    func didSelectedConfirmButtonAction(_ sender: UIButton , _ selectedStr: String)
}

//筛选页距左边距与屏幕宽度比
let SortViewGap_Scale:CGFloat = 0.10

class RBSortRootView: UIView {
    //MARK: - 属性
    weak var delegate: RBSortRootViewDelegate?
    let animationDuration = 0.35
    var isAnimating = false
    var isTypeFilterShow = false
    @IBOutlet weak var mainMaskView: UIView!
    @IBOutlet weak var contentMaskView: UIView!
    @IBOutlet weak var contentMaskViewGap: NSLayoutConstraint!
    @IBOutlet weak var toolMaskView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var confirmBTN: UIButton!
    @IBOutlet weak var resetBTN: UIButton!
    var isOpen: Bool = false   //是否展开
    var dataSource: NSMutableArray = []
    var lastSelectedStr: String = ""
    
    //MARK: - LoadNib
    class func loadNib() -> RBSortRootView {
        let view: RBSortRootView = Bundle.main.loadNibNamed(String.init(describing: RBSortRootView.self), owner: self, options: nil)?.first as! RBSortRootView
        return view
    }
    
    func show() {
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = UIScreen.main.bounds
        //
        self.setUIStyle()
        //
        self.setCollectionViewUI()
        //
        self.showSortView(true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - UIStyle
    func setUIStyle() {
        self.backgroundColor = UIColor.clear
        self.mainMaskView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        self.contentMaskView.backgroundColor = UIColor.white
        
//        self.toolMaskView.layer.shadowColor = UIColor.lightGray.cgColor
        self.toolMaskView.layer.shadowColor = UIColor.black.cgColor
        self.toolMaskView.layer.shadowRadius = 2
        self.toolMaskView.layer.shadowOffset = CGSize.init(width: 0, height: -1)
        self.toolMaskView.layer.shadowOpacity = 0.2
        
        self.resetBTN.backgroundColor = UIColor.white
        self.resetBTN.setTitleColor(UIColor.zx_textColorTitle, for: UIControlState.normal)
        
        self.confirmBTN.layer.insertSublayer(self.bgGradientLayer, at: 0)
        self.confirmBTN.backgroundColor = UIColor.zx_tintColor
        self.confirmBTN.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    
    //MARK: - CollectionView
    func setCollectionViewUI() {
        self.collectionView.width = ZXBOUNDS_WIDTH * (1 - SortViewGap_Scale)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: String.init(describing: GoodsPropertyRootCell.self), bundle: nil), forCellWithReuseIdentifier: GoodsPropertyRootCell.GoodsPropertyRootCellID)
        self.collectionView.register(UINib.init(nibName: String.init(describing: RBSortHeader.self), bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: RBSortHeader.RBSortHeaderID)
    }
    
    //MARK: - 数据源
    func loadData(dataSoruce dataArray: NSMutableArray) {
        self.dataSource = dataArray
        self.collectionView.reloadData()
    }
    
    //MARK: - 重置
    @IBAction func resetBTNAction(_ sender: UIButton) {
        
        self.isOpen = false
        
        for superModel in self.dataSource {
            if ((superModel as? RBSortRootModel) != nil) {
                let superArray =  (superModel as? RBSortRootModel)?.fieldOptionList
                if superArray?.count != 0 {
                    for subModel in superArray! {
                        if ((subModel as? RBSortChrildModel)?.isSelected)! {
                            (subModel as? RBSortChrildModel)?.isSelected = false
                        }
                    }
                }
            }
        }
        
        self.collectionView.reloadData()
    }
    
    //MARK: - 确认
    @IBAction func confirmBTNAction(_ sender: UIButton) {
        
        let multiArray: NSMutableArray = NSMutableArray.init()
        for model in self.dataSource {
            let rootModel = model as! RBSortRootModel
            let subArr = rootModel.fieldOptionList
            
            let singleArray: NSMutableArray = NSMutableArray.init()
            for childrenModel in subArr {
                let subModel = childrenModel as! RBSortChrildModel
                if subModel.isSelected {
                    singleArray.add(subModel.attributeId)
                }
            }
            if singleArray.count != 0 {
                let str: String = singleArray.componentsJoined(by: ",")
                let singleStr: String = "\(rootModel.attrListId)" + "_" + str
                multiArray.add(singleStr)
            }
        }
        
        let selectedStr: String = multiArray.componentsJoined(by: "|")
        
        if delegate != nil {
            delegate?.didSelectedConfirmButtonAction(sender,selectedStr)
        }

        self.showSortView(false)
    }

    //MARK: - 显示/隐藏筛选视图
    func showSortView(_ show: Bool) {
        
        if isTypeFilterShow == show {
            return
        }
        
        if isAnimating {
            return
        }
        
        isAnimating = true
        self.contentMaskViewGap.constant = ZXBOUNDS_WIDTH
        
        if show {
            self.hideMaskView(false)
            self.contentMaskViewGap.constant = ZXBOUNDS_WIDTH * SortViewGap_Scale
            UIView.animate(withDuration: animationDuration, animations: {
                self.layoutIfNeeded()
            }, completion: { (finished) in
                self.isAnimating = false
                self.isTypeFilterShow = true
            })
        }else{
            self.hideMaskView(true)
            self.contentMaskViewGap.constant = ZXBOUNDS_WIDTH
            UIView.animate(withDuration: animationDuration, animations: {
                self.layoutIfNeeded()
            }, completion: { (finished) in
                self.isAnimating = false
                self.isTypeFilterShow = false
            })
        }
    }
    
    //MARK: - 显示/隐藏背景视图
    private func hideMaskView(_ hide:Bool) {
        if self.mainMaskView.isHidden == hide {
            return
        }
        if hide {
            UIView.animate(withDuration: animationDuration, animations: {
                self.mainMaskView.alpha = 0.0
                self.alpha = 0.0
            }, completion: { (finished) in
                self.mainMaskView.isHidden = true
                self.isHidden = true
            })
        }else {
            self.isHidden = false
            UIView.animate(withDuration: animationDuration, animations: {
                self.mainMaskView.alpha = 1.0
                self.alpha = 1.0
            }, completion: { finished in
            })
        }
    }
    
    //MARK: - 渐变色
    fileprivate var bgGradientLayer:CAGradientLayer = {
        let gradLayer:CAGradientLayer = CAGradientLayer.init(layer: CALayer())
        gradLayer.frame = CGRect(x: 0, y: 0, width: (ZXBOUNDS_WIDTH - (1 - SortViewGap_Scale))/2, height: 45)
        gradLayer.startPoint = CGPoint.init(x: 0, y: 1)
        gradLayer.endPoint = CGPoint.init(x: 1, y: 1)
        gradLayer.colors = [UIColor(red: 108 / 255.0, green: 112 / 255.0, blue: 225 / 255.0, alpha: 1.0).cgColor,UIColor(red: 77 / 255.0, green: 83 / 255.0, blue: 216 / 255.0, alpha: 1.0).cgColor]
        return gradLayer
    }()
    
    //MARK: - Remove
    @IBAction func swipeCollectionViewAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.right {
            self.confirmBTNAction(UIButton.init())
//            self.showSortView(false)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.showSortView(false)
        self.confirmBTNAction(UIButton.init())
    }
}
