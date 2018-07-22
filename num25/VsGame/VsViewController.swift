//
//  VsViewController.swift
//  num25
//
//  Created by 蒼月喵 on 2018/7/19.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import UIKit
import Firebase

class VsViewController: UIViewController {
    
    var iStream: InputStream? = nil
    var oStream: OutputStream? = nil
    
    var playTableVC: VsTable?
    var stateViewVC: VsStateView?
    
    var timerTest : Timer?
    var sec = 0
    var name: String = "UnKnown"
    @IBOutlet weak var wLabel: UILabel!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateViewVC?.playAgainBtn.isHidden = true

        // Do any additional setup after loading the view.
        let _ = Stream.getStreamsToHost(withName: "localhost", port: 5003, inputStream: &iStream, outputStream: &oStream)
        
        iStream?.open()
        oStream?.open()
        
        DispatchQueue.global().async {
            self.receiveData(available: { (string) in
                if string == "start"{
                    DispatchQueue.main.async {
                        self.wLabel.text = "5"
                    }
                    sleep(1)
                    DispatchQueue.main.async {
                        self.wLabel.text = "4"
                    }
                    sleep(1)
                    DispatchQueue.main.async {
                        self.wLabel.text = "3"
                    }
                    sleep(1)
                    DispatchQueue.main.async {
                        self.wLabel.text = "2"
                    }
                    sleep(1)
                    DispatchQueue.main.async {
                        //                        self.testBtn.titleLabel?.text = "1"
                        self.wLabel.text = "1"
                    }
                    sleep(1)
                    DispatchQueue.main.async {
                        self.wLabel.isHidden = true
                        self.startTimer()
                    }
                }else if string == "99"{
                    self.loseGame()
                }else{
                    DispatchQueue.main.async {
//                        self.wLabel.text = string
                        self.stateViewVC?.oppTimerLabel.text = string
                    }
                }
            })
        }
    }
    
    func receiveData(available: (_ string: String?) -> Void) {
        var buf = Array(repeating: UInt8(0), count: 1024)
        
        while true {
            if let n = iStream?.read(&buf, maxLength: 1024) {
                let data = Data(bytes: buf, count: n)
                let string = String(data: data, encoding: .utf8)
                available(string)
            }
        }
    }
    
    func send(_ string: String) {
        var buf = Array(repeating: UInt8(0), count: 1024)
        let data = string.data(using: .utf8)!
        
        data.copyBytes(to: &buf, count: data.count)
        oStream?.write(buf, maxLength: data.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc1 = segue.destination as? VsTable {
            playTableVC = vc1
            playTableVC?.delegate = self 
        }
        if let vc2 = segue.destination as? VsStateView {
            stateViewVC = vc2
            stateViewVC?.delegate = self
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

extension VsViewController: VsPlayDelegate {
    func loseGame(){
        passTimer()
        DispatchQueue.main.async {
            self.wLabel.text = "Lose"
            self.wLabel.isHidden = false
            self.stateViewVC?.playAgainBtn.isHidden = false
        }
        send("bye")
//        iStream?.close()
//        oStream?.close()
        
        //enter score to Firebase
        
        let fbdb = Firestore.firestore()
        let settings = fbdb.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fbdb.settings = settings
        
        let docRef = fbdb.collection("userState").document(Auth.auth().currentUser!.uid)
        var inNum: Int = 0
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let lose = document.data()!["lose"] as? Int{
                    inNum = lose + 1
                    self.updateFireBase(field: "lose", value:inNum)
                }
            }else {
                print("Document does not exist")
            }
        }
        
    }
    func playAgain(){
//        iStream?.close()
//        oStream?.close()
        
//        self.viewDidLoad()
        playTableVC?.viewDidLoad()
        playTableVC?.nextNum = 1
        stateViewVC?.upNextNum(1)
        stateViewVC?.timerLabel.text = "0"
        stateViewVC?.playAgainBtn.isHidden = true
        sec = 0
        passTimer()
        self.wLabel.text = "waitting"
    }
    
    func sendMsg(_ Msg: Int) {
        print(Msg)
        send(String(Msg))
    }
    func addNextNum(_ nextNum: Int) {
        stateViewVC?.upNextNum(nextNum)
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
        sendMsg(99)
        wLabel.text = "Win"
        wLabel.isHidden = false
        send("bye")
        
        iStream?.close()
        oStream?.close()
        stateViewVC?.playAgainBtn.isHidden = false
        
        //enter score to Firebase
        
        let fbdb = Firestore.firestore()
        let settings = fbdb.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fbdb.settings = settings

        let docRef = fbdb.collection("userState").document(Auth.auth().currentUser!.uid)
        var inNum: Int = 0
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let win = document.data()!["win"] as? Int{
                    inNum = win + 1
                    self.updateFireBase(field: "win", value: inNum)
                }
            }else {
                print("Document does not exist")
            }
        }
        
    }
}
