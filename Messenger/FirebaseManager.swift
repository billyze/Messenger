//
//  FirebaseManager.swift
//  Messenger
//
//  Created by Field Employee on 11/13/20.
//

import Foundation
import Firebase

final class FirebaseManager {
    static var shared = FirebaseManager()
    public var email: String = ""
    public var safeEmail: String = ""
    public var password: String = ""
    let session: URLSession
    private init (session: URLSession = URLSession.shared)
    {
        self.session = session
    }
}

extension FirebaseManager {
    func login(email:String, password:String, completion: @escaping (String) -> ()){
        DispatchQueue.main.async {
            Auth.auth().signIn(withEmail: email, password: password) {
                (result, error) in
                if(error != nil){
                    print(error?.localizedDescription ?? "An unknown error occured")
                    completion("error")
                }
                else {
                    self.email = email
                    self.password = password
                    self.safeEmail = email.replacingOccurrences(of: ".", with: "-")
                    self.safeEmail = self.safeEmail.replacingOccurrences(of: "@", with: "-")
                    completion("success")
                }
            }
        }
    }
    
    func checkForUser(user: String, completion: @escaping (String) -> ()){
        var safeUser = user.replacingOccurrences(of: "@", with: "-")
        safeUser = safeUser.replacingOccurrences(of: ".", with: "-")
        DispatchQueue.main.async {
            let ref = Database.database().reference()
            ref.child("users").observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                let keys = value?.allKeys as? [String]
                if(keys!.contains(safeUser))
                {
                    completion(safeUser)
                }
                else{
                    completion("")
                }
            })
        }
    }
    
    func sendMessage(messageContainer: message){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.string(from: NSDate() as Date)
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("messages").child(date).setValue(["userSending": messageContainer.userSending, "userReceiving": messageContainer.userReceiving, "message": messageContainer.message])
    }
}
