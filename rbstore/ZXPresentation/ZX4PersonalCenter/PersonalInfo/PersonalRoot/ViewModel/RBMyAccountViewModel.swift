//
//  RBMyAccountViewModel.swift
//  rbstore
//
//  Created by 120v on 2017/7/20.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

typealias RBMyAccountCompletion = (Bool,Int,Dictionary<String,Any>,String,ZXError?) ->Void

class RBMyAccountViewModel: NSObject {

    //MARK: - 上传更新图片
    class func httpRequestForUploadHeadImage(image:UIImage,completion:RBMyAccountCompletion?) -> Void {
        //1.图片处理
        // 固定图片方向
//        let fixImage:UIImage = UIImage.fixOrientation(image)
//        let cutImage:UIImage = UIImage.cut(toSquare: fixImage)
//        let uploadImag:UIImage = UIImage.scaleImage(with: cutImage, to: CGSize.init(width: 300.0, height: 300.0))
        var paramas:Dictionary<String,Any> = Dictionary.init()
        paramas["directory"] = "user"
        paramas["type"] = "user"
        
        let array:NSArray = NSArray.init(objects: image)
        ZXNetwork.uploadImage(to: ZXAPI.address(image: ZXAPIConst.Upload.url), images: array as! Array<UIImage>, params: paramas.zx_signDicNotEncode() as Dictionary<String, Any>, compressRatio: 1.0) { (success, status, content, string, error) in
            completion!(success, status, content, string, error)
        }
    }
    
    //MARK: - 更新用户头像
    class func httpRequestForModifyUserIocnWithFilePath(filePath:String,completion:RBMyAccountCompletion?) -> Void {
        var paramas:Dictionary<String,Any> = Dictionary.init()
       
        if filePath.isEmpty == false {
            let headString:String = NSString.init(format: "%@", filePath) as String
            paramas["headPortrait"] = headString
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.address(module: ZXAPIConst.Personal.updateHead), params: paramas, method: .post) { (success, status, content, string, error) in
            completion!(success, status, content, string, error)
        }
    }
    
    //MARK: - 头像
    class func saveUserHeadProtrait(filePath:String) ->Void {
        let user = ZXUser.user
        user.headPortraitFilesStr = filePath
    }

}
