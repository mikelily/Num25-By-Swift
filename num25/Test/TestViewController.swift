//
//  TestViewController.swift
//  num25
//
//  Created by 蒼月喵 on 2018/7/10.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import UIKit
import Firebase

class TestViewController: UIViewController {

    var iStream: InputStream? = nil
    var oStream: OutputStream? = nil
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var labelField: UILabel!
    @IBOutlet weak var testBtn: UIButton!
    @IBAction func connBtn(_ sender: Any) {
        let _ = Stream.getStreamsToHost(withName: "localhost", port: 5002, inputStream: &iStream, outputStream: &oStream)
        
        iStream?.open()
        oStream?.open()
        
        DispatchQueue.global().async {
            self.receiveData(available: { (string) in
                if string == "start"{
                    DispatchQueue.main.async {
                        self.labelField.text = "5"
                    }
                    sleep(1)
                    DispatchQueue.main.async {
                        self.labelField.text = "4"
                    }
                    sleep(1)
                    DispatchQueue.main.async {
                        self.labelField.text = "3"
                    }
                    sleep(1)
                    DispatchQueue.main.async {
                        self.labelField.text = "2"
                    }
                    sleep(1)
                    DispatchQueue.main.async {
                        //                        self.testBtn.titleLabel?.text = "1"
                        self.labelField.text = "1"
                    }
                    sleep(1)
                    DispatchQueue.main.async {
                        self.labelField.isHidden = true
                    }
                }else{
                    DispatchQueue.main.async {
                        self.labelField.text = string
                    }
                }
            })
        }
    }
    
    
    @IBAction func socketBtn(_ sender: Any) {
        if let text = textField.text {
            send(text)
        }
    }
    fileprivate struct City {
        
        let name: String
        let state: String?
        let country: String?
        let capital: Bool?
        let population: Int64?
        
        init?(dictionary: [String: Any]) {
            guard let name = dictionary["name"] as? String else { return nil }
            self.name = name
            
            self.state = dictionary["state"] as? String
            self.country = dictionary["country"] as? String
            self.capital = dictionary["capital"] as? Bool
            self.population = dictionary["population"] as? Int64
        }
        
    }

    
    @IBAction func testBtn(_ sender: Any) {
//        print("Button clicked")
        let fbdb = Firestore.firestore()
        let settings = fbdb.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fbdb.settings = settings
        
//        fbdb.collection(Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                print("No error when open doc")
//                for document in querySnapshot!.documents {
//                    print("\(document.data())")
////                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
        
        let docRef = fbdb.collection("userState").document(Auth.auth().currentUser!.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //                print("Document data: \(dataDescription)")
//                if let
                if let games = document.data()!["games"]{
                    print("games = \(games)")
                }
                if let winS = document.data()!["winningStreak"]{
                    print("winningStreak = \(winS)")
                }
                
                var score = 2769
                
                if let bestScore = document.data()!["bestScore"] as? Int{
                    print("Get best score : \(bestScore)")
                    if bestScore < score{
                        score = bestScore
                    }else{
                        self.updateFireBase(field: "bestScore",value: score)
                    }
                }else{
                    print("Can't get best score")
                    self.updateFireBase(field: "bestScore",value: score)
//                    var bestScore = 9999
                }
                
                print("New Best score : \(score)")
//                if bestScore > score {
//                    bestScore = score
//                }
            } else {
                print("Document does not exist")
            }
        }
        
        
        fbdb.collection(Auth.auth().currentUser!.uid).order(by: "score").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("No error when open doc")
                for document in querySnapshot!.documents {
                    if let ss = document.data()["score"]{
                        print(ss)
                    }
                    if let tt = document.data()["time"]{
                        print(tt)
                    }
//                    print("\(String(describing: document.data()["score"]))")
                    //                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
//            .collection("RmvBGJtE5oNDMS5AYv7aFrMFoP93")
//            .orderBy("score", "asc")
        
//        let docRef = fbdb.collection("cities").document("SF")
//
//        // Force the SDK to fetch the document from the cache. Could also specify
//        // FirestoreSource.server or FirestoreSource.default.
//        docRef.getDocument(source: .cache) { (document, error) in
//            if let document = document {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Cached document data: \(dataDescription)")
//                print(type(of: dataDescription))
//            } else {
//                print("Document does not exist in cache")
//            }
//        }

        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
