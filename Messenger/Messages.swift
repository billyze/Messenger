//
//  Messages.swift
//  Messenger
//
//  Created by Field Employee on 11/14/20.
//

import Foundation

struct messages: Codable {
    //var date: text
    var message: String
    var userReceiving: String
    var userSending: String
}

struct text: Codable {
    
}

class message {
    let message: String
    let userReceiving: String
    let userSending: String
    
    init(message: String, receiver: String, sender: String)
    {
        self.message = message
        self.userReceiving = receiver
        self.userSending = sender
    }
}
