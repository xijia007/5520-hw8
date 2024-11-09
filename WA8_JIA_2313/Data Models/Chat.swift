//
//  Chat.swift
//  app12
//
//  Created by Xi Jia on 11/5/24.
//

import Foundation
import FirebaseFirestore

struct ChatList: Codable {
    var chatList: [ChatCell]
}

struct ChatCell: Codable {
    var receiverName: String
    var receiverUID: String // Add receiverUID to store the recipient's UID
    var content: String
    var dateAndTime: Int
    @DocumentID var channelId: String?

    // Updated initializer to include receiverUID
    init(receiverName: String, receiverUID: String, content: String, dateAndTime: Int, channelId: String) {
        self.receiverName = receiverName
        self.receiverUID = receiverUID
        self.content = content
        self.dateAndTime = dateAndTime
        self.channelId = channelId
    }
}

struct ChatChannels: Codable {
    var chatChannels: [ChatChannel]
}

struct ChatChannel: Codable {
    @DocumentID var channelId: String?
    var threads: [Thread]
    var participants: [String] // Store an array of participant UIDs to match Firestore structure
}

struct Thread: Codable {
    @DocumentID var threadId: String?
    var content: String
    var dateAndTime: Timestamp
    var senderName: String
    var senderUid: String
}

struct ChatChannelParticipants: Codable {
    @DocumentID var participantId: String?
    var creatorName: String
    var creatorUid: String
    var receiverName: String
    var receiverUid: String
}
