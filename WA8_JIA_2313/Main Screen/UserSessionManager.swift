//
//  UserSessionManager.swift
//  WA8_JIA_2313
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserSessionManager {
    
    static let shared = UserSessionManager()  // Singleton instance
    
    var currentUser: User?  // Store the user information
    
    private init() {}  // Private initializer to enforce singleton pattern
    
    func loadUserData(completion: @escaping (Bool) -> Void) {
        guard let firebaseUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            completion(false)
            return
        }
        
        print("Attempting to load data for user with UID: \(firebaseUser.uid)")
        
        if let displayName = firebaseUser.displayName, !displayName.isEmpty {
            // User data is available in Authentication
            self.currentUser = User(id: firebaseUser.uid, name: displayName, email: firebaseUser.email ?? "")
            
            // Log the user's information
            print("User data found in FirebaseAuth:")
            print("User ID: \(firebaseUser.uid)")
            print("Display Name: \(displayName)")
            print("Email: \(firebaseUser.email ?? "No email")")
            
            completion(true)
        } else {
            // Fetch display name and other details from Firestore if not set in Authentication
            print("User display name not available in FirebaseAuth, fetching from Firestore...")
            
            Firestore.firestore().collection("users").document(firebaseUser.uid).getDocument { document, error in
                if let document = document, document.exists {
                    do {
                        self.currentUser = try document.data(as: User.self)
                        
                        // Log the user's information from Firestore
                        if let currentUser = self.currentUser {
                            print("User data retrieved from Firestore:")
                            print("User ID: \(currentUser.id)")
                            print("Display Name: \(currentUser.name)")
                            print("Email: \(currentUser.email)")
                        }
                        
                        completion(true)
                    } catch {
                        print("Error decoding user from Firestore: \(error)")
                        completion(false)
                    }
                } else {
                    print("User document does not exist in Firestore or there was an error: \(error?.localizedDescription ?? "No error")")
                    completion(false)
                }
            }
        }
    }
}
