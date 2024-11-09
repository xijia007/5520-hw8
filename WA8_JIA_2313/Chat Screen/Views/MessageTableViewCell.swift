//
//  MessageTableViewCell.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/8/24.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    private let senderLabel = UILabel()
    private let messageLabel = UILabel()
    private let dateLabel = UILabel()
    private let bubbleBackgroundView = UIView()
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var senderLeadingConstraint: NSLayoutConstraint!
    private var senderTrailingConstraint: NSLayoutConstraint!
    private var dateLeadingConstraint: NSLayoutConstraint!
    private var dateTrailingConstraint: NSLayoutConstraint!
    
    var isCurrentUser: Bool = false {
        didSet {
            bubbleBackgroundView.backgroundColor = isCurrentUser ? UIColor.systemBlue : UIColor(white: 0.9, alpha: 1)
            messageLabel.textColor = isCurrentUser ? .white : .black
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(senderLabel)
        addSubview(bubbleBackgroundView)
        bubbleBackgroundView.addSubview(messageLabel)
        addSubview(dateLabel)
        
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        senderLabel.font = .systemFont(ofSize: 12, weight: .bold)
        dateLabel.font = .systemFont(ofSize: 10, weight: .light)
        dateLabel.textColor = .darkGray
        
        leadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        trailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        senderLeadingConstraint = senderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        senderTrailingConstraint = senderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        dateLeadingConstraint = dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        dateTrailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)

        leadingConstraint.isActive = false
        trailingConstraint.isActive = false
        senderLeadingConstraint.isActive = false
        senderTrailingConstraint.isActive = false
        dateLeadingConstraint.isActive = false
        dateTrailingConstraint.isActive = false
        
        NSLayoutConstraint.activate([
            // Constraints for senderLabel
            senderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            
            // Constraints for messageLabel within the bubble
            messageLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8),
            
            // Constraints for bubbleBackgroundView
            bubbleBackgroundView.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 4),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -4),
            bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            // Constraints for dateLabel
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }
    
    func configure(with message: Message, isCurrentUser: Bool) {
        self.isCurrentUser = isCurrentUser
        senderLabel.text = message.senderName
        messageLabel.text = message.body
        dateLabel.text = formatTimestamp(message.dateAndTime)


        NSLayoutConstraint.deactivate([
            leadingConstraint,
            trailingConstraint,
            senderLeadingConstraint,
            senderTrailingConstraint,
            dateLeadingConstraint,
            dateTrailingConstraint
        ])

        if isCurrentUser {
                trailingConstraint.isActive = true
                senderTrailingConstraint.isActive = true
                dateTrailingConstraint.isActive = true
                bubbleBackgroundView.backgroundColor = UIColor.systemBlue
                messageLabel.textColor = .white
            } else {
                leadingConstraint.isActive = true
                senderLeadingConstraint.isActive = true
                dateLeadingConstraint.isActive = true
                bubbleBackgroundView.backgroundColor = UIColor(white: 0.9, alpha: 1)
                messageLabel.textColor = .black
            }

        layoutIfNeeded()
    }
    
    private func formatTimestamp(_ timestamp: Double?) -> String {
        guard let timestamp = timestamp else { return "" }
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
