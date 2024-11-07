//
//  OneOnOneChatView.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/7/24.
//

import UIKit

class OneOnOneChatView: UIView {
    
    var conversationTableView: UITableView!
    var messageEditTextField: UITextField!
    var sendButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupConversationTableView()
        setupMessageEditTextField()
        setupSendButton()
        initConstraints()
    }
    
    func setupConversationTableView() {
        conversationTableView = UITableView()
        conversationTableView.register(OneOnOneChatTableViewCell.self, forCellReuseIdentifier: "conversationCell")
        conversationTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(conversationTableView)
    }
    
    func setupMessageEditTextField() {
        messageEditTextField = UITextField()
        messageEditTextField.borderStyle = .roundedRect
        messageEditTextField.backgroundColor = .white
        messageEditTextField.layer.cornerRadius = 4.0
        messageEditTextField.layer.shadowColor = UIColor.gray.cgColor
        messageEditTextField.layer.shadowOffset = .zero
        messageEditTextField.layer.shadowRadius = 2.0
        messageEditTextField.layer.shadowOpacity = 0.7
        messageEditTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messageEditTextField)
    }
    
    func setupSendButton() {
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sendButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            conversationTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            conversationTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            conversationTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            conversationTableView.bottomAnchor.constraint(equalTo: messageEditTextField.topAnchor, constant: -8),
 
            messageEditTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            messageEditTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            messageEditTextField.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -36),
            messageEditTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            
            sendButton.topAnchor.constraint(equalTo: messageEditTextField.topAnchor),
            sendButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            sendButton.widthAnchor.constraint(equalToConstant: 42),
            sendButton.heightAnchor.constraint(equalTo: messageEditTextField.heightAnchor),

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

