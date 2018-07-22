//
//  VsTable.swift
//  num25
//
//  Created by 蒼月喵 on 2018/7/19.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import UIKit

class VsTable: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource   {
    weak var delegate: VsPlayDelegate?
    // 取得螢幕的尺寸
    var fullScreenSize :CGSize! = UIScreen.main.bounds.size
    //    var list = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
    var list = Array(1 ... 25)
    //    var list = 0 ..< 26
    var nextNum = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 設置底色
        self.view.backgroundColor = UIColor.white
        
        // 建立 UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        // 設置每一行的間距
        layout.minimumLineSpacing = 5
        
        //Random
        randomList()
        
        // 設置每個 cell 的尺寸
        layout.itemSize = CGSize(
            width: CGFloat(fullScreenSize.width)/5 - 10.0,
            height: CGFloat(fullScreenSize.width)/5 - 10.0)
        //        layout.itemSize = CGSize(
        //            width: CGFloat(fullScreenSize.width-20)/5,
        //            height: CGFloat(fullScreenSize.width-20)/5)
        
        // 建立 UICollectionView
        let myCollectionView = UICollectionView(frame:
            CGRect(x: 0, y: 0,
                   width: fullScreenSize.width,
                   height: fullScreenSize.width-20),
                                                collectionViewLayout: layout)
        
        // 註冊 cell 以供後續重複使用
        myCollectionView.register(PlayTableCell.self, forCellWithReuseIdentifier: "Cell")
        
        // 設置委任對象
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        // 加入畫面中
        self.view.addSubview(myCollectionView)
        
        let btnTest = UIButton(type: .system)
        btnTest.setTitle("Test", for: .normal)
        self.view.addSubview(btnTest)
        
        let labelTest = UILabel()
        labelTest.text = "test"
        self.view.addSubview(labelTest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 必須實作的方法：每一組有幾個 cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PlayTableCell
        
        
        // 設置 cell 內容 (即自定義元件裡 增加的圖片與文字元件)
        //        cell.titleLabel.text = "\(indexPath.item + 1)"
        cell.titleLabel.text = "\(list[indexPath.item])"
        cell.backgroundColor = UIColor.green
        
        return cell
    }
    
    func reDrawCell() -> UICollectionViewCell {
        let collectionView = UICollectionView()
        let indexPath = IndexPath()
        // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PlayTableCell
        
        
        // 設置 cell 內容 (即自定義元件裡 增加的圖片與文字元件)
        //        cell.titleLabel.text = "\(indexPath.item + 1)"
        cell.titleLabel.text = "\(list[indexPath.item])"
        cell.backgroundColor = UIColor.green
        
        return cell
    }
    
    // 有幾個 section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("你選擇了 \(list[indexPath.item]) 號")
        if list[indexPath.item] == nextNum {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.yellow
            if nextNum == 25 {
                delegate?.gameEnd()
                delegate?.sendMsg(99)
            }else {
                nextNum = nextNum + 1
                delegate?.addNextNum(nextNum)
                delegate?.sendMsg(nextNum)
            }
        } else {
            collectionView.shake()
        }
        //        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.yellow
    }
    
    func randomList() {
        print("random")
        var temp = 0
        var temp1 = 0
        var temp2 = 0
        for _ in 0 ... 30 {
            temp1 = Int(arc4random_uniform(25))
            temp2 = Int(arc4random_uniform(25))
            //    print("第\(i)次 temp1=\(temp1) temp2=\(temp2)")
            if temp1 != temp2 {
                //                print("\(list[temp1])跟\(list[temp2])change")
                temp = list[temp1]
                list[temp1] = list[temp2]
                list[temp2] = temp
            }
        }
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
