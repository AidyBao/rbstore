//
//  ZXActivityViewController.swift
//  rbstore
//
//  Created by screson on 2017/7/21.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXActivityViewController: ZXUIViewController {
    let ccvDelegate = ZXCommonGoodsCCVDelegate()
    @IBOutlet weak var ccviewList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.zx_emptyColor
        self.ccviewList.backgroundColor = UIColor.zx_emptyColor
        self.ccviewList.contentInset = UIEdgeInsetsMake(0, 8, 0, 8)
        self.ccviewList.register(UINib(nibName: ZXSingleImageCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ZXSingleImageCollectionViewCell.reuseIdentifier)
        self.ccviewList.register(UINib(nibName: ZXCommonGoodsCCVCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ZXCommonGoodsCCVCell.reuseIdentifier)
        ccvDelegate.showTopImage = true
        self.ccviewList.delegate = ccvDelegate
        self.ccviewList.dataSource = ccvDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
