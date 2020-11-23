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
    
    override func viewWillAppear(_ animated: Bool) {
        userTxtField.text = ""
        passTxtField.text = ""
    }
    
    @IBAction func signUpBtnTap(_ sender: Any) {
        let alert = UIAlertController(title: "New User Registration", message: "Enter your information:", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Example@gmail.com"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { (textField) in
            textField.placeholder = "John"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Smith"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let username = alert?.textFields![0]
            let password = alert?.textFields![1]
            let firstName = alert?.textFields![2]
            let lastName = alert?.textFields![3]
            if(username!.text == "" || password!.text == "" || firstName!.text == "" || lastName!.text == "")
            {
                let errorAlert = UIAlertController(title: "Error", message: "Insufficient Information", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated:true)
            }
            else{
                FirebaseManager.shared.checkForUser(user: username?.text ?? ""){ newContact in
                    if(newContact == "")
                    {
                        //create user
                        FirebaseManager.shared.registerUser(username: username!.text!, password: password!.text!, firstName: firstName!.text!, lastName: lastName!.text!)
                        let successAlert =  UIAlertController(title: "Success!", message: "Registration was successful, please log in", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(successAlert, animated:true)
                    }
                    else{
                        //error
                        let errorAlert = UIAlertController(title: "Error", message: "User already exists", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(errorAlert, animated:true)
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
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
                    let errorAlert = UIAlertController(title: "Error", message: "Unable to log in with information entered", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated:true)
                }
            }
        }
    }
}

