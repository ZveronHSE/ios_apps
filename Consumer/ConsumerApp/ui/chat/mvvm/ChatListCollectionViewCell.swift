//
//  ChatListTableViewCell.swift
//  ConsumerApp
//
//  Created by Nikita on 22.04.2023.
//

import Foundation
import UIKit

class ChatListCollectionViewCell: UICollectionViewCell {
    
    var imageUser: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        imgView.layer.masksToBounds = false
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = imgView.frame.height/2
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .gray
        imgView.layer.borderWidth = 2
        imgView.layer.borderColor = UIColor.white.cgColor
        return imgView
    }()
    
    var imageLot: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = false
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .gray
        return imgView
    }()
    
    var userLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = Font.robotoSemiBold12
        label.textColor = Color1.black
        label.sizeToFit()
        return label
    }()
    
    var lotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = Font.robotoRegular12
        label.textColor = Color1.gray3
        label.sizeToFit()
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = Font.robotoRegular12
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Font.robotoRegular12
        label.textColor = Color1.gray2
        label.sizeToFit()
        return label
    }()
    
    var countMessagesLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Font.robotoRegular10
        label.textColor = Color1.black
        label.layer.masksToBounds = true
        label.layer.cornerRadius = label.frame.height/2
        return label
    }()
    
    var viewTest: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = view.frame.height/2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        contentView.addSubview(imageLot)
        imageLot.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageLot.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageLot.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageLot.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        contentView.addSubview(imageUser)
        imageUser.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: -2).isActive = true
        imageUser.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -2).isActive = true
        imageUser.widthAnchor.constraint(equalToConstant: 26).isActive = true
        imageUser.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        contentView.addSubview(userLabel)
        userLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 6).isActive = true
        userLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
        userLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        
        contentView.addSubview(lotLabel)
        lotLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 6).isActive = true
        lotLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 6).isActive = true
        lotLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        
        contentView.addSubview(messageLabel)
        messageLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 6).isActive = true
        messageLabel.topAnchor.constraint(equalTo: lotLabel.bottomAnchor, constant: 8).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        
        contentView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -6).isActive = true
        
        contentView.addSubview(viewTest)
        viewTest.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6).isActive = true
        viewTest.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -6).isActive = true
        viewTest.widthAnchor.constraint(equalToConstant: 18).isActive = true
        viewTest.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        contentView.addSubview(countMessagesLabel)
        countMessagesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6).isActive = true
        countMessagesLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -6).isActive = true
        countMessagesLabel.widthAnchor.constraint(equalToConstant: 18).isActive = true
        countMessagesLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewTest.layoutIfNeeded()
        viewTest.applyGradient(.mainButton, .horizontal)
    }
    
    
}
