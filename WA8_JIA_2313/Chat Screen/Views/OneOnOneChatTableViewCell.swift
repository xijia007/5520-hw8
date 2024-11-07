//
//  OneOnOneChatTableViewCell.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/7/24.
//

import UIKit

class OneOnOneChatTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var friendSide: UILabel!
    var selfSide: UILabel!
    var messageBody: UITextField!
    var timeLabel: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        setupWrapperCellView()
        setupFriendSideLabel()
        setupMessageBody()
        setupSelfSideLabel()
        setupTimeLabel()
        initConstraints()
    }
    
    func setupWrapperCellView() {
        wrapperCellView = UIView()
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapperCellView)
    }
    
    func setupFriendSideLabel() {
        friendSide = UILabel()
        friendSide.textAlignment = .center
        friendSide.font = UIFont.boldSystemFont(ofSize: 16)
        friendSide.adjustsFontSizeToFitWidth = true
        friendSide.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(friendSide)
    }
    
    func setupSelfSideLabel() {
        selfSide = UILabel()
        selfSide.textAlignment = .center
        selfSide.adjustsFontSizeToFitWidth = true
        selfSide.font = UIFont.boldSystemFont(ofSize: 16)
        selfSide.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(selfSide)
    }
    
    func setupMessageBody() {
        messageBody = UITextField()
        messageBody.layer.cornerRadius = 4.0
        messageBody.heightAnchor.constraint(equalToConstant: 40).isActive = true
        messageBody.adjustsFontSizeToFitWidth = true
        messageBody.translatesAutoresizingMaskIntoConstraints = false
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        messageBody.leftView = paddingView
        messageBody.leftViewMode = .always
        wrapperCellView.addSubview(messageBody)
    }

    func setupTimeLabel() {
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textColor = UIColor.gray
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(timeLabel)
    }
    
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            timeLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 5),
            timeLabel.centerXAnchor.constraint(equalTo: wrapperCellView.centerXAnchor),

            friendSide.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            friendSide.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 5),
            friendSide.widthAnchor.constraint(equalToConstant: 40),
            friendSide.heightAnchor.constraint(equalToConstant: 40),
            
            messageBody.topAnchor.constraint(equalTo: friendSide.topAnchor),
            messageBody.leadingAnchor.constraint(equalTo: friendSide.trailingAnchor, constant: 8),
            messageBody.trailingAnchor.constraint(equalTo: selfSide.leadingAnchor, constant: -5),
            messageBody.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8),
            
            selfSide.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            selfSide.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -5),
            selfSide.widthAnchor.constraint(equalToConstant: 40),
            selfSide.heightAnchor.constraint(equalToConstant: 40),
        ])
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


