//
//  RBImageCropperViewController.swift
//  rbstore
//
//  Created by 120v on 2017/8/24.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

let SCALE_FRAME_Y    = 100.0
let BOUNDCE_DURATION = 0.3

@objc protocol RBImageCropperDelegate : NSObjectProtocol {
    func imageCropper(_ cropperViewController:RBImageCropperViewController, didFinished editImg:UIImage)
    
    func imageCropperDidCancel(_ cropperViewController:RBImageCropperViewController)
}

class RBImageCropperViewController: ZXUIViewController {
    
    var originalImage:UIImage?
    var editedImage:UIImage?
    
    var showImgView:UIImageView?
    var overlayView:UIView?
    var ratioView:UIView?
    
    var oldFrame:CGRect?
    var largeFrame:CGRect?
    var limitRatio:CGFloat?
    
    var latestFrame:CGRect?
    var cropFrame:CGRect?
    
    var tag:NSInteger?
    
    var delegate:RBImageCropperDelegate?
    
    deinit {
        self.originalImage = nil
        self.showImgView   = nil
        self.editedImage   = nil
        self.overlayView   = nil
        self.ratioView     = nil
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(originalImage:UIImage, cropFrame:CGRect, limitScaleRatio:CGFloat) {
        self.init(nibName: nil, bundle: nil)
        
        self.cropFrame = cropFrame
        self.limitRatio  = limitScaleRatio
        self.originalImage = self.fixOrientation(originalImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initControlBtn()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    // initView
    func initView() {
        self.view.backgroundColor = UIColor.black
        
        self.showImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        self.showImgView?.isMultipleTouchEnabled   = true
        self.showImgView?.isUserInteractionEnabled = true
        self.showImgView?.image                  = self.originalImage
        self.showImgView?.isUserInteractionEnabled = true
        self.showImgView?.isMultipleTouchEnabled   = true
        
        // scale to fit the screen
        let oriWidth = self.cropFrame!.size.width
        let oriHeight = (self.originalImage?.size.height)! * (oriWidth / (self.originalImage?.size.width)!)
        let oriX = (self.cropFrame?.origin.x)! + ((self.cropFrame?.size.width)! - oriWidth) / 2
        let oriY = (self.cropFrame?.origin.y)! + ((self.cropFrame?.size.height)! - oriHeight) / 2
        
        self.oldFrame = CGRect(x: oriX, y: oriY, width: oriWidth, height: oriHeight)
        self.latestFrame = self.oldFrame
        self.showImgView?.frame = self.oldFrame!
        
        self.largeFrame = CGRect(x: 0, y: 0, width: self.limitRatio! * self.oldFrame!.size.width, height: self.limitRatio! * self.oldFrame!.size.height)
        
        self.addGestureRecognizers()
        self.view.addSubview(self.showImgView!)
        
        self.overlayView = UIView(frame: self.view.bounds)
        self.overlayView?.alpha = 0.5
        self.overlayView?.backgroundColor = UIColor.black
        self.overlayView?.isUserInteractionEnabled = false
        self.overlayView?.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        
        self.view.addSubview(self.overlayView!)
        
        self.ratioView = UIView(frame: self.cropFrame!)
        self.ratioView?.layer.borderColor = UIColor.white.cgColor
        self.ratioView?.layer.borderWidth = 1.0
        self.ratioView?.autoresizingMask = UIViewAutoresizing()
        self.view.addSubview(self.ratioView!)
        
        self.overlayClipping()
    }
    
    func initControlBtn() {
        let cancelBtn = UIButton(frame: CGRect(x: 0, y: self.view.frame.size.height - 50.0, width: 100, height: 50))
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.titleLabel?.textColor = UIColor.white
        cancelBtn.setTitle("取消", for: UIControlState())
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        cancelBtn.titleLabel?.textAlignment = NSTextAlignment.center
        cancelBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cancelBtn.titleLabel?.numberOfLines = 0
        cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        cancelBtn.addTarget(self, action: #selector(RBImageCropperViewController.cancel(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(cancelBtn)
        
        let confirmBtn:UIButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 100.0, y: self.view.frame.size.height - 50.0, width: 100, height: 50))
        confirmBtn.backgroundColor = UIColor.clear
        confirmBtn.titleLabel?.textColor = UIColor.white
        confirmBtn.setTitle("确定", for: UIControlState())
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        confirmBtn.titleLabel?.textAlignment = NSTextAlignment.center
        confirmBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        confirmBtn.titleLabel?.numberOfLines = 0
        confirmBtn.titleEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        confirmBtn.addTarget(self, action: #selector(RBImageCropperViewController.confirm(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(confirmBtn)
    }
    
    // private func
    
    func cancel(_ sender:AnyObject) {
        if self.delegate != nil {
            if self.delegate!.responds(to: #selector(RBImageCropperDelegate.imageCropperDidCancel(_:))) {
                self.delegate!.imageCropperDidCancel(self)
            }
        }
    }
    
    func confirm(_ sender:AnyObject) {
        if self.delegate != nil {
            if self.delegate!.responds(to: #selector(RBImageCropperDelegate.imageCropper(_:didFinished:))) {
                self.delegate!.imageCropper(self, didFinished: self.getSubImage())
            }
        }
    }
    
    func overlayClipping() {
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        // Left side of the ratio view
        let leftRect = CGRect(x: 0, y: 0, width: self.ratioView!.frame.origin.x, height: self.overlayView!.frame.size.height)
        
        // Right side of the ratio view
        let rightRect = CGRect(x: self.ratioView!.frame.origin.x + self.ratioView!.frame.size.width, y: 0, width: self.overlayView!.frame.size.width - self.ratioView!.frame.origin.x - self.ratioView!.frame.size.width, height: self.overlayView!.frame.size.height)
        
        // Top side of the ratio view
        let topRect = CGRect(x: 0, y: 0, width: self.overlayView!.frame.size.width, height: self.ratioView!.frame.origin.y)
        
        // Bottom side of the ratio view
        let bottomRect = CGRect(x: 0, y: self.ratioView!.frame.origin.y + self.ratioView!.frame.size.height, width: self.overlayView!.frame.size.width, height: self.overlayView!.frame.size.height - self.ratioView!.frame.origin.y + self.ratioView!.frame.size.height)
        
        path.addRects([leftRect,rightRect,topRect,bottomRect])
        maskLayer.path = path
        self.overlayView?.layer.mask = maskLayer
        path.closeSubpath()
    }
    
    // register all gestures
    func addGestureRecognizers() {
        // pinch
        let pinchGestureRecognizer:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(RBImageCropperViewController.pinchView(_:)))
        self.view.addGestureRecognizer(pinchGestureRecognizer)
        
        // pan
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(RBImageCropperViewController.panView(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // pinch gesture handler
    func pinchView(_ pinchGestureRecognizer:UIPinchGestureRecognizer) {
        let view = self.showImgView!
        if pinchGestureRecognizer.state == UIGestureRecognizerState.began || pinchGestureRecognizer.state == UIGestureRecognizerState.changed {
            view.transform = view.transform.scaledBy(x: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale)
            pinchGestureRecognizer.scale = 1
        }
        else if pinchGestureRecognizer.state == UIGestureRecognizerState.ended {
            var newFrame = self.showImgView!.frame
            newFrame = self.handleScaleOverflow(newFrame)
            newFrame = self.handleBorderOverflow(newFrame)
            
            UIView.animate(withDuration: BOUNDCE_DURATION, animations: { () -> Void in
                self.showImgView!.frame = newFrame
                self.latestFrame = newFrame
            })
        }
    }
    
    //pan gesture handler
    func panView(_ panGestureRecognizer:UIPanGestureRecognizer) {
        let view = self.showImgView!
        if panGestureRecognizer.state == UIGestureRecognizerState.began || panGestureRecognizer.state == UIGestureRecognizerState.changed {
            let absCenterX = self.cropFrame!.origin.x + self.cropFrame!.size.width / 2
            let absCenterY = self.cropFrame!.origin.y + self.cropFrame!.size.height / 2
            let scaleRatio = self.showImgView!.frame.size.width / self.cropFrame!.size.width
            let acceleratorX = 1 - abs(absCenterX - view.center.x) / (scaleRatio * absCenterX)
            let acceleratorY = 1 - abs(absCenterY - view.center.y) / (scaleRatio * absCenterY)
            let translation = panGestureRecognizer.translation(in: view.superview)
            view.center = CGPoint(x: view.center.x + translation.x * acceleratorX, y: view.center.y + translation.y * acceleratorY)
            panGestureRecognizer.setTranslation(CGPoint.zero, in: view.superview)
        }
        else if panGestureRecognizer.state == UIGestureRecognizerState.ended {
            var newFrame = self.showImgView!.frame
            newFrame = self.handleBorderOverflow(newFrame)
            UIView.animate(withDuration: BOUNDCE_DURATION, animations: { () -> Void in
                self.showImgView!.frame = newFrame
                self.latestFrame = newFrame
            })
        }
    }
    
    func handleScaleOverflow(_ newFrame:CGRect) -> CGRect {
        var newFrame = newFrame
        let oriCenter = CGPoint(x: newFrame.origin.x + newFrame.size.width / 2, y: newFrame.origin.y + newFrame.size
            .height / 2)
        if newFrame.size.width < self.oldFrame!.size.width {
            newFrame = self.oldFrame!
        }
        if newFrame.size.width > self.largeFrame!.size.width {
            newFrame = self.largeFrame!
        }
        newFrame.origin.x = oriCenter.x - newFrame.size.width / 2
        newFrame.origin.y = oriCenter.y - newFrame.size.height / 2
        return newFrame
    }
    
    func handleBorderOverflow(_ newFrame:CGRect) -> CGRect {
        var newFrame = newFrame
        if newFrame.origin.x > self.cropFrame!.origin.x {
            newFrame.origin.x = self.cropFrame!.origin.x
        }
        if newFrame.maxX < self.cropFrame!.size.width {
            newFrame.origin.x = self.cropFrame!.size.width - newFrame.size.width
        }
        
        if newFrame.origin.y > self.cropFrame!.origin.y {
            newFrame.origin.y = self.cropFrame!.origin.y
        }
        if newFrame.maxY < self.cropFrame!.origin.y + self.cropFrame!.size.height {
            newFrame.origin.y = self.cropFrame!.origin.y + self.cropFrame!.size.height - newFrame.size.height
        }
        
        if self.showImgView!.frame.size.width > self.showImgView!.frame.size.height && newFrame.size.height <= self.cropFrame!.size.height {
            newFrame.origin.y = self.cropFrame!.origin.y + (self.cropFrame!.size.height - newFrame.size.height) / 2
        }
        return newFrame
    }
    
    func getSubImage() -> UIImage {
        let squareFrame = self.cropFrame!
        let scaleRatio = self.latestFrame!.size.width / self.originalImage!.size.width
        var x = (squareFrame.origin.x - self.latestFrame!.origin.x) / scaleRatio
        var y = (squareFrame.origin.y - self.latestFrame!.origin.y) / scaleRatio
        var w = squareFrame.size.width / scaleRatio
        var h = squareFrame.size.height / scaleRatio
        if self.latestFrame!.size.width < self.cropFrame!.size.width {
            let newW = self.originalImage!.size.width
            let newH = newW * (self.cropFrame!.size.height / self.cropFrame!.size.width)
            x = 0;
            y = y + (h - newH) / 2
            w = newH
            h = newH
        }
        if self.latestFrame!.size.height < self.cropFrame!.size.height {
            let newH = self.originalImage!.size.height
            let newW = newH * (self.cropFrame!.size.width / self.cropFrame!.size.height)
            x = x + (w - newW) / 2
            y = 0
            w = newH
            h = newH
        }
        
        let myImageRect = CGRect(x: x, y: y, width: w, height: h)
        let imageRef = self.originalImage!.cgImage
        let subImageRef = imageRef?.cropping(to: myImageRect)
        let size:CGSize = CGSize(width: myImageRect.size.width, height: myImageRect.size.height)
        UIGraphicsBeginImageContext(size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.draw(subImageRef!, in: myImageRect)
        let smallImage = UIImage(cgImage: subImageRef!)
        UIGraphicsEndImageContext()
        return smallImage
    }
    
    // orientation
    func fixOrientation(_ srcImg:UIImage) -> UIImage {
        if srcImg.imageOrientation == UIImageOrientation.up {
            return srcImg
        }
        var transform = CGAffineTransform.identity
        switch srcImg.imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: srcImg.size.width, y: srcImg.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: srcImg.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: srcImg.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2))
        case UIImageOrientation.up, UIImageOrientation.upMirrored: break
        }
        switch srcImg.imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: srcImg.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: srcImg.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:break
        }
        
        // 上下文
        let ctx:CGContext = CGContext(data: nil, width: Int(srcImg.size.width), height: Int(srcImg.size.height), bitsPerComponent: srcImg.cgImage!.bitsPerComponent, bytesPerRow: 0, space: srcImg.cgImage!.colorSpace!, bitmapInfo: srcImg.cgImage!.bitmapInfo.rawValue)!
        
        ctx.concatenate(transform)
        switch srcImg.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(srcImg.cgImage!, in: CGRect(x: 0, y: 0, width: srcImg.size.height, height: srcImg.size.width))
        default:
            ctx.draw(srcImg.cgImage!, in: CGRect(x: 0, y: 0, width: srcImg.size.width, height: srcImg.size.height))
        }
        
        let cgImg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgImg)
        
        ctx.closePath()
        return img
    }
    
}

