//
//  Message.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/7/24.
//

import Foundation

struct Message: Codable {
    let senderName: String
    let senderEmail: String
    let body: String
    let receiverName: String
    let receiverEmail: String
    let dateAndTime: Double?
    
    init(senderName: String, senderEmail: String, body: String, receiverName: String, receiverEmail: String, dateAndTime: Double? = nil) {
        self.senderName = senderName
        self.senderEmail = senderEmail
        self.body = body
        self.receiverName = receiverName
        self.receiverEmail = receiverEmail
        self.dateAndTime = dateAndTime
    }
}
