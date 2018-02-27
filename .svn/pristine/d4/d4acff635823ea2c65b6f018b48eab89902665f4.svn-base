//
//  ZXAddressView.swift
//  YDY_GJ_3_5
//
//  Created by 120v on 2017/5/16.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

typealias ZXAddressViewBlock = (_ proviceStr:String,_ proviceCode:Int,_ cityStr:String,_ cityCode:Int,_ disStr:String,_ disCode:Int) -> Void

protocol ZXAddressViewDelegate: NSObjectProtocol {
    func didSelectedRemove()
}

class ZXAddressView: UIView {

    //MARK: - 参数
    weak var delegate: ZXAddressViewDelegate?
    var block:ZXAddressViewBlock?
    var proIndex:NSInteger      = 0//选择省份的索引
    var cityIndex:NSInteger     = 0//选择城市的索引
    var distrIndex:NSInteger    = 0//选择区（县）的索引
    
    var proStr:String           = ""//省份
    var cityStr:String          = ""//城市
    var disStr:String           = ""//区（县）
    
    var proCode:Int             = -1//省份id
    var cityCode:Int            = -1//城市id
    var disCode:Int             = -1//区（县）id
    var isLoad: Bool            = false
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initWithUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initWithUI()
    }
    
    func show() -> Void {
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    fileprivate func initWithUI() -> Void {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        //动画
        self.loadAnimation(dismiss: false)
        
        //
        self.backView.addSubview(self.cancelButton)
        //
        self.backView.addSubview(self.titleLabel)
        //
        self.backView.addSubview(self.confirmButton)
        //
        self.backView.addSubview(self.geliView)
        //
        self.backView.addSubview(self.pickerView)
        
        //数据
        self.loadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //
        self.backView.frame = CGRect.init(x: 0, y: ZX_BOUNDS_HEIGHT - 202, width: ZX_BOUNDS_WIDTH, height: 202)
        
        //
        self.cancelButton.frame = CGRect.init(x: 10, y: 0, width: 50, height: 40)
        self.cancelButton.setTitleColor(UIColor.zx_tintColor, for: UIControlState.normal)
        self.cancelButton.titleLabel?.textAlignment = NSTextAlignment.left
        self.cancelButton.setTitle("取消", for: UIControlState.normal)
        self.cancelButton.titleLabel?.font = UIFont.zx_bodyFont
        self.cancelButton.addTarget(self, action: #selector(cancelButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        //
        self.titleLabel.width = 80.0
        self.titleLabel.height = 40.0
        self.titleLabel.centerX = self.centerX
        self.titleLabel.y = 0
        self.titleLabel.text = "所在地区"
        self.titleLabel.font = UIFont.zx_bodyFont
        self.titleLabel.textColor = UIColor.zx_textColorBody
        
        //
        self.confirmButton.frame = CGRect.init(x: ZX_BOUNDS_WIDTH - 60, y: 0, width: 50, height: 40)
        self.confirmButton.setTitleColor(UIColor.zx_tintColor, for: UIControlState.normal)
        self.confirmButton.titleLabel?.textAlignment = NSTextAlignment.right
        self.confirmButton.setTitle("确定", for: UIControlState.normal)
        self.confirmButton.titleLabel?.font = UIFont.zx_bodyFont
        self.confirmButton.addTarget(self, action: #selector(confirmButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        //
        self.geliView.frame = CGRect.init(x: 0, y: self.cancelButton.frame.maxY, width: ZX_BOUNDS_WIDTH, height: 1)
        
        //
        self.pickerView.frame = CGRect.init(x: 0, y: self.geliView.frame.maxY, width: ZX_BOUNDS_WIDTH, height: self.backView.height - self.geliView.y)
    }
    
    
    //MARK: - 取消
    @objc fileprivate func cancelButtonClick(_ sender:UIButton) -> Void {
        self.loadAnimation(dismiss: true)
        if delegate != nil {
            delegate?.didSelectedRemove()
        }
    }
    
    //MARK: - 确定
    @objc fileprivate func confirmButtonClick(_ sender:UIButton) -> Void {
        //
        if self.block != nil {
            self.block?(self.proStr,self.proCode,self.cityStr,self.cityCode,self.disStr,self.disCode)
        }
        
        //
        self.loadAnimation(dismiss: true)
        
        if delegate != nil {
            delegate?.didSelectedRemove()
        }
    }
    
    //MARK: - 默认地址
    func updateDefault(_ code:String) -> Void {
        
        if code.isEmpty {
            return
        }
        
        //1.按照“-”截取字符串
        let aArray:Array = code.components(separatedBy: "-")
        let provinceId:Int = Int(aArray[0])!
        let cityId:Int = Int(aArray[1])!
        let areaId:Int = Int(aArray[2])!
        
        //4.查找省
        if provinceId != 0 {
            var provinceModel:ZXProvinceModel?
            self.provinceArray.enumerateObjects({ (obj : Any, idx: Int, stop:UnsafeMutablePointer<ObjCBool>) in
                provinceModel = obj as? ZXProvinceModel
                
                if provinceModel?.provinceId == provinceId {
                    stop[0] = true
                    self.proStr = (provinceModel?.name)!
                    self.proCode = (provinceModel?.provinceId)!
                    //选中指定行
                    self.pickerView.reloadComponent(0)
                    self.pickerView.selectRow(idx, inComponent: 0, animated: true)
                    //查找城市数据
                    self.cityArray = (provinceModel?.children)!
                }
            })
        }
        
        //5.查找市
        if cityId != 0 {
            var cityModel:ZXCityModel?
            self.cityArray.enumerateObjects({ (obj : Any, idx: Int, stop:UnsafeMutablePointer<ObjCBool>) in
                cityModel = obj as? ZXCityModel
                if cityModel?.cityId == cityId {
                    stop[0] = true
                    self.cityStr = (cityModel?.name)!
                    self.cityCode = (cityModel?.cityId)!
                    //选中指定行
                    self.pickerView.reloadComponent(1)
                    self.pickerView.selectRow(idx, inComponent: 1, animated: true)
                    //查找区域数据
                    self.disArray = (cityModel?.children)!
                }
            })
        }
        
        //5.查找区
        if areaId != 0 {
            var areaModel:ZXParishModel?
            self.disArray.enumerateObjects({ (obj : Any, idx: Int, stop:UnsafeMutablePointer<ObjCBool>) in
                areaModel = obj as? ZXParishModel
                if areaModel?.parishId == areaId {
                    stop[0] = true
                    self.disStr = (areaModel?.name)!
                    self.disCode = (areaModel?.parishId)!
                    //选中指定行
                    self.pickerView.reloadComponent(2)
                    self.pickerView.selectRow(idx, inComponent: 2, animated: true)
                }
            })
        }
    }
    
    //MARK: - 动画
    func loadAnimation(dismiss:Bool) -> Void {
       
        let animation:CATransition = CATransition.init()
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        if dismiss {
            animation.fillMode = kCAFillModeRemoved
            animation.type = kCATransitionReveal            //动画效果
            animation.subtype = kCATransitionFromBottom     //动画方向
        }else{
            animation.fillMode = kCAFillModeForwards
            animation.type = kCATransitionMoveIn            //动画效果
            animation.subtype = kCATransitionFromTop     //动画方向
        }
        self.backView.layer.add(animation, forKey: "animation")
        if dismiss {
            UIView.beginAnimations("fadeOut", context: nil) //淡出
            self.backView.alpha = 0.0
            self.alpha = 0.0
            self.removeFromSuperview()
        }else {
            self.alpha = 0.0
            UIView.beginAnimations("fadeIn", context: nil) //淡人
            self.addSubview(self.backView)
            self.alpha = 1.0
        }
        UIView.commitAnimations()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point:CGPoint = (touches.first?.location(in: self))!
        if  !self.backView.frame.contains(point) {
            self.loadAnimation(dismiss: true)
            
            if delegate != nil {
                delegate?.didSelectedRemove()
            }
        }
    }
    
    //MARK: - Lazy
    lazy var backView: UIView = {
        let backView:UIView = UIView.init()
        backView.backgroundColor = UIColor.white
        return backView
    }()
    
    lazy var cancelButton: UIButton = {
        let cancelButton:UIButton = UIButton.init()
        return cancelButton
    }()
    
    lazy var confirmButton: UIButton = {
        let confirmButton:UIButton = UIButton.init()
        return confirmButton
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel:UILabel = UILabel.init()
        return titleLabel
    }()
    
    lazy var geliView: UIView = {
        let geliView:UIView = UIView.init()
        geliView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return geliView
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView:UIPickerView = UIPickerView.init()
        pickerView.delegate = self
        pickerView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        pickerView.showsSelectionIndicator = true
        return pickerView
    }()
    
    //取出所有数据(json类型，在plist里面)
    lazy var AllArray: NSMutableArray = {
//        let AllArray:NSMutableArray = NSMutableArray.init(contentsOfFile: Bundle.main.path(forResource: "Address", ofType: "plist")!)!
        let AllArray:NSMutableArray = NSMutableArray.init(capacity: 5)
        return AllArray
    }()
    
    //省份数据
    lazy var provinceArray: NSMutableArray = {
        let provinceArray:NSMutableArray = NSMutableArray.init(capacity: 5)
        return provinceArray
    }()
    
    //城市数据
    lazy var cityArray: NSMutableArray = {
        let cityArray:NSMutableArray = NSMutableArray.init(capacity: 5)
        return cityArray
    }()
    
    //区（县）的数组
    lazy var disArray: NSMutableArray = {
        let disArray:NSMutableArray = NSMutableArray.init(capacity: 5)
        return disArray
    }()

}

extension ZXAddressView:UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLB:UILabel = UILabel.init()
        pickerLB.numberOfLines = 0
        pickerLB.textAlignment = NSTextAlignment.center
        pickerLB.font = UIFont.systemFont(ofSize: 15.0)
        pickerLB.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return pickerLB
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.proIndex = row
            self.cityIndex = 0
            self.distrIndex = 0
            if let provinceModel = self.provinceArray.object(at: row) as? ZXProvinceModel {
                //省
                self.proStr = provinceModel.name
                self.proCode = provinceModel.provinceId
                //1.市
                self.cityArray = provinceModel.children 
                self.pickerView.reloadComponent(1)
                self.pickerView.selectRow(0, inComponent: 1, animated: true)
                
                //2.区
                if let cityModel = self.cityArray.object(at: self.cityIndex) as? ZXCityModel {
                    //
                    self.cityStr = cityModel.name
                    self.cityCode = cityModel.cityId
                    
                    //
                    self.disArray = cityModel.children 
                    self.pickerView.reloadComponent(2)
                    self.pickerView.selectRow(0, inComponent: 2, animated: true)
                    
                    //
                    let praishModel = self.disArray.object(at: self.distrIndex) as! ZXParishModel
                    self.disStr = praishModel.name
                    self.disCode = praishModel.parishId
                }
            }
        case 1:
            self.cityIndex = row
            self.distrIndex = 0
            if let cityModel = self.cityArray.object(at: row) as? ZXCityModel {
                //
                self.cityStr = cityModel.name
                self.cityCode = cityModel.cityId
                
                //
                self.disArray = cityModel.children 
                self.pickerView.reloadComponent(2)
                self.pickerView.selectRow(0, inComponent: 2, animated: true)
                
                let praishModel = self.disArray.object(at: self.distrIndex) as! ZXParishModel
                self.disStr = praishModel.name
                self.disCode = praishModel.parishId
            }
        case 2:
            self.distrIndex = row
            //
            let praishModel = self.disArray.object(at: row) as! ZXParishModel
            self.disStr = praishModel.name
            self.disCode = praishModel.parishId
        default:
            break
        }
    }
}

extension ZXAddressView:UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return provinceArray.count
        case 1:
            return cityArray.count
        case 2:
            return disArray.count
        default:
            break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            let provinceModel = self.provinceArray.object(at: row) as! ZXProvinceModel
            return provinceModel.name
        case 1:
            let cityModel = self.cityArray.object(at: row) as! ZXCityModel
            return cityModel.name
        case 2:
            let praishModel = self.disArray.object(at: row) as! ZXParishModel
            return praishModel.name
        default:
            break
        }
        
        print(self.proStr,self.cityStr,self.disStr)
        
        return nil
    }
}

//MARK: - HTTP
extension ZXAddressView {
    //MARK: - 首次刷新数据(默认选中为0行)
    fileprivate func loadData() -> Void {
        
        //从缓存中取地址（数据在登录时请求并缓存）
        let addArray = ZXAddressCache.addressModelArray
        if addArray?.count == 0 {
            self.requestForAddress()
        }
        self.AllArray = addArray!
        
        if self.AllArray.count == 0 {
            return
        }
        
        //1.省
        self.provinceArray = self.AllArray.mutableCopy() as! NSMutableArray
        self.pickerView.reloadComponent(0)
        self.pickerView.selectRow(0, inComponent: 0, animated: true)
        //设置默认地址——省
        let provinceModel = self.provinceArray.object(at: 0) as! ZXProvinceModel
        self.proStr = provinceModel.name
        self.proCode = provinceModel.provinceId
        
        if self.provinceArray.count == 0 {
            print("没有城市相关数据")
        }
        
        if let provinceModel = self.provinceArray.object(at: self.proIndex) as? ZXProvinceModel {

            //2.市
            self.cityArray = provinceModel.children 
            self.pickerView.reloadComponent(1)
            self.pickerView.selectRow(0, inComponent: 1, animated: true)
            //设置默认地址——市
            let cityModel = self.cityArray.object(at: 0) as! ZXCityModel
            self.cityStr = cityModel.name
            self.cityCode = cityModel.cityId
            //3.区
            if let cityModel = self.cityArray.object(at: self.cityIndex) as? ZXCityModel {
                self.disArray = cityModel.children 
                self.pickerView.reloadComponent(2)
                self.pickerView.selectRow(0, inComponent: 2, animated: true)
                
                //设置默认地址——区
                let praishModel = self.disArray.object(at: self.distrIndex) as! ZXParishModel
                self.disStr = praishModel.name
                self.disCode = praishModel.parishId
            }
        }
    }
    
    func requestForAddress() {
        ZXHUD.showLoading(in: self, text: ZX_LOADING_TEXT, delay: ZXHUD_MBDELAY_TIME)
        RBPersonalCenter.requestForGetArea { (array) in
            ZXHUD.hide(for: self, animated: true)
            if array.count != 0 {
                self.AllArray = array
                if self.AllArray.count != 0 {
                    self.provinceArray = self.AllArray.mutableCopy() as! NSMutableArray
                    if self.provinceArray.count != 0 , let provinceModel = self.provinceArray.object(at: self.proIndex) as? ZXProvinceModel {
                        self.cityArray = provinceModel.children
                        if self.cityArray.count != 0 , let cityModel = self.cityArray.object(at: self.cityIndex) as? ZXCityModel {
                            self.disArray = cityModel.children
                        }
                    }
                }
                self.pickerView.reloadAllComponents()
            }else{
                ZXHUD.showFailure(in: self, text: "暂无区域数据", delay: ZXHUD_MBDELAY_TIME)
            }
        }
    }
}
