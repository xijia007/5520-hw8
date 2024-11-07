//
//  ChatScreenViewController.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/6/24.
//

import UIKit

class ChatScreenViewController: UIViewController {
    var chatView: ChatScreenView!
    var contact: Contact
    
    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        chatView = ChatScreenView()
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat with \(contact.name)" 
        
        chatView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc func sendButtonTapped() {
        // Implement send message functionality here
        print("Send button tapped")
    }
}
