//
//  TableViewController.swift
//  Messenger
//
//  Created by Field Employee on 11/14/20.
//

import UIKit
import Firebase

class userListTableViewController: UITableViewController {

    var userList: [String] = []
    var user: String = ""
    var email: String = ""
    var pass: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.user = FirebaseManager.shared.safeEmail
        self.email = FirebaseManager.shared.email
        self.pass = FirebaseManager.shared.password
        
        FirebaseManager.shared.login(email: self.email, password: self.pass){ result in
            DispatchQueue.main.async {
                let ref = Database.database().reference()
                ref.child("messages").observeSingleEvent(of: .value, with: { snapshot in
                    let value = snapshot.value as? NSDictionary
                    value?.forEach{
                        let val = $0.value as? NSDictionary
                        if(val?["userSending"] as! String == self.user)
                        {
                            if(!(self.userList.contains(val!["userReceiving"] as! String)))
                            {
                                self.userList.append(val?["userReceiving"] as! String)
                            }
                        }
                        else if(val?["userReceiving"] as! String == self.user)
                        {
                            if(!(self.userList.contains(val!["userSending"] as! String)))
                            {
                                self.userList.append(val?["userSending"] as! String)
                            }
                        }
                    }
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((userList.count) + 1)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row < userList.count){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userList", for: indexPath) as? userListTableViewCell else {return UITableViewCell()}
            cell.userName.text = "\(userList[indexPath.row])"
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newUser", for: indexPath) as? newUserTableViewCell else {return UITableViewCell()}
            cell.newUserBtn.setTitle("Add New Contact", for: .normal)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row < userList.count){
            let vc = self.storyboard?.instantiateViewController(identifier: "messageVC") as! messagesViewController
            vc.modalPresentationStyle = .fullScreen
            vc.contact = userList[indexPath.row]
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func addNewUser(_ sender: Any) {
        let alert = UIAlertController(title: "New Contact", message: "Enter new contact's username:", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "Example@gmail.com"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            FirebaseManager.shared.checkForUser(user: textField?.text ?? ""){ newContact in
                if(newContact != "")
                {
                    //go to messages with user
                    let vc = self.storyboard?.instantiateViewController(identifier: "messageVC") as! messagesViewController
                    vc.modalPresentationStyle = .fullScreen
                    vc.contact = newContact
                    self.present(vc, animated: true)
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
