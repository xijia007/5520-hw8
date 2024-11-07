////
////  RegisterFirebaseManager.swift
////  WA8_JIA_2313
////
////  Created by Xi Jia on 11/5/24.
////
//
//import Foundation
//import FirebaseAuth
//import FirebaseFirestore
//
//extension RegisterViewController{
//    
//    
//    
//    func registerNewAccount(){
//        //MARK: display the progress indicator...
//        showActivityIndicator()
//        //MARK: create a Firebase user with email and password...
//        if let name = registerView.textFieldName.text,
//           let email = registerView.textFieldEmail.text,
//           let password = registerView.textFieldRepeatPassword.text{
//            //Validations....
//            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
//                if error == nil{
//                    //MARK: the user creation is successful...
//                    self.setNameOfTheUserInFirebaseAuth(name: name)
//                }else{
//                    //MARK: there is a error creating the user...
////                    print(error)
//                }
//                guard let user = result?.user else{return}
//                
//                // User created successfully, now add to Firestore
//                self.addUserToFirestore(user: user, name: name)
//            })
//        }
//    }
//    
//    func addUserToFirestore(user: User, name: String) {
//        let db = Firestore.firestore()
//        let userRef = db.collection("users").document(user.uid)
//        
//        let userData: [String: Any] = [
//            "name": name,
//            "email": user.email ?? "",
//            "uid": user.uid
//        ]
//        
//        userRef.setData(userData) { [weak self] error in
//            guard let self = self else { return }
//            
//            if let error = error {
//                print("Error adding user to Firestore: \(error.localizedDescription)")
//            } else {
//                print("User successfully added to Firestore")
//                self.setNameOfTheUserInFirebaseAuth(name: name)
//            }
//            
//            self.hideActivityIndicator()
//            // Navigate to the next screen or perform any other action
//            // self.navigationController?.popViewController(animated: true)
//        }
//    }
//
//    
//    //MARK: We set the name of the user after we create the account...
//    func setNameOfTheUserInFirebaseAuth(name: String){
//        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//        changeRequest?.displayName = name
//        changeRequest?.commitChanges(completion: {(error) in
//            if error == nil{
//                //MARK: hide the progress indicator...
//                self.hideActivityIndicator()
//                //MARK: the profile update is successful...
//                self.navigationController?.popViewController(animated: true)
//            }else{
//                //MARK: there was an error updating the profile...
//                print("Error occured: \(String(describing: error))")
//            }
//        })
//    }
//    
//    
//}
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
