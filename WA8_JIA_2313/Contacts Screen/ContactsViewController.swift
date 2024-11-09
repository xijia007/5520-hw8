//
//  ContactsViewController.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/5/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var contacts: [Contact] = []
    let oneOnOneChatViewController = OneOnOneChatViewController()
    
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
        db.collection("users").whereField("id", isNotEqualTo: currentUserUID).getDocuments { [weak self] (querySnapshot, error) in
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
                      let id = data["id"] as? String else {
                    return nil
                }
                return Contact(name: name, email: email, id: id)
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
        
        let chatVC = OneOnOneChatViewController()
        chatVC.recipientUID = selectedContact.id
        chatVC.recipientName = selectedContact.name
        
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
