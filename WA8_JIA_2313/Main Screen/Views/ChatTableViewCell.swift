//
//  ChatTableViewCell.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/5/24.
//


import UIKit

class ChatTableViewCell: UITableViewCell {
    var receiverNameLabel: UILabel!
    var contentLabel: UILabel!
    var dateTimeLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupReceiverNameLabel()
        setupContentLabel()
        setupDateTimeLabel()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupReceiverNameLabel() {
        receiverNameLabel = UILabel()
        receiverNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        receiverNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(receiverNameLabel)
    }
    
    func setupContentLabel() {
        contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentLabel)
    }
    
    func setupDateTimeLabel() {
        dateTimeLabel = UILabel()
        dateTimeLabel.font = UIFont.systemFont(ofSize: 12)
        dateTimeLabel.textColor = .gray
        dateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateTimeLabel)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            receiverNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            receiverNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            receiverNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            contentLabel.topAnchor.constraint(equalTo: receiverNameLabel.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dateTimeLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 4),
            dateTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with chatCell: ChatCell) {
        receiverNameLabel.text = chatCell.receiverName
        contentLabel.text = chatCell.content
        dateTimeLabel.text = formatDate(timestamp: chatCell.dateAndTime)
    }

    private func formatDate(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter.string(from: date)
    }
}
