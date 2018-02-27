//
//  ZXAddressViewController.swift
//  rbstore
//
//  Created by 120v on 2017/8/22.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

protocol ZXAddressViewControllerDelegate: NSObjectProtocol {
    func didSelectedAddressView(_ proviceStr:String,_ proviceCode:Int,_ cityStr:String,_ cityCode:Int,_ disStr:String,_ disCode:Int) -> Void
}

class ZXAddressViewController: UIViewController {
    
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var titleLB: UILabel!
    
    var delegate:ZXAddressViewControllerDelegate?
    var proIndex:NSInteger      = 0//选择省份的索引
    var cityIndex:NSInteger     = 0//选择城市的索引
    var distrIndex:NSInteger    = 0//选择区（县）的索引
    
    var proStr:String           = ""//省份
    var cityStr:String          = ""//城市
    var disStr:String           = ""//区（县）
    
    var proCode:Int             = -1//省份id
    var cityCode:Int            = -1//城市id
    var disCode:Int             = -1//区（县）id
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.maskView.backgroundColor = UIColor.clear
        //如果缓存没有数据，则从新请求
        if self.AllArray.count == 0 {
            self.requestForAddress()
        }
        
        //
        self.setFirstDefaultData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestForAddress() {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD_MBDELAY_TIME)
        RBPersonalCenter.requestForGetArea { (array) in
            ZXHUD.hide(for: self.view, animated: true)
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
                
                self.setFirstDefaultData()
                
                self.pickerView.reloadAllComponents()
            }else{
                ZXHUD.showFailure(in: self.view, text: "暂无区域数据", delay: ZXHUD_MBDELAY_TIME)
            }
        }
    }
    
    func setFirstDefaultData() {
        if self.provinceArray.count != 0,self.cityArray.count != 0,self.disArray.count != 0 {
            let proMode = self.provinceArray.object(at: 0) as! ZXProvinceModel
            self.proCode = proMode.provinceId
            self.proStr = proMode.name
            
            let cityMode = self.cityArray.object(at: 0) as! ZXCityModel
            self.cityCode = cityMode.cityId
            self.cityStr = cityMode.name
            
            let disMode = self.disArray.object(at: 0) as! ZXParishModel
            self.disCode = disMode.parishId
            self.disStr = disMode.name
            
            self.pickerView.reloadAllComponents()
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView.selectRow(0, inComponent: 1, animated: true)
            self.pickerView.selectRow(0, inComponent: 2, animated: true)
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        self.resetDefault()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        if delegate != nil {
            delegate?.didSelectedAddressView(self.proStr,self.proCode,self.cityStr,self.cityCode,self.disStr,self.disCode)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.resetDefault()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func resetDefault() {
        self.proStr = ""
        self.proCode = -1
        self.cityStr = ""
        self.cityCode = -1
        self.disStr = ""
        self.disCode = -1
    }
    
    //MARK: - 默认地址
    func setDefaultAddress(_ code:String) -> Void {
        
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
    
    //MARK: - Lazy
    //取出所有数据(json类型，在plist里面)
    lazy var AllArray: NSMutableArray = {
        //        let AllArray:NSMutableArray = NSMutableArray.init(contentsOfFile: Bundle.main.path(forResource: "Address", ofType: "plist")!)!
        var addArray:NSMutableArray = NSMutableArray.init(capacity: 5)
        addArray = ZXAddressCache.addressModelArray!
        return addArray
    }()
    
    //省份数据
    lazy var provinceArray: NSMutableArray = {
        var provinceArr:NSMutableArray = NSMutableArray.init(capacity: 5)
        if self.AllArray.count != 0 {
            provinceArr = self.AllArray.mutableCopy() as! NSMutableArray
        }
        return provinceArr
    }()
    
    //城市数据
    lazy var cityArray: NSMutableArray = {
        var cityArr:NSMutableArray = NSMutableArray.init(capacity: 5)
        if self.provinceArray.count != 0 , let provinceModel = self.provinceArray.object(at: self.proIndex) as? ZXProvinceModel {
            cityArr = provinceModel.children
        }
        return cityArr
    }()
    
    //区（县）的数组
    lazy var disArray: NSMutableArray = {
        var disArray:NSMutableArray = NSMutableArray.init(capacity: 5)
        if self.cityArray.count != 0 , let cityModel = self.cityArray.object(at: self.cityIndex) as? ZXCityModel {
            disArray = cityModel.children
        }
        return disArray
    }()
}

extension ZXAddressViewController: UIPickerViewDelegate {
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
            if self.provinceArray.count != 0, let provinceModel = self.provinceArray.object(at: row) as? ZXProvinceModel {
                //省
                self.proStr = provinceModel.name
                self.proCode = provinceModel.provinceId
                //1.市
                self.cityArray = provinceModel.children
                self.pickerView.reloadComponent(1)
                self.pickerView.selectRow(0, inComponent: 1, animated: true)
                
                //2.区
                if self.cityArray.count != 0, let cityModel = self.cityArray.object(at: self.cityIndex) as? ZXCityModel {
                    //
                    self.cityStr = cityModel.name
                    self.cityCode = cityModel.cityId
                    
                    //
                    self.disArray = cityModel.children
                    self.pickerView.reloadComponent(2)
                    self.pickerView.selectRow(0, inComponent: 2, animated: true)
                    
                    //
                    if self.disArray.count != 0, let praishModel = self.disArray.object(at: self.distrIndex) as? ZXParishModel {
                        self.disStr = praishModel.name
                        self.disCode = praishModel.parishId
                    }
                }
            }
        case 1:
            self.cityIndex = row
            self.distrIndex = 0
            if self.cityArray.count != 0, let cityModel = self.cityArray.object(at: row) as? ZXCityModel {
                //
                self.cityStr = cityModel.name
                self.cityCode = cityModel.cityId
                
                //
                self.disArray = cityModel.children
                self.pickerView.reloadComponent(2)
                self.pickerView.selectRow(0, inComponent: 2, animated: true)
                
                if self.disArray.count != 0, let praishModel = self.disArray.object(at: self.distrIndex) as? ZXParishModel {
                    self.disStr = praishModel.name
                    self.disCode = praishModel.parishId
                }
            }
        case 2:
            self.distrIndex = row
            //
            if self.disArray.count != 0, let praishModel = self.disArray.object(at: row) as? ZXParishModel {
                self.disStr = praishModel.name
                self.disCode = praishModel.parishId
            }
        default:
            break
        }
    }
}

extension ZXAddressViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            if self.provinceArray.count != 0 {
                return provinceArray.count
            }
        case 1:
            if self.cityArray.count != 0 {
                return cityArray.count
            }
        case 2:
            if self.disArray.count != 0 {
                return disArray.count
            }
        default:
            break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            if self.provinceArray.count != 0 {
                let provinceModel = self.provinceArray.object(at: row) as! ZXProvinceModel
                return provinceModel.name
            }
        case 1:
            if self.cityArray.count != 0 {
                let cityModel = self.cityArray.object(at: row) as! ZXCityModel
                return cityModel.name
            }
        case 2:
            if self.disArray.count != 0 {
                let praishModel = self.disArray.object(at: row) as! ZXParishModel
                return praishModel.name
            }
        default:
            break
        }
        return nil
    }
}

extension ZXAddressViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ZXDimmingPresentationController.init(presentedViewController: presented, presenting: presenting)
    }
}
