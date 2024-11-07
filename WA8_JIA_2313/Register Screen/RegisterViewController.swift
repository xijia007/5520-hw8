//
//  RegisterViewController.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/5/24.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    let childProgressView = ProgressSpinnerViewController()

    let registerView = RegisterView()
    
    override func loadView() {
        view = registerView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        title = "Register"
    }
    
    @objc func onRegisterTapped(){
        let password = registerView.textFieldPassword.text
        let repeatPassword = registerView.textFieldRepeatPassword.text

        if password != repeatPassword {
            showAlert(message: "Passwords do not match!")
            return
        }
        //MARK: creating a new user on Firebase...
        registerNewAccount()
    }
    
    // func to show alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
