//
//  ViewController.swift
//  Messenger
//
//  Created by Field Employee on 11/12/20.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var userTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInBtnTap(_ sender: Any) {
        //email: "billyzedan123@gmail.com", password: "abcd1234"
        let email = userTxtField.text
        let password = passTxtField.text
        FirebaseManager.shared.login(email: email ?? "", password: password ?? "") {result in
            DispatchQueue.main.async {
                if(result == "success")
                {
                    let vc = self.storyboard?.instantiateViewController(identifier: "userList") as! userListTableViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
                else{
                    print("ohoh")
                }
            }
        }
        
        
    }
    

}

