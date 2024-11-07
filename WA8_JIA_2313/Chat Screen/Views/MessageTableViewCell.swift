//
//  MessageTableViewCell.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/7/24.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var senderNameLabel: UILabel!
    var messageBody: UITextField!
    var timeLabel: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        setupWrapperCellView()
        setupSenderNameField()
        setupMessageBody()
        setupTimeLabel()
        initConstraints()
        
    }
    
    func setupWrapperCellView() {
        wrapperCellView = UITableViewCell()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 4.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 2.0
        wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapperCellView)
    }
    
    func setupSenderNameField() {
        senderNameLabel = UILabel()
        senderNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        senderNameLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(senderNameLabel)
    }
    
    func setupMessageBody() {
        messageBody = UITextField()
        messageBody.font = UIFont.systemFont(ofSize: 15)
        messageBody.textColor = UIColor.gray
        messageBody.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(messageBody)
    }
    
    func setupTimeLabel() {
        timeLabel = UILabel()
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textColor = .gray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(timeLabel)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            wrapperCellView.heightAnchor.constraint(equalToConstant: 60),

            
            senderNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor),
            senderNameLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            
            messageBody.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: -3),
            messageBody.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            messageBody.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -3),
            messageBody.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: messageBody.topAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -5),
            timeLabel.leadingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -75),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

