//
//  FirebaseScoreTableViewController.swift
//  num25
//
//  Created by 蒼月喵 on 2018/7/10.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import UIKit
import Firebase

class FirebaseScoreTableViewController: UITableViewController {
    
    var scores: [Int] = []
    var names: [String] = []
    var games: [Int] = []
    var avgScores: [Int] = []
    var timeStamps: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fbdb = Firestore.firestore()
        let settings = fbdb.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fbdb.settings = settings
        
        let ref = fbdb.collection("scores").order(by: "score").limit(to: 10)
        
        ref.addSnapshotListener { (doc, err) in
            self.scores = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in doc!.documents {
                    if let score = document.data()["score"] as? Int{
                        self.scores.append(score)
                    }
                    if let time = document.data()["time"] as? Int{
                        self.timeStamps.append(time)
                    }
                    if let uid = document.data()["uid"] as? String{
                        self.names.append(self.getName(uid: uid))
                        self.avgScores.append(self.getStateIntValue(uid: uid, key: "avgScore"))
                        self.games.append(self.getStateIntValue(uid: uid, key: "games"))
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func getStateIntValue(uid: String,key: String) -> Int {
        let fbdb = Firestore.firestore()
        let settings = fbdb.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fbdb.settings = settings
        var forReturn: Int = 0
        let docRef = fbdb.collection("userState").document(Auth.auth().currentUser!.uid)
        docRef.addSnapshotListener { (document, erroe) in
            if let document = document, document.exists {
                
                if key == "games"{
                    if let games = document.data()!["games"] as? Int{
                        forReturn = games
                    }
                }
                if key == "avgScore"{
                    if let avgScore = document.data()!["avgScore"] as? Int{
                        forReturn = avgScore
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
        
        return forReturn
    }
    
    func getName(uid: String) -> String {
        let fbdb = Firestore.firestore()
        let settings = fbdb.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fbdb.settings = settings
        
        var forReturn: String = ""
        let docRef = fbdb.collection("userState").document(Auth.auth().currentUser!.uid)
        docRef.addSnapshotListener { (document, erroe) in
            if let document = document, document.exists {
                if let name = document.data()!["name"] as? String{
                    forReturn = name
                }
                
            } else {
                print("Document does not exist")
            }
        }
        return forReturn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.scores.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LadderCell", for: indexPath) as! LadderCell
        
        cell.cellScoreLabel.text = String(scores[indexPath.row])
        cell.cellNameLabel.text = names[indexPath.row]
        
        let timeInterval:TimeInterval = TimeInterval(timeStamps[indexPath.row])
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        cell.cellTimeLabel.text = dformatter.string(from: date)
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
