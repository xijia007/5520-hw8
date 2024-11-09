//
//  ChatFirebaseManager.swift
//  WA8_JIA_2313
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ChatFirebaseManager {
    let db = Firestore.firestore()
    
    // Function to fetch messages from a specific chat channel
    func fetchMessages(channelId: String, completion: @escaping ([Message]) -> Void) {
        db.collection("chatChannels").document(channelId).collection("messages")
            .order(by: "dateAndTime", descending: false)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                let messages = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Message.self)
                } ?? []
                
                completion(messages)
            }
    }
    
    // Function to send a new message to a chat channel
    func sendMessage(to channelId: String, message: Message, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("chatChannels").document(channelId).collection("messages")
                .addDocument(from: message)
            completion(true)
        } catch let error {
            print("Error sending message: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    // Version 1: Function to fetch an existing channel between two users (for contact list)
    func fetchExistingChannelForContact(for user1: String, user2: String, completion: @escaping (String?) -> Void) {
        db.collection("chatChannels")
            .whereField("participants", arrayContains: user1)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching existing channel for contact: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                let channelId = snapshot?.documents.first { doc in
                    let participants = doc.data()["participants"] as? [String]
                    return participants?.contains(user2) ?? false
                }?.documentID
                
                completion(channelId)
            }
    }
    
    // Version 2: Function to fetch all existing channels for a user (for main view)
    func fetchAllExistingChannelsForUser(userId: String, completion: @escaping ([ChatCell]) -> Void) {
        self.db.collection("chatChannels")
            .whereField("participants", arrayContains: userId)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching all channels for user: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                let dispatchGroup = DispatchGroup()
                var chatList: [ChatCell] = []
                
                snapshot?.documents.forEach { doc in
                    let data = doc.data()
                    guard let participants = data["participants"] as? [String],
                          let lastMessageContent = data["lastMessageContent"] as? String,
                          let lastMessageTimestamp = data["lastMessageTimestamp"] as? Timestamp else {
                        return
                    }
                    
                    // Identify the UID of the other participant
                    let otherParticipantUID = participants.first { $0 != userId }
                    
                    if let otherUID = otherParticipantUID {
                        dispatchGroup.enter()
                        
                        // Fetch the other participant's name
                        self.db.collection("users").document(otherUID).getDocument { [weak self] userDoc, error in
                            defer { dispatchGroup.leave() }
                            guard let self = self else { return }
                            
                            guard let userData = userDoc?.data(),
                                  let otherName = userData["name"] as? String else {
                                print("Error fetching user data for UID \(otherUID): \(error?.localizedDescription ?? "Unknown error")")
                                return
                            }
                            
                            let chatCell = ChatCell(
                                receiverName: otherName,
                                receiverUID: otherUID,
                                content: lastMessageContent,
                                dateAndTime: Int(lastMessageTimestamp.seconds),
                                channelId: doc.documentID
                            )
                            
                            chatList.append(chatCell)
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(chatList)
                }
            }
    }
    
    // Function to create a new unique chat channel
    func createNewChannel(for user1: String, user2: String, completion: @escaping (String?) -> Void) {
        let newChannelRef = db.collection("chatChannels").document()
        let channelId = newChannelRef.documentID
        
        let chatData = [
            "participants": [user1, user2],
            "createdAt": Timestamp(),
            "lastMessageContent": "",
            "lastMessageTimestamp": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        newChannelRef.setData(chatData) { error in
            if let error = error {
                print("Error creating new channel: \(error.localizedDescription)")
                completion(nil)
            } else {
                print("New channel created successfully with ID \(channelId).")
                completion(channelId)
            }
        }
    }
    
    // Function to delete a chat channel and all its messages
    func deleteChannelWithMessages(channelId: String, completion: @escaping (Bool) -> Void) {
        let channelRef = db.collection("chatChannels").document(channelId)
        
        channelRef.collection("messages").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error fetching messages for deletion: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            let batch = self.db.batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.deleteDocument(channelRef)
            
            batch.commit { error in
                if let error = error {
                    print("Error deleting channel and messages: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Chat channel deleted successfully.")
                    completion(true)
                }
            }
        }
    }
}
