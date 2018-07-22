//
//  StateView.swift
//  num25
//
//  Created by 蒼月喵 on 2018/6/15.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import UIKit

class StateView: UIViewController {
    weak var delegate: PlayDelegate?

 
    @IBOutlet weak var nextNumLabel: UILabel!
    @IBOutlet weak var passBtn: UIButton!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func passBtnAction(_ sender: Any) {
        delegate?.passGame()
    }
    @IBAction func restartBtnAction(_ sender: Any) {
        delegate?.restartGame()
        passBtn.isEnabled = false
        restartBtn.isEnabled = false
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
