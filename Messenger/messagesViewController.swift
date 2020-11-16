//
//  messagesViewController.swift
//  Messenger
//
//  Created by Field Employee on 11/14/20.
//

import UIKit
import Firebase

class messagesViewController: UIViewController {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTxtFld: UITextField!
    @IBAction func backBtnTap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "userList") as! userListTableViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    var email: String = FirebaseManager.shared.email
    var user: String = FirebaseManager.shared.safeEmail
    var pass: String = FirebaseManager.shared.password
    var contact: String = ""
    var messageArr: [message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //load messages
        loadMessages()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if(self.messageTxtFld.text != "")
        {
            //send message
            let messageContainer = message(message: self.messageTxtFld.text!, receiver: self.user, sender: self.contact)
            FirebaseManager.shared.sendMessage(messageContainer: messageContainer)
            self.messageTxtFld.text = ""
            //reload messages
            loadMessages()
        }
    }
}

extension messagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as? messagesTableViewCell else {return UITableViewCell()}
        if(indexPath.row < messageArr.count)
        {
            cell.messageLabel.text = messageArr[indexPath.row].message
            cell.messageLabel.sizeToFit()
            cell.bounds.size.height = cell.messageLabel.bounds.size.height
            if(messageArr[indexPath.row].userReceiving == self.user)
            {
                //textField to left
            }
            else
            {
                //textField to right
            }
        }
        return cell
    }
    
    func loadMessages() {
        FirebaseManager.shared.login(email: self.email, password: self.pass){ result in
            DispatchQueue.main.async {
                self.messageArr = []
                let ref = Database.database().reference()
                ref.child("messages").observeSingleEvent(of: .value, with: { snapshot in
                    let value = snapshot.value as? NSDictionary
                    value?.forEach{
                        let val = $0.value as? NSDictionary
                        if(val?["userSending"] as! String == self.user)
                        {
                            if(val?["userReceiving"] as! String == self.contact)
                            {
                                let messageText = (val?["userSending"] as? String ?? "") + ":" + (val?["message"] as? String ?? "")
                                let userReceiving = val?["userReceiving"] as? String ?? ""
                                let userSending = val?["userSending"] as? String ?? ""
                                let messageDetails = message(message: messageText, receiver: userReceiving, sender: userSending)
                                self.messageArr.append(messageDetails)
                            }
                        }
                        else if(val?["userReceiving"] as! String == self.user)
                        {
                            if(val?["userSending"] as! String == self.contact)
                            {
                                let messageText = val?["message"] as? String ?? ""
                                let userReceiving = val?["userReceiving"] as? String ?? ""
                                let userSending = val?["userSending"] as? String ?? ""
                                let messageDetails = message(message: messageText, receiver: userReceiving, sender: userSending)
                                self.messageArr.append(messageDetails)
                            }
                        }
                    }
                    self.messageTableView.reloadData()
                })
            }
        }
    }
}


