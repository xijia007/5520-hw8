//
//  RegisterViewController.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/5/24.
//

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
                    
                    // Load the newly registered user's data into UserSessionManager
                    UserSessionManager.shared.loadUserData { success in
                        if success {
                            print("User data loaded successfully after registration.")
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            print("Failed to load user data after registration.")
                            self.showAlert(message: "Error loading user data.")
                        }
                    }
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
