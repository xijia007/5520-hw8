//
//  Contact.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/5/24.
//

import Foundation


struct Contact: Codable{
   
    var name: String
    var email: String
    var uid: String

    init(name: String, email: String, uid: String) {
        self.name = name
        self.email = email
        self.uid = uid

    }
}

