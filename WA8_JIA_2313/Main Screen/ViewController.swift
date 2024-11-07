////
////  ViewController.swift
////  WA8_JIA_2313
////
////  Created by Xi Jia on 11/5/24.
////
//
//import UIKit
//import FirebaseAuth
//import FirebaseFirestore
//
//class ViewController: UIViewController {
//    
//    let database = Firestore.firestore()
//
//    let mainScreen = MainScreenView()
//    
//    var handleAuth: AuthStateDidChangeListenerHandle?
//    var currentUser:FirebaseAuth.User?
//    
//    // add an array of chats for the table view.
//    var chatsList = [ChatCell]()
//    
//    
//    override func loadView() {
//        view = mainScreen
//    }
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // Set up the left bar button
//        setupLeftBarButton()
//        
//        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
//        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
//            if user == nil{
//                //MARK: not signed in...
//                self.currentUser = nil
//                self.mainScreen.labelText.text = "Please sign in to see the chats!"
//                self.mainScreen.floatingButtonAddChat.isEnabled = false
//                self.mainScreen.floatingButtonAddChat.isHidden = true
//                
//            //MARK: Reset tableView...
//                self.chatsList.removeAll()
//                self.mainScreen.tableViewChats.reloadData()
//                //MARK: Sign in bar button...
//                self.setupRightBarButton(isLoggedin: false)
//                
//                // Disable the contacts button when not logged in
//                self.navigationItem.leftBarButtonItem?.isEnabled = false
//            }else{
//                //MARK: the user is signed in...
//                self.currentUser = user
//                self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
//                self.mainScreen.floatingButtonAddChat.isEnabled = true
//                self.mainScreen.floatingButtonAddChat.isHidden = false
//                //MARK: Logout bar button...
//                self.setupRightBarButton(isLoggedin: true)
//                
//                // Enable the contacts button when logged in
//                self.navigationItem.leftBarButtonItem?.isEnabled = true
//            }
//        }
//    }
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        title = "My Chats"
//        
//        //MARK: Make the titles look large...
////        navigationController?.navigationBar.prefersLargeTitles = true
//        
//        //MARK: patching table view delegate and data source...
//        mainScreen.tableViewChats.delegate = self
//        mainScreen.tableViewChats.dataSource = self
//        
//        //MARK: removing the separator line...
//        mainScreen.tableViewChats.separatorStyle = .none
//        
//        //MARK: Put the floating button above all the views...
//        view.bringSubviewToFront(mainScreen.floatingButtonAddChat)
//
//        //MARK: tapping the floating add chat button...
//        mainScreen.floatingButtonAddChat.addTarget(self, action: #selector(addChatButtonTapped), for: .touchUpInside)
//        
//        // In your app's main view controller or wherever you want to show the contacts
//        let contactsViewController = ContactsViewController()
//        navigationController?.pushViewController(contactsViewController, animated: true)
//    
//    
//    }
//    
//    func setupLeftBarButton() {
//        let contactsButton = UIBarButtonItem(
//            image: UIImage(systemName: "person.2"),
//            style: .plain,
//            target: self,
//            action: #selector(contactsButtonTapped)
//        )
//        navigationItem.leftBarButtonItem = contactsButton
//    }
//    
//    @objc func contactsButtonTapped() {
//        let contactsListVC = ContactsViewController() // Replace with your actual contacts list view controller
//        navigationController?.pushViewController(contactsListVC, animated: true)
//    }
//    
//    
//
//    // populate the Add Contact screen.
//    @objc func addChatButtonTapped(){
//    //           let addContactController = AddContactViewController()
//    //           addContactController.currentUser = self.currentUser
//    //           navigationController?.pushViewController(addContactController, animated: true)
//       }
//
//
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        Auth.auth().removeStateDidChangeListener(handleAuth!)
//    }
//
//
//}
//

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
    var currentUser:FirebaseAuth.User?
    

    var chatsList = [ChatCell]()
    
    // add an array of chats for the table view.
    var chatChannels = [ChatChannel]()
    
    var chatTableViewManager: ChatTableViewManager!
    
    
    override func loadView() {
        view = mainScreen
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set up the left bar button
        setupLeftBarButton()
        
        chatTableViewManager.fetchChatList()
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                //MARK: not signed in...
                self.currentUser = nil
                self.mainScreen.labelText.text = "Please sign in to see the chats!"
                self.mainScreen.floatingButtonAddChat.isEnabled = false
                self.mainScreen.floatingButtonAddChat.isHidden = true
                
            //MARK: Reset tableView...
                self.chatsList.removeAll()
                self.mainScreen.tableViewChats.reloadData()
                //MARK: Sign in bar button...
                self.setupRightBarButton(isLoggedin: false)
                
                // Disable the contacts button when not logged in
                self.navigationItem.leftBarButtonItem?.isEnabled = false
            }else{
                //MARK: the user is signed in...
                self.currentUser = user
                self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
                self.mainScreen.floatingButtonAddChat.isEnabled = true
                self.mainScreen.floatingButtonAddChat.isHidden = false
                //MARK: Logout bar button...
                self.setupRightBarButton(isLoggedin: true)
                
                // Enable the contacts button when logged in
                self.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Chats"
        
        //MARK: Make the titles look large...
//        navigationController?.navigationBar.prefersLargeTitles = true
        
//        //MARK: patching table view delegate and data source...
//        mainScreen.tableViewChats.delegate = self
//        mainScreen.tableViewChats.dataSource = self
//        
//        //MARK: removing the separator line...
//        mainScreen.tableViewChats.separatorStyle = .none
//        chatTableViewManager = ChatTableViewManager(tableView: mainScreen.tableViewChats)
        
        //MARK: Put the floating button above all the views...
        view.bringSubviewToFront(mainScreen.floatingButtonAddChat)
        
        setupTableView()

        //MARK: tapping the floating add chat button...
        mainScreen.floatingButtonAddChat.addTarget(self, action: #selector(addChatButtonTapped), for: .touchUpInside)
        
        // In your app's main view controller or wherever you want to show the contacts
//        let contactsViewController = ContactsViewController()
//        navigationController?.pushViewController(contactsViewController, animated: true)
    
    
    }
    
    func setupTableView() {
            chatTableViewManager = ChatTableViewManager(tableView: mainScreen.tableViewChats)
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
    
    @objc func contactsButtonTapped() {
        let contactsListVC = ContactsViewController() // Replace with your actual contacts list view controller
        navigationController?.pushViewController(contactsListVC, animated: true)
    }
    
    

    // populate the Add Contact screen.
    @objc func addChatButtonTapped(){
    //           let addContactController = AddContactViewController()
    //           addContactController.currentUser = self.currentUser
    //           navigationController?.pushViewController(addContactController, animated: true)
        print("Add chat button tapped")
       }



    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }


}

