//
//  ZXAPIDataparse.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/12.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

let ZXAPI_TIMEOUT_INTREVAL      =   10.0 //接口超时时间
let ZXAPI_SUCCESS:Int           =   0 //接口调用成功
let ZXAPI_UNREGIST:Int          =   100004 //用户不存在
let ZXAPI_STOCK_NOTENOUGH:Int   =   202005 //库存不足
let ZXAPI_LOGIN_INVALID:Int     =   100001 //登录失效
let ZXAPI_FORMAT_ERROR:Int      =   900900 //无数据或格式错误
let ZXAPI_SERVCE_ERROR:Int      =   -1009  //网络错误
let ZXAPI_SERVCE_STOP:Int       =   -1004  //网络错误

class ZXError: NSObject {
    var errorMessage:String = ""
    init(_ msg:String!) {
        super.init()
        errorMessage = msg
    }
    
    override var description: String{
        get {
            return errorMessage
        }
    }
}


typealias ZXAPISuccessAction        = (Int,Dictionary<String,Any>) -> Void          //Code,Response Object
typealias ZXAPIPOfflineAction       = (Int,ZXError,Dictionary<String,Any>) -> Void                         //OfflineMessage
typealias ZXAPIServerErrorAction    = (Int,ZXError,Dictionary<String,Any>) -> Void  //Status,ErrorMsg,Object
typealias ZXAPICompletionAction     = (Bool,Int,Dictionary<String,Any>,String,ZXError?) -> Void       //success 服务器正取返回，code = 0，Object,ObjectString,ErrorInfo

class ZXAPIDataparse: NSObject {
    
    fileprivate static func postLoginInvalidNotice(url:String) -> Bool{
        if url == ZXAPI.address(module: ZXAPIConst.Home.cartNum) ||
            url == ZXAPI.address(module: ZXAPIConst.Home.unreadMsg) ||
            url == ZXAPI.address(module: ZXAPIConst.User.updateEquipmentInfo) ||
            url == ZXAPI.address(module: ZXAPIConst.Category.getHistoricRecords){
            return false
        }
        return true
        
    }
    class func parseJsonObject(_ objA:Any?,
                               url:String? = nil,
                               success:ZXAPISuccessAction?,
                               offline:ZXAPIPOfflineAction?,
                               serverError:ZXAPIServerErrorAction?) {
        if let objB = objA as? Dictionary<String,Any> {
            var status = 0
            if let s = objB["status"] as? NSNumber {
                status = s.intValue
            }else if let s = objB["status"] as? String {
                status = Int(s)!
            }
            switch status {
                case ZXAPI_LOGIN_INVALID:
                    if let url = url,self.postLoginInvalidNotice(url: url) {
                        NotificationCenter.zxpost.loginInvalid()
                    }
                    offline?(status,ZXError.init((objB["msg"] as? String) ?? "用户登录失效"),objB)
                case ZXAPI_SUCCESS:
                    success?(status,objB)
                default:
                    serverError?(status,ZXError.init((objB["msg"] as? String) ?? "未知错误"),objB)
                    break
            }
        }else{
            serverError?(ZXAPI_FORMAT_ERROR,ZXError.init("无数据或格式错误"),[:])
        }
    }
}

extension ZXNetwork {
    
    class func errorCodeParse(_ code:Int,httpError:(() -> Void)?,serverError:(() -> Void)?,loginInvalid:(() -> Void)? = nil) {
        if code != ZXAPI_SUCCESS {
            if code == ZXAPI_LOGIN_INVALID {
                loginInvalid?()
            } else if code == NSURLErrorUnknown ||
                code == NSURLErrorCancelled ||
                code == NSURLErrorBadURL ||
                code == NSURLErrorUnsupportedURL ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost ||
                code == NSURLErrorDNSLookupFailed ||
                code == NSURLErrorHTTPTooManyRedirects ||
                code == NSURLErrorResourceUnavailable ||
                code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorRedirectToNonExistentLocation ||
                code == NSURLErrorBadServerResponse ||
                code == NSURLErrorUserCancelledAuthentication ||
                code == NSURLErrorUserAuthenticationRequired ||
                code == NSURLErrorZeroByteResource ||
                code == NSURLErrorCannotDecodeRawData ||
                code == NSURLErrorCannotDecodeContentData ||
                code == NSURLErrorCannotParseResponse{
                httpError?()
            } else {
                serverError?()
            }
        }
        
    }
    
    @discardableResult class func asyncRequest(withUrl url:String,
                                               params:Dictionary<String, Any>?,
                                               method:ZXHTTPMethod,
                                               completion:@escaping ZXAPICompletionAction) -> URLSessionTask? {
        var tempP = [String:Any]()
        if let p = params {
            tempP = p
        }
        if showRequestLog {
            print("\n------------Request------------\n请求地址:\n\(url)\n请求参数:\n\(String(describing: params))\n---------------------------\n")
        }
        if tempP["sign"] == nil {
            tempP = tempP.zx_signDic()
        }
        let task = ZXNetwork.zx_asyncRequest(withUrl: url, params: tempP, method: method, completion: { (objA, stringValue) in
            ZXAPIDataparse.parseJsonObject(objA,url: url, success: { (code, dic) in
                completion(true, code, dic, stringValue!, nil)
            }, offline: { (code, error, dic) in
                completion(false, code, dic, stringValue!, error)
            }, serverError: { (code, error, dic) in
                completion(false, code, dic, stringValue!, error)
            })
        }, timeOut: { (errorMsg) in
            completion(false,NSURLErrorTimedOut,[:],"",ZXError.init(errorMsg))
        }) { (code, errorMsg) in
            completion(false,code,[:],"",ZXError.init(errorMsg))
        }
        return task
    }
    
    @discardableResult class func uploadImage(to url:String!,
                                              images:Array<UIImage>!,
                                              params:Dictionary<String,Any>?,
                                              compressRatio:CGFloat,
                                              completion:@escaping ZXAPICompletionAction) -> URLSessionTask? {
        var tempP = [String:Any]()
        if let p = params {
            tempP = p
        }
        if tempP["sign"] == nil {
            tempP = tempP.zx_signDicNotEncode()
        }
        
        let task = ZXNetwork.zx_uploadImage(to: url, images: images, params: tempP, compressRatio: compressRatio, completion: { (objA, stringValue) in
            ZXAPIDataparse.parseJsonObject(objA, success: { (code, dic) in
                completion(true, code, dic, stringValue!, nil)
            }, offline: { (code, error, dic) in
                completion(false, code, dic, stringValue!, nil)
            }, serverError: { (code, error, dic) in
                completion(false, code, dic, stringValue!, nil)
            })
        }, timeOut: { (errorMsg) in
            completion(false,NSURLErrorTimedOut,[:],"",ZXError.init(errorMsg))
        }) { (code, errorMsg) in
            completion(false,code,[:],"",ZXError.init(errorMsg))
        }
        return task
    }
    
    @discardableResult class func fileupload(to url:String!,
                                             name: String,
                                             fileName: String,
                                             mimeType: String,
                                             fileData: Data,
                                             params:Dictionary<String,Any>?,
                                             completion:@escaping ZXAPICompletionAction) -> URLSessionTask? {
        var tempP = [String:Any]()
        if let p = params {
            tempP = p
        }
        if tempP["sign"] == nil {
            tempP = tempP.zx_signDicNotEncode()
        }
        let task = ZXNetwork.zx_fileupload(to: url, name: name, fileName: fileName, mimeType: mimeType, fileData: fileData, params: tempP, completion: { (objA, stringValue) in
            ZXAPIDataparse.parseJsonObject(objA, success: { (code, dic) in
                completion(true, code, dic, stringValue!, nil)
            }, offline: { (code, error, dic) in
                completion(false, code, dic, stringValue!, nil)
            }, serverError: { (code, error, dic) in
                completion(false, code, dic, stringValue!, nil)
            })
        }, timeOut: { (errorMsg) in
            completion(false,NSURLErrorTimedOut,[:],"",ZXError.init(errorMsg))
        }) { (code, errorMsg) in
            completion(false,code,[:],"",ZXError.init(errorMsg))
        }
        return task
    }
}
