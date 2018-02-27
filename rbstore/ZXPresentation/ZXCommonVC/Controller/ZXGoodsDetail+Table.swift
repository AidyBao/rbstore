//
//  ZXGoodsDetail+Table.swift
//  rbstore
//
//  Created by screson on 2017/7/28.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import JXPhotoBrowser

extension ZXGoodsDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: //商品图片
            let cell = tableView.dequeueReusableCell(withIdentifier: ZXGoodsTopImagesCell.reuseIdentifier, for: indexPath) as! ZXGoodsTopImagesCell
            cell.delegate = self
            cell.reloadData(self.goodsDetailModel?.product?.subPicsList)
            return cell
        case 1: //名称 价格
            let cell = tableView.dequeueReusableCell(withIdentifier: ZXGoodsDetailInfoCell.reuseIdentifier, for: indexPath) as! ZXGoodsDetailInfoCell
            cell.reloadData(self.goodsDetailModel)
            return cell
        case 2:// 运费
            let cell = tableView.dequeueReusableCell(withIdentifier: ZXLRTableViewCell.reuseIdentifier, for: indexPath) as! ZXLRTableViewCell
            cell.reloadData(cornerType: .none, lineType: .top, showArrow: true)
            cell.lbLeftText.textColor = UIColor.zx_textColorMark
            cell.lbLeftText.font = UIFont.zx_bodyFont(UIFont.zx_bodyFontSize - 1)
            if let model = self.goodsDetailModel {
                cell.lbLeftText.text = model.zx_freight
            } else {
                cell.lbLeftText.text = "运费说明"
            }
            cell.backgroundColor = UIColor.white
            cell.lbRightText.text = ""
            return cell
        case 3:// 规格
            let cell = tableView.dequeueReusableCell(withIdentifier: ZXLRTableViewCell.reuseIdentifier, for: indexPath) as! ZXLRTableViewCell
            cell.reloadData(cornerType: .none, lineType: .top, showArrow: true)
            cell.lbRightText.text = ""
            cell.rightLabelWidth.constant = 5
            cell.lbLeftText.textColor = UIColor.zx_textColorMark
            cell.lbLeftText.font = UIFont.zx_bodyFont(UIFont.zx_bodyFontSize - 1)
            
            if let m = self.goodsDetailModel {
                if m.zx_defaultSpecValid { //默认规格有效
                    if let selectedSpec = m.zx_selectedSpecCombo {
                        cell.lbLeftText.text = "已选: \(selectedSpec.zx_descriptionIn(m.zx_allSpecItem))"
                    } else if let defaultSpec = m.product?.zx_defaultSpec {
                        cell.lbLeftText.text = "已选: \(defaultSpec.zx_descriptionIn(m.zx_allSpecItem))"
                    } else {
                        cell.lbLeftText.text = "规格数量选择"
                    }
                } else {//默认规格无效
                    cell.lbLeftText.text = "规格数量选择"
                }
            } else {
                cell.lbLeftText.text = "规格数量选择"
            }
            return cell
        case 4://推荐标题
            let cell = tableView.dequeueReusableCell(withIdentifier: ZXSingleTextCell.reuseIdentifier, for: indexPath) as! ZXSingleTextCell
            cell.setText("- 同 类 推 荐 -")
            return cell
        case 5:// 推荐商品
            let cell = tableView.dequeueReusableCell(withIdentifier: ZXHorizontalTableCell.reuseIdentifier, for: indexPath) as! ZXHorizontalTableCell
            cell.reloadType(.detailRecommend)
            cell.backgroundColor = UIColor.white
            cell.reloadRecommendData(self.goodsDetailModel?.sortRecommendList)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ZXLRTableViewCell.reuseIdentifier, for: indexPath) as! ZXLRTableViewCell
            cell.backgroundColor = UIColor.white
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.goodsDetailModel != nil {
            if section == 4 || section == 5 { // 同类推荐
                if let list = self.goodsDetailModel?.sortRecommendList,list.count > 0 {
                    return 1
                } else {
                    return 0
                }
            }
            return 1
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
}

extension ZXGoodsDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { 
            switch indexPath.section {
                case 2://运费说明
                    //if let list = self.goodsDetailModel?.dictList {
                    if let model = self.goodsDetailModel {
                        let freight = ZXFreightInfoViewController()
                        //freight.list = list
                        freight.remark = model.zx_freightRemark
                        self.present(freight, animated: true, completion: nil)
                    } else {
                        ZXHUD.showFailure(in: self.view, text: "无运费相关信息", delay: ZXConst.zxdelayTime)
                    }
                case 3://规格选择
                    self.showSpecSelect()
                default:
                    break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return 270
            case 1:
                return UITableViewAutomaticDimension
            case 2,3:
                return 45
            case 4:
                return 28
            case 5://同类推荐
                return ZXHorizontalTableCell.height
            default:
                return 44
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 12
        } else if section == 5 { // 同类推荐
            if let list = self.goodsDetailModel?.sortRecommendList,list.count > 0 {
                return 12
            }
        }
        return CGFloat.leastNormalMagnitude
    }
}

extension ZXGoodsDetailViewController: UIScrollViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y + ZXBOUNDS_HEIGHT - 45) - (self.tblList.contentSize.height) >  50 {
            self.donotPerformDecelerate = true
            //self.setWebInfoAsPreview(false)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if self.donotPerformDecelerate {
            scrollView.setContentOffset(scrollView.contentOffset, animated: false)
            self.setWebInfoAsPreview(false)
        }
    }
}

extension ZXGoodsDetailViewController: ZXShowMoreProtocol {
    //MARK - 点击商品图片
    func zxGoodsTopImageSelected(at index: Int, for cell: ZXGoodsTopImagesCell) {
        if let m = self.goodsDetailModel,let p = m.product {
            let browser = PhotoBrowser(showByViewController: self, delegate: self)
            
            let pDelegate = PhotoBrowserNumberPageControlDelegate(numberOfPages: p.subPicsList.count)
            pDelegate.centerY = ZXBOUNDS_HEIGHT - 60
            browser.pageControlDelegate = pDelegate
            browser.show(index: index)
        }
    }
    
    func zxScrollToShowMore(type: ZXShowMoreType) {
        self.setWebInfoAsPreview(false,interval: 0.65)
    }
}

extension ZXGoodsDetailViewController: PhotoBrowserDelegate {
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        if let m = self.goodsDetailModel,let p = m.product {
            return p.subPicsList.count
        }
        return 0
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, rawUrlForIndex index: Int) -> URL? {
        if let m = self.goodsDetailModel,let p = m.product {
            return URL(string: p.subPicsList[index].urlStr)
        }
        return nil
    }
    
    /// 实现本方法以返回默认图片，缩略图或占位图
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        return UIImage.Default.goods
    }
    
    /// 实现本方法以返回默认图所在view，在转场动画完成后将会修改这个view的hidden属性
    /// 比如你可返回ImageView，或整个Cell
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        
        let cell = self.tblList.cellForRow(at: IndexPath(row: 0, section: 0))
        return cell
    }

}

