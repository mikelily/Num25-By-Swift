//
//  AchvViewController.swift
//  num25
//
//  Created by 蒼月喵 on 2018/7/17.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import UIKit
import Firebase

class AchvViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var avgScoreLabel: UILabel!
    @IBOutlet weak var winningStreakLabel: UILabel!
    @IBOutlet weak var gamesLabel: UILabel!
    
    @IBOutlet weak var loseGames: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let fbdb = Firestore.firestore()
        let settings = fbdb.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fbdb.settings = settings
        
        let docRef = fbdb.collection("userState").document(Auth.auth().currentUser!.uid)
        docRef.addSnapshotListener { (document, erroe) in
            if let document = document, document.exists {
                if let name = document.data()!["name"] as? String{
                    print("name : \(name)")
                    self.nameLabel.text = name
                }
                
                let uid = Auth.auth().currentUser!.uid
                print("uid : \(uid)")
                self.uidLabel.text = uid
                
                if let bestScore = document.data()!["bestScore"] as? Int{
                    print("Get best score : \(bestScore)")
                    self.bestScoreLabel.text = String(bestScore)
                }else{
                    print("Can't get best score")
                }
                
                if let avgScore = document.data()!["avgScore"] as? Int{
                    print("Get avg score : \(avgScore)")
                    self.avgScoreLabel.text = String(avgScore)
                }else{
                    print("Can't get avg score")
                }
                
                if let games = document.data()!["games"] as? Int{
                    self.gamesLabel.text = String(games)
                }
                
                if let win = document.data()!["win"] as? Int{
                    self.winningStreakLabel.text = String(win)
                }
                if let lose = document.data()!["lose"] as? Int{
                    self.loseGames.text = String(lose)
                }
            } else {
                print("Document does not exist")
            }
//            self.viewDidLoad()
        }
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
