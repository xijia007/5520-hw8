////
////  ContactsViewController.swift
////  WA8_JIA_2313
////
////  Created by Xi Jia on 11/5/24.
////
//
//import UIKit
//import FirebaseAuth
//import FirebaseFirestore
//
//class ContactsViewController: UIViewController {
//    
//    let contactView = ContactsView()
//    
//    var contactsList = [Contact]()
//    
//    let database = Firestore.firestore()
//    
//    // create an authentication state change listener to track whether any user is signed in
//    var handleAuth: AuthStateDidChangeListenerHandle?
//    
//    // create a variable to keep an instance of the current signed-in Firebase user
//    var currentUser:FirebaseAuth.User?
//    
//    override func loadView() {
//        view = contactView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = "Contacts"
//        
//        //MARK: patching table view delegate and data source...
//        contactView.tableViewContacts.delegate = self
//        contactView.tableViewContacts.dataSource = self
//        
//        //MARK: removing the separator line...
//        contactView.tableViewContacts.separatorStyle = .none
//
//
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
//        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
//            if user == nil{
//                //MARK: not signed in...
//                self.currentUser = nil
//                self.contactView.labelText.text = "Please sign in to see the notes!"
//                
//                //MARK: Reset tableView...
//                self.contactsList.removeAll()
//                self.contactView.tableViewContacts.reloadData()
//                
//
//            }else{
//                //MARK: the user is signed in...
//                self.currentUser = user
//                self.contactView.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
//                
//                //MARK: Observe Firestore database to display the contacts list...
//             
//                // observe the "contacts" collection of the current user document.
//                self.database.collection("users")
//                    .document((self.currentUser?.uid)!)
//                    .collection("contacts")
//                
//                
//                // when a user is signed in, we add a SnapshotListener
//                
//                    .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
//                
//                        // If anything is changed in that collection, the closure gets triggered and querySnapshot contains the updates.
//                        
//                        // append all the current contacts from the querySnapshot
//                        if let documents = querySnapshot?.documents{
//                            // empty our current local contacts array
//                            self.contactsList.removeAll()
//                            for document in documents{
//                                do{
//                                    // parse the received document and decode that according to the Contact struct (which is Codable).
//                                    let contact  = try document.data(as: Contact.self)
//                                    self.contactsList.append(contact)
//                                }catch{
//                                    print(error)
//                                }
//                            }
//                            // sort the contacts in the alphabetic order of names.
//                            self.contactsList.sort(by: {$0.name < $1.name})
//                            // reload the table view data.
//                            self.contactView.tableViewContacts.reloadData()
//                        }
//                    })
//                
//            }
//        }
//    }
// 
//    
//}
//
//
//

//import UIKit
//import FirebaseFirestore
//
//class ContactsViewController: UIViewController {
//    
//    var tableView: UITableView!
//    var tableViewManager: ContactTableViewManager!
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        title = "Contacts"
//        
//        setupTableView()
//    }
//    
//    func setupTableView() {
//        tableView = UITableView(frame: view.bounds, style: .plain)
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(tableView)
//        
//        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactCell")
//        
//        tableViewManager = ContactTableViewManager(tableView: tableView)
//    }
//}
//import UIKit
//import FirebaseFirestore
//
//class ContactsViewController: UIViewController {
//    
//    var tableView: UITableView!
//    var tableViewManager: ContactTableViewManager!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Contacts"
//        setupTableView()
//    }
//    
//    func setupTableView() {
//        tableView = UITableView(frame: view.bounds, style: .plain)
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(tableView)
//        
//        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactCell")
//        
//        tableViewManager = ContactTableViewManager(tableView: tableView)
//        
//    }
//}

//import UIKit
//import FirebaseFirestore
//import FirebaseAuth
//
//class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    var tableView: UITableView!
//    var contacts: [Contact] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Contacts"
//        setupTableView()
//        fetchContacts()
//    }
//    
//    func setupTableView() {
//        tableView = UITableView(frame: view.bounds, style: .plain)
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(tableView)
//        
//        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactCell")
//        
//        tableView.dataSource = self
//        tableView.delegate = self
//    }
//    
//    func fetchContacts() {
//        guard let currentUserUID = Auth.auth().currentUser?.uid else {
//            print("No current user found")
//            return
//        }
//        
//        print("current user uid: \(currentUserUID)")
//        
//        let db = Firestore.firestore()
//        db.collection("users").whereField("uid", isNotEqualTo: currentUserUID).getDocuments { [weak self] (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//                return
//            }
//            
//            guard let documents = querySnapshot?.documents else {
//                print("No documents found")
//                return
//            }
//            
//            self?.contacts = documents.compactMap { document -> Contact? in
//                let data = document.data()
//                guard let name = data["name"] as? String,
//                      let email = data["email"] as? String,
//                      let uid = data["uid"] as? String else {
//                    return nil
//                }
//                return Contact(name: name, email: email, uid: uid)
//            }
//            
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
//    }
//    
//    // MARK: - UITableViewDataSource
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return contacts.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        let contact = contacts[indexPath.row]
//        cell.configure(with: contact)
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//           tableView.deselectRow(at: indexPath, animated: true)
//           let selectedContact = contacts[indexPath.row]
//           let chatViewController = ChatScreenViewController(contact: selectedContact)
//           navigationController?.pushViewController(chatViewController, animated: true)
//       }
//}
//import UIKit
//import FirebaseFirestore
//import FirebaseAuth
//
//class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    var tableView: UITableView!
//    var contacts: [Contact] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Contacts"
//        setupTableView()
//        fetchContacts()
//    }
//    
//    func setupTableView() {
//        tableView = UITableView(frame: view.bounds, style: .plain)
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactCell")
//        view.addSubview(tableView)
//    }
//    
//    func fetchContacts() {
//        guard let currentUserUID = Auth.auth().currentUser?.uid else {
//            print("No current user found")
//            return
//        }
//        
//        let db = Firestore.firestore()
//        db.collection("users").whereField("uid", isNotEqualTo: currentUserUID).getDocuments { [weak self] (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//                return
//            }
//            
//            guard let documents = querySnapshot?.documents else {
//                print("No documents found")
//                return
//            }
//            
//            self?.contacts = documents.compactMap { document -> Contact? in
//                let data = document.data()
//                guard let name = data["name"] as? String,
//                      let email = data["email"] as? String,
//                      let uid = data["uid"] as? String else {
//                    return nil
//                }
//                return Contact(name: name, email: email, uid: uid)
//            }
//            
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
//    }
//    
//    // MARK: - UITableViewDataSource
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return contacts.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        let contact = contacts[indexPath.row]
//        cell.configure(with: contact)
//        
//        return cell
//    }
//    
//    // MARK: - UITableViewDelegate
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let selectedContact = contacts[indexPath.row]
//        // Handle the selection of a contact here
//        print("Selected contact: \(selectedContact.name)")
//    }
//}
import UIKit
import FirebaseFirestore
import FirebaseAuth

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        setupTableView()
        fetchContacts()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchContacts() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("No current user found")
            return
        }
        
        print("current user uid: \(currentUserUID)")
        
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isNotEqualTo: currentUserUID).getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            self?.contacts = documents.compactMap { document -> Contact? in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let email = data["email"] as? String,
                      let uid = data["uid"] as? String else {
                    return nil
                }
                return Contact(name: name, email: email, uid: uid)
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        
        let contact = contacts[indexPath.row]
        cell.configure(with: contact)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           let selectedContact = contacts[indexPath.row]
           let chatViewController = ChatScreenViewController(contact: selectedContact)
           navigationController?.pushViewController(chatViewController, animated: true)
       }
}
