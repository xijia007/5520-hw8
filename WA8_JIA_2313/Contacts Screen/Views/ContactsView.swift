//
//  ContactsView.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/5/24.
//

//import UIKit
//
//class ContactsView: UIView {
//
//    var tableViewContacts: UITableView!
//    var labelText: UILabel!
//    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        self.backgroundColor = .white
//
//        setupTableViewContacts()
//        setupLabelText()
//        initConstraints()
//    }
//    
//    func setupLabelText(){
//        labelText = UILabel()
//        labelText.font = .boldSystemFont(ofSize: 14)
//        labelText.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(labelText)
//    }
//    
//    func setupTableViewContacts() {
//        tableViewContacts = UITableView()
//        tableViewContacts.register(ContactTableViewCell.self, forCellReuseIdentifier: Configs.tableViewContactsID)
//        tableViewContacts.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(tableViewContacts)
//    }
//
//    
//    func initConstraints(){
//        NSLayoutConstraint.activate([
//            
//            labelText.topAnchor.constraint(equalTo: self.topAnchor),
//            labelText.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            labelText.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8),
//            
//            tableViewContacts.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 8),
//            tableViewContacts.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
//            tableViewContacts.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            tableViewContacts.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            
//            
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}

//import SwiftUI
//
//struct ContactsView: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> ContactsViewController {
//        return ContactsViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: ContactsViewController, context: Context) {
//        // Update the view controller if needed
//    }
//}

//import UIKit
//
//class ContactsView: UIView {
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Contacts"
//        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
//        label.textColor = .darkText
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let separatorLine: UIView = {
//        let view = UIView()
//        view.backgroundColor = .lightGray
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupViews() {
//        backgroundColor = .white
//        
//        addSubview(titleLabel)
//        addSubview(separatorLine)
//        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            
//            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
//            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
//            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
//            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
//        ])
//    }
//}
