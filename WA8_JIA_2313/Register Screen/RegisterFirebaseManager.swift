//
//  RegisterFirebaseManager.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/5/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterFirebaseManager{
    let db = Firestore.firestore()
    
    func checkExistingUser(email: String, name: String, completion: @escaping (Bool, String) -> Void) {
        // Check if email exists
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            if methods != nil {
                completion(true, "Email")
                return
            }
            
            // Check if name exists
            self.db.collection("users").whereField("name", isEqualTo: name).getDocuments { (snapshot, error) in
                if let documents = snapshot?.documents, !documents.isEmpty {
                    completion(true, "Name")
                } else {
                    completion(false, "")
                }
            }
        }
    }
    
    func registerUser(name: String, email: String, password: String, completion: @escaping (AuthDataResult?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let user = authResult?.user else {
                completion(nil)
                return
            }
            
            let userData: [String: Any] = [
                "name": name,
                "email": email,
                "uid": user.uid
            ]
            
            self.db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    completion(authResult)
                }
            }
        }
    }
}
