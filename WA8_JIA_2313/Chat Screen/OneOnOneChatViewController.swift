//
//  OneOnOneChatViewController.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/7/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class OneOnOneChatViewController: UIViewController {
    
    let oneOnOneChatView = OneOnOneChatView()
    var theOther: User?
    let db = Firestore.firestore()
    var messages = [Message]()
    let notificationCenter = NotificationCenter.default

    override func loadView() {
        view = oneOnOneChatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = theOther?.name
        hideKeyboardOnTapOutside()
        
        oneOnOneChatView.conversationTableView.dataSource = self
        oneOnOneChatView.conversationTableView.delegate = self
        oneOnOneChatView.conversationTableView.separatorStyle = .none
        
        loadMessageBetweenSelfAndFriend()
        
        oneOnOneChatView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
    }
    
    func hideKeyboardOnTapOutside() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }
    
    @objc func sendButtonTapped() {
        guard let msg = oneOnOneChatView.messageEditTextField.text,!msg.isEmpty else {
            showAlert(message: "You cannot send empty message!")
            return
        }
        
        if let messageBody = oneOnOneChatView.messageEditTextField.text,let name = Auth.auth().currentUser?.displayName, let email = Auth.auth().currentUser?.email, let theOther = theOther {
            
            let date = Date().timeIntervalSince1970
            db.collection("messages").addDocument(data: ["senderName": name, "senderEmail": email, "body":messageBody, "date": date, "receiverName": theOther.name, "receiverEmail": theOther.email]) { error in
                        if let e =  error{
                            print("There is an error when add data to database:\(e)")
                        }else{
                            print("Successfully saved data.")
                            // clear the sended message
                            self.oneOnOneChatView.messageEditTextField.text = ""
                            self.oneOnOneChatView.conversationTableView.reloadData()
                            self.loadMessageBetweenSelfAndFriend()
                            self.notificationCenter.post(name: NSNotification.Name("updateMessage"), object: self.messages)
                        }
                    }
                    
                }
    }
    
    func loadMessageBetweenSelfAndFriend() {
        db.collection("messages").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("There is an error when read data from database:\(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents, let theOther = self.theOther {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let senderName = data["senderName"] as? String, let senderEmail = data["senderEmail"] as? String, let messageBody = data["body"] as? String, let theOtherName = data["receiverName"] as? String, let theOtherEmail = data["receiverEmail"] as? String, let date = data["date"] as? Double, let currentUserEmail = Auth.auth().currentUser?.email {
                            
                            if (senderEmail == currentUserEmail && theOtherEmail == theOther.email) || (theOtherEmail == currentUserEmail && senderEmail == theOther.email) {
                                let newMessage = Message(senderName: senderName, senderEmail: senderEmail, body: messageBody, receiverName: theOtherName, receiverEmail: theOtherEmail, dateAndTime: date)
                                self.messages.append(newMessage)

                            }
                        }
                    }
                   
                    DispatchQueue.main.async {
                        self.messages.sort(by: {$0.dateAndTime ?? 0 < $1.dateAndTime ?? 0})
                        self.oneOnOneChatView.conversationTableView.reloadData()
                        // scroll the screen to represent latest message
                        if self.messages.count > 0 {
                            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                            self.oneOnOneChatView.conversationTableView.scrollToRow(at:indexPath, at:.top, animated: true)
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    func showAlert(message: String?) {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alertVC, animated: true)
    }
}

extension OneOnOneChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! OneOnOneChatTableViewCell
        
        let message = messages[indexPath.row]
        cell.messageBody.text = messages[indexPath.row].body
        cell.friendSide.text = theOther?.name
        cell.selfSide.text = Auth.auth().currentUser?.displayName
        cell.timeLabel.text = convertToDateAndTime(message.dateAndTime)
        
        if message.senderEmail == Auth.auth().currentUser?.email {
            cell.friendSide.isHidden = true
            cell.selfSide.isHidden = false
            cell.messageBody.backgroundColor = .cyan
        } else {
            cell.friendSide.isHidden = false
            cell.selfSide.isHidden = true
            cell.messageBody.backgroundColor = .systemPink
        }
        return cell
    }
    
    func convertToDateAndTime(_ date: TimeInterval? ) -> String? {
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

