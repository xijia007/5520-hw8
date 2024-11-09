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
    var id: String

    init(name: String, email: String, id: String) {
        self.name = name
        self.email = email
        self.id = id

    }
}

