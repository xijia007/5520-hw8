////
////  ContactTableViewCell.swift
////  WA8_JIA_2313
////
////  Created by Xi Jia on 11/5/24.
////
//
//import UIKit
//
//class ContactTableViewCell: UITableViewCell {
//    var wrapperCellView: UIView!
//    var labelName: UILabel!
//    var labelEmail: UILabel!
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        setupWrapperCellView()
//        setupLabelName()
//        setupLabelEmail()
//        
//        initConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupWrapperCellView(){
//        wrapperCellView = UITableViewCell()
//        
//        //working with the shadows and colors...
//        wrapperCellView.backgroundColor = .white
//        wrapperCellView.layer.cornerRadius = 6.0
//        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
//        wrapperCellView.layer.shadowOffset = .zero
//        wrapperCellView.layer.shadowRadius = 4.0
//        wrapperCellView.layer.shadowOpacity = 0.4
//        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(wrapperCellView)
//    }
//    
//    func setupLabelName(){
//        labelName = UILabel()
//        labelName.font = UIFont.boldSystemFont(ofSize: 20)
//        labelName.translatesAutoresizingMaskIntoConstraints = false
//        wrapperCellView.addSubview(labelName)
//    }
//    
//    func setupLabelEmail(){
//        labelEmail = UILabel()
//        labelEmail.font = UIFont.boldSystemFont(ofSize: 14)
//        labelEmail.translatesAutoresizingMaskIntoConstraints = false
//        wrapperCellView.addSubview(labelEmail)
//    }
//    
//    
//    func initConstraints(){
//        NSLayoutConstraint.activate([
//            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
//            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
//            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
//            
//            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
//            labelName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
//            labelName.heightAnchor.constraint(equalToConstant: 20),
//            labelName.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
//            
//            labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 2),
//            labelEmail.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
//            labelEmail.heightAnchor.constraint(equalToConstant: 16),
//            labelEmail.widthAnchor.constraint(lessThanOrEqualTo: labelName.widthAnchor),
//            
//            wrapperCellView.heightAnchor.constraint(equalToConstant: 72)
//        ])
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//}
//import UIKit
//
//class ContactTableViewCell: UITableViewCell {
//    
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let emailLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        label.textColor = .gray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupViews() {
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(emailLabel)
//        
//        NSLayoutConstraint.activate([
//            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            
//            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
//            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            emailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
//        ])
//    }
//    
//    func configure(with contact: Contact) {
//        nameLabel.text = contact.name
//        emailLabel.text = contact.email
//    }
//}

//import UIKit
//
//class ContactTableViewCell: UITableViewCell {
//    
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let emailLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        label.textColor = .gray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupViews() {
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(emailLabel)
//        
//        NSLayoutConstraint.activate([
//            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            
//            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
//            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            emailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
//        ])
//    }
//    
//    func configure(with contact: Contact) {
//        nameLabel.text = contact.name
//        emailLabel.text = contact.email
//    }
//}
//import UIKit
//
//class ContactTableViewCell: UITableViewCell {
//    var nameLabel: UILabel!
//    var emailLabel: UILabel!
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        setupNameLabel()
//        setupEmailLabel()
//        initConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: initializing the UI elements...
//    func setupNameLabel() {
//        nameLabel = UILabel()
//        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(nameLabel)
//    }
//    
//    func setupEmailLabel() {
//        emailLabel = UILabel()
//        emailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        emailLabel.textColor = .gray
//        emailLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(emailLabel)
//    }
//    
//    //MARK: setting up constraints...
//    func initConstraints() {
//        NSLayoutConstraint.activate([
//            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            
//            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
//            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            emailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
//        ])
//    }
//    
//    func configure(with contact: Contact) {
//        nameLabel.text = contact.name
//        emailLabel.text = contact.email
//    }
//}

//import UIKit
//
//class ContactTableViewCell: UITableViewCell {
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configure(with contact: Contact) {
//        textLabel?.text = contact.name
//        detailTextLabel?.text = contact.email
//    }
//}
import UIKit

class ContactTableViewCell: UITableViewCell {
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupNameLabel()
        setupEmailLabel()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: initializing the UI elements...
    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
    }
    
    func setupEmailLabel() {
        emailLabel = UILabel()
        emailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        emailLabel.textColor = .gray
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailLabel)
    }
    
    //MARK: setting up constraints...
    func initConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with contact: Contact) {
        nameLabel.text = contact.name
        emailLabel.text = contact.email
    }
}
