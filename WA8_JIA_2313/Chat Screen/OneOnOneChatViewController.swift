//
//  OneOnOneChatViewController.swift
//  WA8_JIA_2313
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class OneOnOneChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let chatInputView = ChatInputView()
    private let chatManager = ChatFirebaseManager()
    
    var messages: [Message] = []
    var recipientUID: String = ""
    var recipientName: String = ""
    var chatChannelId: String?
    private var isChannelFetched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = recipientName
        setupViewHierarchy()
        setupTableView()
        setupInputView()
        checkOrFetchChannel()
    }
    
    private func setupViewHierarchy() {
        view.addSubview(tableView)
        view.addSubview(chatInputView)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: chatInputView.topAnchor)
        ])
    }
    
    private func setupInputView() {
        chatInputView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chatInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chatInputView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        chatInputView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
    
    private func checkOrFetchChannel() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        
        chatManager.fetchExistingChannelForContact(for: currentUserUID, user2: recipientUID) { [weak self] existingChannelId in
            guard let self = self else { return }
            
            if let channelId = existingChannelId {
                self.chatChannelId = channelId
                self.isChannelFetched = true
                self.fetchMessages()
            } else {
                self.isChannelFetched = false
                self.chatChannelId = nil // Only set a new one upon the first message
            }
        }
    }
    
    private func fetchMessages() {
        guard let channelId = chatChannelId else { return }
        
        chatManager.fetchMessages(channelId: channelId) { [weak self] messages in
            self?.messages = messages
            self?.tableView.reloadData()
            self?.scrollToBottom()
        }
    }
    
    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc func sendMessage() {
        guard let text = chatInputView.messageTextField.text, !text.isEmpty else { return }

        if chatChannelId == nil {
            // Create a new unique channel only when the first message is sent
            chatManager.createNewChannel(for: Auth.auth().currentUser?.uid ?? "", user2: recipientUID) { [weak self] channelId in
                guard let self = self, let channelId = channelId else { return }
                self.chatChannelId = channelId
                
                // Start fetching messages from the new channel immediately
                self.fetchMessages()
                
                // Send the message in the newly created channel
                self.sendMessageToChannel(channelId: channelId, text: text)
            }
        } else if let channelId = chatChannelId {
            // Send message to existing channel
            sendMessageToChannel(channelId: channelId, text: text)
        }
    }
    
    func sendMessageToChannel(channelId: String, text: String) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        
        let message = Message(
            senderName: UserSessionManager.shared.currentUser?.name ?? "Unknown",
            senderEmail: UserSessionManager.shared.currentUser?.email ?? "Unknown",
            body: text,
            receiverName: recipientName,
            receiverEmail: "receiver@example.com",  // Replace with actual recipient's email if available
            dateAndTime: Date().timeIntervalSince1970
        )
        
        chatManager.sendMessage(to: channelId, message: message) { [weak self] success in
            if success {
                self?.chatInputView.messageTextField.text = ""
                self?.updateLastMessageInChannel(channelId: channelId, lastMessage: text)
            } else {
                print("Failed to send message.")
            }
        }
    }

    // Function to update the last message and timestamp in the chat channel
    func updateLastMessageInChannel(channelId: String, lastMessage: String) {
        chatManager.db.collection("chatChannels").document(channelId).updateData([
            "lastMessageContent": lastMessage,
            "lastMessageTimestamp": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                print("Error updating last message: \(error.localizedDescription)")
            } else {
                print("Last message updated successfully.")
            }
        }
    }
    
    @objc func deleteConversation() {
        guard let channelId = chatChannelId else { return }
        
        // Ask for confirmation
        let alert = UIAlertController(title: "Delete Conversation", message: "Are you sure you want to delete this conversation? This action cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            self.chatManager.deleteChannelWithMessages(channelId: channelId) { success in
                if success {
                    print("Conversation deleted successfully.")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Failed to delete conversation.")
                }
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        
        // Configure cell with sender's name, message, and formatted date
        let isCurrentUser = message.senderEmail == UserSessionManager.shared.currentUser?.email
        cell.configure(with: message, isCurrentUser: isCurrentUser)
        
        return cell
    }
}
