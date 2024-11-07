//
//  ChatTableViewCell.swift
//  WA8_JIA_2313
//
//  Created by Xi Jia on 11/5/24.
//

//import UIKit
//
//class ChatTableViewCell: UITableViewCell {
//    
//    var wrapperCellView: UIView!
//    var labelName: UILabel!
//    var labelContent: UILabel!
//    var labelDateAndTime: UILabel!
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        setupWrapperCellView()
//        setupLabelName()
//        setupLabelContent()
//        setupLabelDateAndTime()
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
//    func setupLabelContent(){
//        labelContent = UILabel()
//        labelContent.font = UIFont.boldSystemFont(ofSize: 14)
//        labelContent.translatesAutoresizingMaskIntoConstraints = false
//        wrapperCellView.addSubview(labelContent)
//    }
//    
//    func setupLabelDateAndTime(){
//        labelDateAndTime = UILabel()
//        labelDateAndTime.font = UIFont.boldSystemFont(ofSize: 14)
//        labelDateAndTime.translatesAutoresizingMaskIntoConstraints = false
//        wrapperCellView.addSubview(labelDateAndTime)
//    }
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
//            labelContent.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 2),
//            labelContent.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
//            labelContent.heightAnchor.constraint(equalToConstant: 16),
//            labelContent.widthAnchor.constraint(lessThanOrEqualTo: labelName.widthAnchor),
//            
//            labelDateAndTime.topAnchor.constraint(equalTo: labelContent.bottomAnchor, constant: 2),
//            labelDateAndTime.leadingAnchor.constraint(equalTo: labelContent.leadingAnchor),
//            labelDateAndTime.heightAnchor.constraint(equalToConstant: 16),
//            labelDateAndTime.widthAnchor.constraint(lessThanOrEqualTo: labelName.widthAnchor),
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
//
//}
//import UIKit
//
//class ChatTableViewCell: UITableViewCell {
//    var senderNameLabel: UILabel!
//    var contentLabel: UILabel!
//    var dateTimeLabel: UILabel!
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        setupSenderNameLabel()
//        setupContentLabel()
//        setupDateTimeLabel()
//        initConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupSenderNameLabel() {
//        senderNameLabel = UILabel()
//        senderNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        senderNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(senderNameLabel)
//    }
//    
//    func setupContentLabel() {
//        contentLabel = UILabel()
//        contentLabel.font = UIFont.systemFont(ofSize: 14)
//        contentLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(contentLabel)
//    }
//    
//    func setupDateTimeLabel() {
//        dateTimeLabel = UILabel()
//        dateTimeLabel.font = UIFont.systemFont(ofSize: 12)
//        dateTimeLabel.textColor = .gray
//        dateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(dateTimeLabel)
//    }
//    
//    func initConstraints() {
//        NSLayoutConstraint.activate([
//            senderNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            senderNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            senderNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            
//            contentLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 4),
//            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            
//            dateTimeLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 4),
//            dateTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            dateTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            dateTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
//        ])
//    }
//    
//    func configure(with chatCell: ChatCell) {
//        senderNameLabel.text = chatCell.senderName
//        contentLabel.text = chatCell.content
//        dateTimeLabel.text = formatDate(timestamp: chatCell.dateAndTime)
//    }
//    
//    private func formatDate(timestamp: Int) -> String {
//        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
//        return dateFormatter.string(from: date)
//    }
//}

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
