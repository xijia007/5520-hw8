//
//  ChatInputView.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/7/24.
//

import UIKit

class ChatInputView: UIView {
    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type a message..."
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(messageTextField)
        addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            messageTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageTextField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            sendButton.leadingAnchor.constraint(equalTo: messageTextField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: messageTextField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}
