//
//  ViewController.swift
//  num25
//
//  Created by 蒼月喵 on 2018/6/12.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import UIKit
import Firebase

class PlayViewController: UIViewController {
    var playTableVC: PlayTable?
    var stateViewVC: StateView?
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var StartBtn: UIButton!
    @IBOutlet weak var PassBtn: UIButton!
    var timerTest : Timer?
    var sec = 0
    var name: String = "UnKnown"
    
    @IBAction func Start(_ sender: Any) {
        StartBtn.isHidden = true
        stateViewVC?.passBtn.isEnabled = true
        stateViewVC?.restartBtn.isEnabled = true
        startTimer()
    }
    
    @objc func timerActionTest() {
        print(" timer condition \(String(describing: timerTest))")
    }
    func startTimer () {
        if timerTest == nil {
            timerTest =  Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
//                print("\(self.sec) 豪秒")
                self.sec = self.sec + 1
                if self.sec%100/10 == 0 {
                    self.stateViewVC?.timerLabel.text = "\(self.sec/100):0\(self.sec%100)"
                }else{
                    self.stateViewVC?.timerLabel.text = "\(self.sec/100):\(self.sec%100)"
                }
            }
        }
    }
    func passTimer () {
        if timerTest != nil {
            timerTest?.invalidate()
            timerTest = Timer()
        }
    }
    
    @IBAction func keepPlay(_ sender: Any) {
        PassBtn.isHidden = true
        startTimer()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        tabBar = tabBarController as! TabBarViewController
        
        PassBtn.isHidden = true
        stateViewVC?.passBtn.isEnabled = false
        stateViewVC?.restartBtn.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc1 = segue.destination as? PlayTable {
            playTableVC = vc1
            playTableVC?.delegate = self
        }
        if let vc2 = segue.destination as? StateView {
            stateViewVC = vc2
            stateViewVC?.delegate = self
        }
    }
}

extension PlayViewController: PlayDelegate {
    func addNextNum(_ nextNum: Int) {
        stateViewVC?.upNextNum(nextNum)
    }
    func passGame() {
        PassBtn.isHidden = false
        passTimer()
    }
    func restartGame() {
        playTableVC?.viewDidLoad()
        playTableVC?.nextNum = 1
        stateViewVC?.upNextNum(1)
        StartBtn.isHidden = false
        PassBtn.isHidden = true
        stateViewVC?.timerLabel.text = "0"
        sec = 0
        passTimer()
    }
    
    func updateFireBase(field:String, value:Int){
        let fbdb = Firestore.firestore()
        let settings = fbdb.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fbdb.settings = settings
        
        let ref = fbdb.collection("userState").document(Auth.auth().currentUser!.uid)
        
        // Set the "capital" field of the city 'DC'
        ref.updateData([
            "\(field)": value
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func gameEnd() {
        passTimer()
        stateViewVC?.passBtn.isEnabled = false
        
        //enter score to Firebase
        var ref: DocumentReference? = nil
        
        let fbdb = Firestore.firestore()
        let settings = fbdb.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fbdb.settings = settings
//        let 
        
        let docRef = fbdb.collection("userState").document(Auth.auth().currentUser!.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let name = document.data()!["name"] as? String{
                    self.name = name
                }
                if var avgScore = document.data()!["avgScore"] as? Int{
                    if let games = document.data()!["games"] as? Int{
                        avgScore = (avgScore * games + self.sec)/(games+1)
                        self.updateFireBase(field: "games", value: games + 1)
                        self.updateFireBase(field: "avgScore", value: avgScore)
                    }
                }else{
                    self.updateFireBase(field: "avgScore",value: self.sec)
                    self.updateFireBase(field: "games", value: 1)
                }
                if var avgScore = document.data()!["avgScore"] as? Int{
                    if let games = document.data()!["games"] as? Int{
                        avgScore = (avgScore * games + self.sec)/(games+1)
                        self.updateFireBase(field: "games", value: games + 1)
                        self.updateFireBase(field: "avgScore", value: avgScore)
                    }
                }else{
                    self.updateFireBase(field: "avgScore",value: self.sec)
                    self.updateFireBase(field: "games", value: 1)
                }
                if let bestScore = document.data()!["bestScore"] as? Int{
                    if bestScore > self.sec{
                        self.updateFireBase(field: "bestScore",value: self.sec)
                    }
                }else{
                    self.updateFireBase(field: "bestScore",value: self.sec)
                }
            }
            else {
                print("Document does not exist")
            }
        }
        
        let now:Date = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let time:Int = Int(timeInterval)
        ref = fbdb.collection("scores").addDocument(data: [
            "userID": Auth.auth().currentUser!.uid,
            "score": self.sec,
            "time": time,
            "name": self.name
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        
        }
    }

