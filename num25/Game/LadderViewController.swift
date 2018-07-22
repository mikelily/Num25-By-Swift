//
//  LadderViewController.swift
//  num25
//
//  Created by 蒼月喵 on 2018/7/17.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import UIKit
import Firebase

class LadderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var scores: [Int] = []
    var names: [String] = []
    var timeStamps: [Int] = []
    var uids: [String] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "LadderCell", bundle: nil), forCellReuseIdentifier: "Lcell")
        
        let fbdb = Firestore.firestore()
        let settings = fbdb.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fbdb.settings = settings
        
        let ref = fbdb.collection("scores").order(by: "score").limit(to: 10)
        
        ref.addSnapshotListener { (doc, err) in
            self.scores = []
            self.names = []
            self.timeStamps = []
            self.uids = []
            
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
                    if let uid = document.data()["userID"] as? String{
                        self.uids.append(uid)
                    }
                    if let name = document.data()["name"] as? String{
                        self.names.append(name)
                    }
                    
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.scores.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Lcell", for: indexPath) as! LadderCell
        
        cell.cellScoreLabel.text = String(scores[indexPath.row])
        cell.cellNameLabel.text = names[indexPath.row]
        cell.cellUidLabel.text = uids[indexPath.row]
        
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.green
        }else{
            cell.backgroundColor = UIColor.yellow
        }
        
        
        let timeInterval:TimeInterval = TimeInterval(timeStamps[indexPath.row])
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        cell.cellTimeLabel.text = dformatter.string(from: date)
        return cell
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
