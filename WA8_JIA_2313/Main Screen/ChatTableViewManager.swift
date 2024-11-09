import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatTableViewManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    var chatList: [ChatCell] = []
    weak var tableView: UITableView?
    weak var navigationController: UINavigationController?
    
    init(tableView: UITableView, navigationController: UINavigationController) {
        super.init()
        self.tableView = tableView
        self.navigationController = navigationController
        tableView.dataSource = self
        tableView.delegate = self
        fetchChatList()
    }
    
    func fetchChatList() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("No current user found")
            return
        }

        let db = Firestore.firestore()
        chatList.removeAll() // Clear list to prevent duplicates
        db.collection("chatChannels")
            .whereField("participants", arrayContains: currentUserUID)
            .limit(to: 20)
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found in chatChannels.")
                    return
                }
                
                print("Fetched \(documents.count) chat documents from Firestore.")
                
                let dispatchGroup = DispatchGroup()
                
                for document in documents {
                    let data = document.data()
                    
                    guard let lastMessageContent = data["lastMessageContent"] as? String, !lastMessageContent.isEmpty,
                          let lastMessageTimestamp = data["lastMessageTimestamp"] as? Timestamp,
                          let participants = data["participants"] as? [String] else {
                        continue
                    }
                    
                    let otherParticipantUID = participants.first { $0 != currentUserUID }
                    
                    if let otherUID = otherParticipantUID {
                        dispatchGroup.enter()
                        
                        db.collection("users").document(otherUID).getDocument { userDoc, error in
                            defer { dispatchGroup.leave() }
                            
                            guard let userData = userDoc?.data(), let otherName = userData["name"] as? String else {
                                print("Failed to fetch other participant's name.")
                                return
                            }
                            
                            let chatCell = ChatCell(
                                receiverName: otherName,
                                receiverUID: otherUID,
                                content: lastMessageContent,
                                dateAndTime: Int(lastMessageTimestamp.seconds),
                                channelId: document.documentID
                            )
                            
                            self?.chatList.append(chatCell)
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self?.tableView?.reloadData()
                }
            }
    }
    
    // MARK: - UITableViewDataSource and UITableViewDelegate
    
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
    
    // Swipe to delete a chat with confirmation and full database removal
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let chatToDelete = chatList[indexPath.row]
            
            // Show confirmation alert
            let alert = UIAlertController(
                title: "Delete Chat",
                message: "Are you sure you want to delete this chat? This will remove it for both users.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.deleteChat(chatToDelete, at: indexPath)
            }))
            
            navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func deleteChat(_ chat: ChatCell, at indexPath: IndexPath) {
        guard let channelId = chat.channelId else { return }
        
        let db = Firestore.firestore()
        let chatChannelRef = db.collection("chatChannels").document(channelId)
        
        // Delete the entire chat channel document and its subcollection
        chatChannelRef.delete { [weak self] error in
            if let error = error {
                print("Error deleting chat channel: \(error)")
                return
            }
            
            print("Chat channel deleted successfully.")
            self?.chatList.remove(at: indexPath.row)
            self?.tableView?.deleteRows(at: [indexPath], with: .automatic)
            self?.fetchChatList()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChat = chatList[indexPath.row]
        
        let chatVC = OneOnOneChatViewController()
        chatVC.recipientUID = selectedChat.receiverUID
        chatVC.recipientName = selectedChat.receiverName
        chatVC.chatChannelId = selectedChat.channelId
        
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
