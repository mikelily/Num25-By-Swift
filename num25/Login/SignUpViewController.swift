//
//  SignUpViewController.swift
//  num25
//
//  Created by 蒼月喵 on 2018/7/10.
//  Copyright © 2018年 蒼月喵. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        if emailTextField.text == "" || nameTextField.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter all Field", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("註冊成功")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    let fbdb = Firestore.firestore()
                    let settings = fbdb.settings
                    settings.areTimestampsInSnapshotsEnabled = true
                    fbdb.settings = settings
                    
                    fbdb.collection("userState").document(Auth.auth().currentUser!.uid).setData([
                        "name": self.nameTextField.text!,
                        "games": 0,
                        "win": 0,
                        "lose":0
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameTabBarView")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
