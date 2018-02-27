//
//  ZXTextView.swift
//  YDY_GJ_3_5
//
//  Created by 120v on 2017/5/15.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

///return textView.text.Characters.count 返回textView的字数
@objc protocol ZXTextViewDelegate: NSObjectProtocol{
    
    @objc optional func getTextNum(textNum: Int)
    
}

class ZXTextView: UIView, UITextViewDelegate {
    
    //MARK: - Properties
    var textView: ZXUITextView!
    var placeLabel: UILabel!
    var characterNum    = 0
    ////限制文字字数
    var limitTextNum    = 0  {
        didSet{
            
        }
    }
    
    weak var delegate: ZXTextViewDelegate?
    var placeText : String = "" {
        didSet{
            placeLabel?.text = placeText
        }
    }
    
    //MARK: - LifeCycle
    init(frame: CGRect, placeHolder: String?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        placeText = placeHolder!
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Actions
    func setup() {
        
        textView = ZXUITextView.init()
        textView.font = UIFont.zx_bodyFont
        textView.tintColor = UIColor.lightGray
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = NSTextAlignment.right
        textView.textColor = UIColor.zx_textColorBody
        textView.delegate = self
        addSubview(textView!)
        
        placeLabel = UILabel.init()
        placeLabel.backgroundColor = UIColor.clear
        placeLabel?.text = placeText
        placeLabel.font = UIFont.zx_bodyFont
        placeLabel.textColor = UIColor.lightGray
        addSubview(placeLabel!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelH: CGFloat = 20.0
        let labelW: CGFloat = self.frame.width - 3
        let space: CGFloat = (self.frame.height - labelH)/2
        self.textView.frame =  CGRect.init(x: 0, y: 3, width: self.frame.size.width, height: self.frame.size.height)
        self.placeLabel.frame = CGRect.init(x: 3, y: space+2, width: labelW, height: labelH)
        
        let size = textView.text.zx_textRectSize(toFont: UIFont.zx_bodyFont, limiteSize: CGSize.init(width: self.frame.size.width, height: self.frame.size.height))
        if size.width > ZXBOUNDS_WIDTH - 4*14 - 10 - 70{
            textView.textAlignment = NSTextAlignment.left
        }
    }
    
    //MARK: - UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        placeLabel.isHidden = true
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if characterNum == 0 {
            placeLabel!.isHidden = false
        }else{
            placeLabel!.isHidden = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var str = textView.text
        characterNum = (str?.characters.count)!
        if characterNum > limitTextNum {
            textView.text = str?.substring(to: (str?.index((str?.startIndex)!, offsetBy: limitTextNum))!)
            characterNum = limitTextNum
            ZXHUD.showFailure(in: (UIApplication.shared.keyWindow?.rootViewController?.view)!, text: String.init(format: "输入字符长度不能大于%d！",limitTextNum), delay: ZXHUD_MBDELAY_TIME)
        }
        self.delegate?.getTextNum!(textNum: characterNum)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let selectedLength:Int = range.location
        let replaceLength:Int = text.characters.count

        if text != "",!(text.zx_predicateNickname()) || (textView.textInputMode?.primaryLanguage!.isEqual("emoji")) == true || ((textView.textInputMode?.primaryLanguage) == nil){
            return false
        }
        if selectedLength + replaceLength > limitTextNum  {
            ZXHUD.showFailure(in: (UIApplication.shared.keyWindow?.rootViewController?.view)!, text: "输入字符长度不能大于\(limitTextNum)！", delay: ZXHUD_MBDELAY_TIME)
            return false
        }
        return true
    }
    
    //重写hitTest方法,来处理在View点击外区域收回键盘
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isUserInteractionEnabled == false && self.alpha <= 0.01 && self.isHidden == true {
            return nil
        }
        if self.point(inside: point, with: event) == false {
            textView?.resignFirstResponder()
            return nil
        }else{
            for subView in self.subviews.reversed() {
                let convertPoint = subView.convert(point, from: self)
                let hitTestView = subView.hitTest(convertPoint, with: event)
                if (hitTestView != nil) {
                    return hitTestView
                }
            }
            return self
        }
    }
}

