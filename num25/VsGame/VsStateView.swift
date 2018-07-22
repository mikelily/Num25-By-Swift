//
//  VsStateView.swift
//  num25
//
//  Created by 蒼月喵 on 2018/7/15.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import UIKit

class VsStateView: UIViewController {
    weak var delegate: VsPlayDelegate?
    @IBOutlet weak var nextNumLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var oppTimerLabel: UILabel!
    @IBOutlet weak var playAgainBtn: UIButton!
    
    @IBAction func playAgainBtnAction(_ sender: Any) {
        delegate?.playAgain()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func upNextNum(_ nextNum: Int) {
        nextNumLabel.text = String(nextNum)
    }

}
