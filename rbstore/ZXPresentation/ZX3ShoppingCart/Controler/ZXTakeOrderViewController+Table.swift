//
//  ZXTakeOrderViewController+Table.swift
//  rbstore
//
//  Created by screson on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension ZXTakeOrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0://地址
                let cell = tableView.dequeueReusableCell(withIdentifier: ZXAddressTableViewCell.reuseIdentifier, for: indexPath) as! ZXAddressTableViewCell
                cell.reloadData(adderss: self.paymentModel?.defualtAddress)
                return cell
            case 1://商品
                let cell = tableView.dequeueReusableCell(withIdentifier: ZXTKGoodsTableViewCell.reuseIdentifier, for: indexPath) as! ZXTKGoodsTableViewCell
                if let m = self.paymentModel {
                    if indexPath.row == 0 {
                        cell.reloadData(model: m.specProductList[indexPath.row], cornerType: .top)
                    } else {
                        cell.reloadData(model: m.specProductList[indexPath.row], cornerType: .none)
                    }
                }
                return cell
            case 2://商品合计
                let cell = tableView.dequeueReusableCell(withIdentifier: ZXLRTableViewCell.reuseIdentifier, for: indexPath) as! ZXLRTableViewCell
                cell.reloadData(cornerType: .bottom, lineType: .top)
                cell.lbLeftText.text = "商品合计："
                cell.lbRightText.text = ""
                if let m = self.paymentModel {
                    cell.lbRightText.text = String.init(format: "%0.2f", m.productTotal).zx_priceString()
                }
                return cell
            case 3://
                switch indexPath.row {
                    case 0://运费
                        let cell = tableView.dequeueReusableCell(withIdentifier: ZXLRTableViewCell.reuseIdentifier, for: indexPath) as! ZXLRTableViewCell
                        cell.reloadData(cornerType: .top, lineType: .bottom)
                        cell.lbLeftText.text = "运费："
                        cell.lbRightText.text = ""
                        if let m = self.paymentModel {
                            
                            cell.lbRightText.text = m.zx_freightInfo
                        }
                        return cell
                    case 1://留言
                        let cell = tableView.dequeueReusableCell(withIdentifier: ZXRemarkInputCell.reuseIdentifier, for: indexPath) as! ZXRemarkInputCell
                        return cell
                    case 2://合计
                        let cell = tableView.dequeueReusableCell(withIdentifier: ZXLRTableViewCell.reuseIdentifier, for: indexPath) as! ZXLRTableViewCell
                        cell.lbLeftText.text = "合计："
                        cell.lbRightText.text = ""
                        if let m = self.paymentModel {
                            if m.zx_isOpenInvoice {
                                cell.reloadData(cornerType: .none, lineType: .both)
                            } else {
                                cell.reloadData(cornerType: .bottom, lineType: .top)

                            }
                            cell.lbRightText.text = String.init(format: "%0.2f", m.payTotal).zx_priceString()
                        }
                        return cell
                    case 3://发票
                        let cell = tableView.dequeueReusableCell(withIdentifier: ZXReceiptCheckCell.reuseIdentifier, for: indexPath) as! ZXReceiptCheckCell
                        cell.btnCheck.isSelected = ZXInvoiceInputCache.needOpenInvoice
                        cell.lbReceiptInfo.text = ZXInvoiceInputCache.zx_titleDescription
                        return cell
                    default:
                        break
                }
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: ZXInvalidGoodsTableViewCell.reuseIdentifier, for: indexPath) as! ZXInvalidGoodsTableViewCell
                if let m = self.paymentModel {
                    let count = m.errorList.count
                    if indexPath.row == 0 {
                        if count == 1 {
                            cell.reloadData(m.errorList[indexPath.row], cornerType: .all)
                        } else {
                            cell.reloadData(m.errorList[indexPath.row], cornerType: .top)
                        }
                    } else if indexPath.row == count - 1 {
                        cell.reloadData(m.errorList[indexPath.row], cornerType: .bottom)
                    } else {
                        cell.reloadData(m.errorList[indexPath.row], cornerType: .none)
                    }
                }
                return cell
            default:
                break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ZXLRTableViewCell.reuseIdentifier, for: indexPath) as! ZXLRTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let m = self.paymentModel {
            switch section {
                case 0://地址
                    return 1
                case 1://商品
                    return m.specProductList.count
                case 2://商品合计
                    if m.specProductList.count > 0 {
                        return 1
                    }
                    return 0
                case 3://运费 留言 合计 发票
                    if m.specProductList.count > 0 {
                        if m.zx_isOpenInvoice {
                            return 4
                        }
                        return 3
                    }
                    return 0
                case 4://失效商品
                    return m.errorList.count
                default:
                    return 1
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let m = self.paymentModel,m.errorList.count > 0, section == 4 {
            let header = self.tblList.dequeueReusableHeaderFooterView(withIdentifier: ZXSingleTextCellHeader.reuseIdentifier) as! ZXSingleTextCellHeader
            header.lbText.textAlignment = .left
            header.lbText.textColor = UIColor.zx_textColorBody
            header.lbText.text = "失效商品"
            return header
        }
        return nil
    }
}

extension ZXTakeOrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case 0:
                let addrList = RBAddressViewController()
                addrList.zx_defaultAddress = self.paymentModel?.defualtAddress
                addrList.callBack = { [unowned self] addr in
                    self.paymentModel?.defualtAddress = addr
                    self.tblList.reloadSections(IndexSet([indexPath.section]), with: .none)
                }
                self.navigationController?.pushViewController(addrList, animated: true)
            case 3:
                if indexPath.row == 3 { //发票信息
                    let receiptInfo = ZXReceiptViewController()
                    if let pm = self.paymentModel {
                        ZXInvoiceInputCache.infomation = pm.zx_invoiceInfomation
                    }
                    self.navigationController?.pushViewController(receiptInfo, animated: true)
                }
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0://收货人信息
                return UITableViewAutomaticDimension
            case 1://商品
                return 90
            case 2://合计
                return 49
            case 3://运费 留言 合计 发票
                return 45
            case 4://失效商品
                return 80
            default:
                return 45
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 || section == 3 {
            return CGFloat.leastNormalMagnitude
        }
        if let m = self.paymentModel,m.specProductList.count > 0 {
            return 10
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 14
        } else if section == 4 { //失效商品
            return 30
        }
        return CGFloat.leastNormalMagnitude
    }
}
