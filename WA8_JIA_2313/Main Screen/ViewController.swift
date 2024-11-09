//
//  ViewController.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/5/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    let database = Firestore.firestore()
    let mainScreen = MainScreenView()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser: FirebaseAuth.User?
    var chatTableViewManager: ChatTableViewManager!
    var chatFirebaseManager: ChatFirebaseManager!
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLeftBarButton()
        
        // Check if the user is signed in
        handleAuth = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            
            if let user = user {
                // User is signed in
                self.currentUser = user
                self.setupRightBarButton(isLoggedin: true)
                self.navigationItem.leftBarButtonItem?.isEnabled = true
                
                // Load user data and fetch all existing channels
                UserSessionManager.shared.loadUserData { success in
                    if success {
                        self.mainScreen.labelText.text = "Welcome \(UserSessionManager.shared.currentUser?.name ?? "User")!"
                        
                        // Refresh chat list for all existing channels for the signed-in user
                        if let currentUserUID = self.currentUser?.uid {
                            self.chatFirebaseManager.fetchAllExistingChannelsForUser(userId: currentUserUID) { chatList in
                                self.chatTableViewManager.chatList = chatList
                                self.mainScreen.tableViewChats.reloadData()
                            }
                        }
                    } else {
                        print("Failed to load user data.")
                        self.mainScreen.labelText.text = "Welcome!"
                    }
                }
                
            } else {
                // User is not signed in
                self.currentUser = nil
                self.mainScreen.labelText.text = "Please sign in to see the chats!"
                self.setupRightBarButton(isLoggedin: false)
                self.navigationItem.leftBarButtonItem?.isEnabled = false
                
                // Clear the chat list in the UI when the user is not signed in
                self.chatTableViewManager.chatList.removeAll()
                self.mainScreen.tableViewChats.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Chats"
        
        chatFirebaseManager = ChatFirebaseManager()
        
        // Initialize ChatTableViewManager to manage and display the list of chats
        setupTableView()
    }
    
    func setupTableView() {
        guard let navigationController = self.navigationController else {
            print("Navigation controller is missing.")
            return
        }
        
        chatTableViewManager = ChatTableViewManager(tableView: mainScreen.tableViewChats, navigationController: navigationController)
        mainScreen.tableViewChats.dataSource = chatTableViewManager
        mainScreen.tableViewChats.delegate = chatTableViewManager
    }
    
    func setupLeftBarButton() {
        let contactsButton = UIBarButtonItem(
            image: UIImage(systemName: "person.2"),
            style: .plain,
            target: self,
            action: #selector(contactsButtonTapped)
        )
        navigationItem.leftBarButtonItem = contactsButton
    }
    
    func fetchAllExistingChannelsForUser(userId: String, completion: @escaping ([ChatCell]) -> Void) {
        ChatFirebaseManager().fetchAllExistingChannelsForUser(userId: userId, completion: completion)
    }
    
    @objc func contactsButtonTapped() {
        let contactsListVC = ContactsViewController()
        navigationController?.pushViewController(contactsListVC, animated: true)
    }
    
    @objc func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully.")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    @objc func signInButtonTapped() {
        print("Navigate to Sign In Screen")
        // Implement navigation to sign-in screen if needed
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handle = handleAuth {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
