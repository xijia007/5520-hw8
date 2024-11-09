//
//  User.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/7/24.
//

import Foundation
import FirebaseAuth

struct User: Codable {
    var id: String           // Firebase UID
    var name: String          // Display name of the user
    var email: String         // Email of the user
    
    init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    // Helper initializer for cases where the UID is known, but displayName and email are optional
    init?(firebaseUser: FirebaseAuth.User) {
        guard let email = firebaseUser.email else {
            return nil
        }
        
        self.id = firebaseUser.uid
        self.name = firebaseUser.displayName ?? "Unknown"  // Use displayName or fallback
        self.email = email
    }
}
