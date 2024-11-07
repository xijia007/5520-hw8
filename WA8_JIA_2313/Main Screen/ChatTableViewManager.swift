//
//  ChatTableViewManager.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/5/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatTableViewManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    var chatList: [ChatCell] = []
    weak var tableView: UITableView?
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.dataSource = self
        tableView.delegate = self
        fetchChatList()
//        fetchChatParticipants()
    }
    
    func fetchChatList() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("No current user found")
            return
        }

        let db = Firestore.firestore()
        
        db.collection("chatChannels")
//            .whereField("senderUid", arrayContains: currentUserUID)
//            .order(by: "lastMessageTimestamp", descending: true)
            .limit(to: 20) // Limit the number of channels to fetch
            .getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            self?.chatList = documents.compactMap { document -> ChatCell? in
                let data = document.data()
                guard let receiverName = data["receiverName"] as? String,
                      let content = data["lastMessageContent"] as? String,
                      let dateAndTime = data["lastMessageTimestamp"] as? Timestamp else {
                    return nil
                }
                return ChatCell(receiverName: receiverName,
                                content: content,
                                dateAndTime: Int(dateAndTime.seconds),
                                channelId: document.documentID)
            }
            
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        
        let chatCell = chatList[indexPath.row]
        cell.configure(with: chatCell)
        
        return cell
    }
}



