//
//  VsPlayDelegate.swift
//  num25
//
//  Created by 蒼月喵 on 2018/7/15.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import Foundation

protocol VsPlayDelegate:class {
    func addNextNum(_ nextNum: Int)
    func sendMsg(_ Msg: Int)
    func gameEnd()
    func playAgain()
    
}
