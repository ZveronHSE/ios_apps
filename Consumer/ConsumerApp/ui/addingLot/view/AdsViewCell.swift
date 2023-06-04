//
//  AdsViewCell.swift
//  ConsumerApp
//
//  Created by Nikita on 31.05.2023.
//

import Foundation
import UIKit

class AdsViewCell: UICollectionViewCell {
    
    var imageLot: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = false
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .gray
        return imgView
    }()
    
    var statusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.backgroundColor = .gray
        return view
    }()
    
    var statusLotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = Font.robotoLight12
        label.textColor = Color1.black
        label.sizeToFit()
        return label
    }()
    
    var priceLotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = Font.robotoSemiBold18
        label.textColor = Color1.black
        label.sizeToFit()
        return label
    }()
    
    var titleLotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = Font.robotoLight14
        label.textColor = Color1.black
        label.sizeToFit()
        return label
    }()
    
    
    
    var imageCountLikes: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "countLike_gray")
        return imgView
    }()

    var labelCountLikes: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = Font.robotoLight10
        label.textColor = Color1.gray4
        label.sizeToFit()
        return label
    }()

    var imageCountWatches: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "countWatch_gray")
        return imgView
    }()

    var labelCountWatches: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = Font.robotoLight10
        label.textColor = Color1.gray4
        label.sizeToFit()
        return label
    }()
    
    var labelLotDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = Font.robotoLight12
        label.textColor = Color1.gray4
        label.sizeToFit()
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        contentView.addSubview(imageLot)
        imageLot.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageLot.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageLot.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageLot.widthAnchor.constraint(equalToConstant: 115).isActive = true
        
        contentView.addSubview(statusView)
        statusView.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8).isActive = true
        statusView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        statusView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        
        contentView.addSubview(statusLotLabel)
        statusLotLabel.leftAnchor.constraint(equalTo: statusView.rightAnchor, constant: 4).isActive = true
        statusLotLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor).isActive = true
        statusLotLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        
        contentView.addSubview(priceLotLabel)
        priceLotLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8).isActive = true
        priceLotLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        priceLotLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
       
        
        contentView.addSubview(titleLotLabel)
        titleLotLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8).isActive = true
        titleLotLabel.topAnchor.constraint(equalTo: priceLotLabel.bottomAnchor, constant: 2).isActive = true
        titleLotLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        
        contentView.addSubview(labelLotDate)
        labelLotDate.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8).isActive = true
        labelLotDate.topAnchor.constraint(equalTo: titleLotLabel.bottomAnchor, constant: 10).isActive = true
        labelLotDate.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        
//        contentView.addSubview(imageCountLikes)
//        imageCountLikes.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8).isActive = true
//        imageCountLikes.topAnchor.constraint(equalTo: titleLotLabel.bottomAnchor, constant: 10).isActive = true
//        imageCountLikes.heightAnchor.constraint(equalToConstant: 9).isActive = true
//        imageCountLikes.widthAnchor.constraint(equalToConstant: 10).isActive = true
//
//
//        self.contentView.addSubview(labelCountLikes)
//        labelCountLikes.leftAnchor.constraint(equalTo: self.imageCountLikes.rightAnchor, constant: 3).isActive = true
//        labelCountLikes.centerYAnchor.constraint(equalTo: imageCountLikes.centerYAnchor).isActive = true
//
//
//        self.contentView.addSubview(imageCountWatches)
//        imageCountWatches.leftAnchor.constraint(equalTo: self.labelCountLikes.rightAnchor, constant: 10).isActive = true
//        imageCountWatches.centerYAnchor.constraint(equalTo: imageCountLikes.centerYAnchor).isActive = true
//        imageCountWatches.heightAnchor.constraint(equalToConstant: 9).isActive = true
//        imageCountWatches.widthAnchor.constraint(equalToConstant: 10).isActive = true
//
//        self.contentView.addSubview(labelCountWatches)
//        labelCountWatches.leftAnchor.constraint(equalTo: self.imageCountWatches.rightAnchor, constant: 3).isActive = true
//        labelCountWatches.centerYAnchor.constraint(equalTo: imageCountLikes.centerYAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
