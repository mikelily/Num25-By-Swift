//
//  PlayTableCell.swift
//  num25
//
//  Created by 蒼月喵 on 2018/6/12.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import UIKit

class PlayTableCell: UICollectionViewCell {
    var imageView:UIImageView!
    var titleLabel:UILabel!
//    var button:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 取得螢幕寬度
        let w = Double(UIScreen.main.bounds.size.width)
        
        // 建立一個 UIImageView
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: w/3 - 10.0, height: w/3 - 10.0))
        self.addSubview(imageView)
        
//        //建立一個 UIButton
//        button = UIButton(frame: CGRect(x: 0, y: 0, width: w/5 - 10.0, height: w/5 - 10.0))
//        self.addSubview(imageView)
        
        
        // 建立一個 UILabel
        titleLabel = UILabel(frame:CGRect(x: 0, y: 0, width: w/5 - 10.0, height: w/5 - 10.0))
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
