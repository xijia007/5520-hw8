//
//  MainScreenView.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/5/24.
//

import UIKit

class MainScreenView: UIView {
    var profilePic: UIImageView!
    var labelText: UILabel!
    var guidanceLabel: UILabel!
    var activeChatsLabel: UILabel!
    var tableViewChats: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfilePic()
        setupLabelText()
        setupGuidanceLabel()
        setupActiveChatsLabel()
        setupTableViewChats()
        initConstraints()
    }
    
    func setupProfilePic() {
        profilePic = UIImageView()
        profilePic.image = UIImage(systemName: "person.circle")
        profilePic.contentMode = .scaleToFill
        profilePic.clipsToBounds = true
        profilePic.layer.masksToBounds = true
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePic)
    }
    
    func setupLabelText() {
        labelText = UILabel()
        labelText.font = .boldSystemFont(ofSize: 14)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelText)
    }
    
    func setupGuidanceLabel() {
        guidanceLabel = UILabel()
        guidanceLabel.text = "To start a new conversation, please click on the Contacts list."
        guidanceLabel.font = .systemFont(ofSize: 14)
        guidanceLabel.textColor = .gray
        guidanceLabel.numberOfLines = 0
        guidanceLabel.textAlignment = .center
        guidanceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(guidanceLabel)
    }
    
    func setupActiveChatsLabel() {
        activeChatsLabel = UILabel()
        activeChatsLabel.text = "Active Chats"
        activeChatsLabel.font = .boldSystemFont(ofSize: 18)
        activeChatsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activeChatsLabel)
    }
    
    func setupTableViewChats() {
        tableViewChats = UITableView()
        tableViewChats.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatCell")
        tableViewChats.translatesAutoresizingMaskIntoConstraints = false
        tableViewChats.estimatedRowHeight = 80
        tableViewChats.rowHeight = UITableView.automaticDimension
        self.addSubview(tableViewChats)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Profile picture constraints
            profilePic.widthAnchor.constraint(equalToConstant: 32),
            profilePic.heightAnchor.constraint(equalToConstant: 32),
            profilePic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            profilePic.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            // Label text constraints aligned with profile picture
            labelText.topAnchor.constraint(equalTo: profilePic.topAnchor),
            labelText.bottomAnchor.constraint(equalTo: profilePic.bottomAnchor),
            labelText.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 8),
            
            // Active chats label constraints
            activeChatsLabel.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 16),
            activeChatsLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            // Table view constraints for chats
            tableViewChats.topAnchor.constraint(equalTo: activeChatsLabel.bottomAnchor, constant: 8),
            tableViewChats.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewChats.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableViewChats.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            // Guidance label constraints
            guidanceLabel.topAnchor.constraint(equalTo: tableViewChats.bottomAnchor, constant: 16),
            guidanceLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            guidanceLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            guidanceLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
