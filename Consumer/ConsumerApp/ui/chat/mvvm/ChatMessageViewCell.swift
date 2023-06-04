//
//  ChatViewCell.swift
//  ConsumerApp
//
//  Created by Nikita on 12.05.2023.
//

import Foundation
import UIKit

class ChatMessageViewCell: UICollectionViewCell {
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    
    var textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = blueBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.image = #imageLiteral(resourceName: "subcategory_icon_4")
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var dateMessageLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.textColor = Color1.gray4
        lbl.font = Font.robotoLight12
        return lbl
    }()
    
    var checkMessageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "chat_check_message").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .blue
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textBubbleView)
        addSubview(dateMessageLabel)
        addSubview(checkMessageView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        textBubbleView.addSubview(bubbleImageView)
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: bubbleImageView)
        addConstraintsWithVisualStrings(format: "V:|[v0]|", views: bubbleImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
