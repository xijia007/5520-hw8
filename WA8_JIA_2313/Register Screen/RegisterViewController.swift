////
////  RegisterViewController.swift
////  WA8_JIA_2313
////
////  Created by Xi Jia on 11/5/24.
////
//
//
//import UIKit
//import FirebaseAuth
//import FirebaseFirestore
//
//class RegisterViewController: UIViewController {
//    
//    let childProgressView = ProgressSpinnerViewController()
//
//    let registerView = RegisterView()
//    
//    override func loadView() {
//        view = registerView
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationController?.navigationBar.prefersLargeTitles = true
//        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
//        title = "Register"
//    }
//    
//    @objc func onRegisterTapped(){
//        let password = registerView.textFieldPassword.text
//        let repeatPassword = registerView.textFieldRepeatPassword.text
//
//        if password != repeatPassword {
//            showAlert(message: "Passwords do not match!")
//            return
//        }
//        //MARK: creating a new user on Firebase...
//        registerNewAccount()
//    }
//    
//    // func to show alert
//    func showAlert(message: String) {
//        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    
//}

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    let registerView = RegisterView()
    let childProgressView = ProgressSpinnerViewController()
    let registerFirebaseManager = RegisterFirebaseManager()
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
    }
    
    @objc func onRegisterTapped(){
        // Validate inputs
        guard let name = registerView.textFieldName.text,
              let email = registerView.textFieldEmail.text,
              let password = registerView.textFieldPassword.text,
              let repeatPassword = registerView.textFieldRepeatPassword.text,
              !name.isEmpty, !email.isEmpty, !password.isEmpty, !repeatPassword.isEmpty else {
            showAlert(message: "Please fill all fields!")
            return
        }
        
        // Validate the email format
        if !isValidEmail(email) {
            showAlert(message: "Please enter a valid email address.")
            return
        }
        
        // Check password length
        guard password.count >= 6 else {
            showAlert(message: "The password must be 6 characters long or more")
            return
        }
        
        // Check if passwords match
        guard password == repeatPassword else {
            showAlert(message: "Passwords do not match!")
            return
        }
        
        
        // Show progress indicator
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
        
        // Register user
        registerFirebaseManager.registerUser(name: name, email: email, password: password){ authResult in
            DispatchQueue.main.async {
                self.childProgressView.willMove(toParent: nil)
                self.childProgressView.view.removeFromSuperview()
                self.childProgressView.removeFromParent()
                
                if let authResult = authResult {
                    print("Registration successful for user: \(authResult.user.uid)")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlert(message: "The email address is already in use by another account.")
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
