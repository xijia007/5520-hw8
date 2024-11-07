//
//  MessengerScreenViewController.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/7/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class MessengerScreenViewController: UIViewController {
    
    let messengerScreenView = MessengerScreenView()
    let db = Firestore.firestore()
    var messages = [Message]()
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = messengerScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chat List"
        
        if let userName = Auth.auth().currentUser?.displayName {
                messengerScreenView.welcomeLabel.text = "Welcome, \(userName)!"
        } else {
            messengerScreenView.welcomeLabel.text = "Welcome"
        }

        
        messengerScreenView.messageTableView.delegate = self
        messengerScreenView.messageTableView.dataSource = self
        messengerScreenView.messageTableView.separatorStyle = .none
        
        let logged = UserDefaults.standard.bool(forKey: "logged")
        if logged {
            self.navigationItem.hidesBackButton = true
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", image: nil, target: self, action: #selector(logoutButtonTapped))
        
        loadAllMessages()
        notificationCenter.addObserver(
                    self,
                    selector: #selector(updateMessage(notification:)),
                    name: NSNotification.Name("updateMessage"),
                    object: nil)

    }
    
    @objc func updateMessage(notification: Notification) {
        self.loadAllMessages()
    }
    
    @objc func logoutButtonTapped() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.set(nil, forKey: "email")
            UserDefaults.standard.set(false, forKey: "logged")
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError{
            print("sign out error is:\(signOutError)")
        }
    }
    
    func loadAllMessages() {
        // load exsiting conversations
        var emailToDateDict = [String: Double]()
        var emailToMsgDict = [String: Message]()
        self.messages = []
        db.collection("messages").addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There is an error when read data from database:\(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let senderName = data["senderName"] as? String, let senderEmail = data["senderEmail"] as? String, let messageBody = data["body"] as? String, let receiverName = data["receiverName"] as? String, let receiverEmail = data["receiverEmail"] as? String, let currentUserEmail = Auth.auth().currentUser?.email, let date = data["date"] as? Double {
                            if receiverEmail == currentUserEmail || senderEmail == currentUserEmail {
                                let userEmail = receiverEmail == currentUserEmail ? senderEmail : receiverEmail
                                let newMessage = Message(senderName: senderName, senderEmail: senderEmail, body: messageBody, receiverName: receiverName, receiverEmail: receiverEmail, dateAndTime: date)
                                if emailToDateDict[userEmail] == nil || emailToDateDict[userEmail]! < date  {
                                    emailToDateDict[userEmail] = date
                                    emailToMsgDict[userEmail] = newMessage
                                }
                            }
                        }
                    }
                    for msg in emailToMsgDict.values {
                        self.messages.append(msg)
                    }
                }
            }
        }
        
        // load other users even no conversation
        db.collection("users").addSnapshotListener({
            (querySnapshot, error) in
            if let e = error {
                print(e)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let email = data["email"] as? String, let name = data["name"] as? String, let currentUserEmail = Auth.auth().currentUser?.email,let currentUserName = Auth.auth().currentUser?.displayName {
                            if !emailToMsgDict.keys.contains(email) && email.lowercased() != currentUserEmail.lowercased() {
                                let newMessage = Message(senderName: name, senderEmail: email, body: "", receiverName: currentUserName, receiverEmail: currentUserEmail)
                                emailToMsgDict[email] = newMessage
                                self.messages.append(newMessage)
                            }
                        }
                    }
                    self.messages.sort(by: {$0.dateAndTime ?? 0 > $1.dateAndTime ?? 0})
                    self.messengerScreenView.messageTableView.reloadData()
                    // scroll the screen to represent latest message.
                    if self.messages.count > 0 {
                        let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                        self.messengerScreenView.messageTableView.scrollToRow(at:indexPath, at:.top, animated: true)
                    }
                }
            }
        })
    }
}

extension MessengerScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
//        cell.senderNameLabel.text = messages[indexPath.row].senderName
//        cell.messageBody.text = messages[indexPath.row].body
//        if let date = messages[indexPath.row].dateAndTime {
//            cell.timeLabel.text = convertToDateAndTime(date)
//        }
//        return cell
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        let currentUserEmail = Auth.auth().currentUser?.email ?? ""
        
        cell.senderNameLabel.text = (message.senderEmail == currentUserEmail) ? message.receiverName : message.senderName
        cell.messageBody.text = message.body
        if let date = message.dateAndTime {
            cell.timeLabel.text = convertToDateAndTime(date)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let senderName = self.messages[indexPath.row].senderName
        let senderEmail = self.messages[indexPath.row].senderEmail
        let receiverName = self.messages[indexPath.row].receiverName
        let receiveEmail = self.messages[indexPath.row].receiverEmail
        let currentUserEmail = Auth.auth().currentUser?.email
        tableView.deselectRow(at: indexPath, animated: true)
        let oneOnOneChatVC = OneOnOneChatViewController()
        if currentUserEmail == senderEmail {
            oneOnOneChatVC.theOther = User(name: receiverName, email: receiveEmail)
        } else {
            oneOnOneChatVC.theOther = User(name: senderName, email: senderEmail)
        }
        
        navigationController?.pushViewController(oneOnOneChatVC, animated: true)
    }
    
   
    func convertToDateAndTime(_ date: TimeInterval?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        if let date = date {
            let date = Date(timeIntervalSince1970: date)
            dateFormatter.dateFormat = "YY/MM/dd, hh:mm"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

