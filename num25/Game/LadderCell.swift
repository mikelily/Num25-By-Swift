//
//  LadderCell.swift
//  num25
//
//  Created by 蒼月喵 on 2018/7/17.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import UIKit

class LadderCell: UITableViewCell {

    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellScoreLabel: UILabel!
    @IBOutlet weak var cellTimeLabel: UILabel!
    @IBOutlet weak var cellUidLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
