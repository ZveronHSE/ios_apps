//
//  CardLotViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 19.05.2022.
//

import UIKit
import RxSwift
import LotGRPC
import ChatGRPC
import CoreGRPC
import ConsumerDomain
import Cosmos

class CardLotViewController: UIViewController {

    private let viewModel = ViewModelFactory.get(CardLotViewModel.self)
    private let disposeBag: DisposeBag = DisposeBag()
    private var isConfigured: Bool = false
    private var phoneNumber: String!

    private var imageLot: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 32
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    private var titleLot: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = Font.robotoMedium24
        label.textColor = Color1.black
        label.sizeToFit()
        return label
    }()

    private var imageGenderMan: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    private var imageGenderWoman: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    private var addressLot: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.sizeToFit()

        return label
    }()

    private var imageCountLikes: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "countLike")
        return imgView
    }()

    private var labelCountLikes: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.sizeToFit()
        return label
    }()

    private var imageCountWatches: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "countWatch")
        return imgView
    }()

    private var labelCountWatches: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.sizeToFit()
        return label
    }()


    private var titleDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.sizeToFit()
        label.text = "Описание"
        return label
    }()

    private var descriptionLot: UILabel = {
        let text = UILabel()
        text.numberOfLines = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 15)
        text.textColor = .black
        text.sizeToFit()
        return text
    }()
    
    private var viewProfile: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color1.gray2
        view.layer.cornerRadius = 24
        return view
    }()
    
    private let ratingUser: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.totalStars = 5
        view.settings.starSize = 20
        view.settings.fillMode = .half
        view.settings.starMargin = 3.5

        view.settings.filledImage = Icon.star
        view.settings.filledBorderColor = .clear
        view.settings.filledBorderWidth = 0

        view.settings.emptyImage = Icon.starEmpty
        view.settings.emptyBorderWidth = 0
        
        view.settings.emptyBorderColor = .clear

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var nameUser: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = Font.robotoMedium17
        label.textColor = Color1.black
        label.sizeToFit()
        return label
    }()
    
    private var imageUser: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = false
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 32
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .gray
        return imgView
    }()
    

    private var priceLot: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        label.textColor = .black
        label.sizeToFit()
        return label
    }()

    private var chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Написать", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()

    private var phoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Позвонить", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()

    private var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: UIScreen.main.bounds)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var lot: CardLot!
    private var profileInfo: ProfileInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bindView()
        viewModel.loadProfileInfo()
    }
    

    let navBtn = NavigationButton.close.button

    func layout() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)

        self.view.backgroundColor = Color1.background
        view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        scrollView.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        self.contentView.addSubview(imageLot)
        imageLot.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        imageLot.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        imageLot.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageLot.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        imageLot.heightAnchor.constraint(equalTo: self.imageLot.widthAnchor).isActive = true

        self.contentView.addSubview(imageGenderWoman)
        imageGenderWoman.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        imageGenderWoman.topAnchor.constraint(equalTo: self.imageLot.bottomAnchor, constant: 24).isActive = true
        imageGenderWoman.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageGenderWoman.widthAnchor.constraint(equalToConstant: 24).isActive = true

        self.contentView.addSubview(imageGenderMan)
        imageGenderMan.rightAnchor.constraint(equalTo: self.imageGenderWoman.leftAnchor, constant: -8).isActive = true
        imageGenderMan.topAnchor.constraint(equalTo: self.imageLot.bottomAnchor, constant: 24).isActive = true
        imageGenderMan.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageGenderMan.widthAnchor.constraint(equalToConstant: 24).isActive = true

        self.contentView.addSubview(titleLot)
        titleLot.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        titleLot.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -88).isActive = true
        titleLot.topAnchor.constraint(equalTo: self.imageLot.bottomAnchor, constant: 24).isActive = true

        self.contentView.addSubview(addressLot)
        addressLot.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        addressLot.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        addressLot.topAnchor.constraint(equalTo: self.titleLot.bottomAnchor, constant: 8).isActive = true

        self.contentView.addSubview(imageCountLikes)
        imageCountLikes.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        imageCountLikes.topAnchor.constraint(equalTo: self.addressLot.bottomAnchor, constant: 19).isActive = true
        imageCountLikes.heightAnchor.constraint(equalToConstant: 14).isActive = true
        imageCountLikes.widthAnchor.constraint(equalToConstant: 15).isActive = true

        self.contentView.addSubview(labelCountLikes)
        labelCountLikes.leftAnchor.constraint(equalTo: self.imageCountLikes.rightAnchor, constant: 3).isActive = true
        labelCountLikes.topAnchor.constraint(equalTo: self.addressLot.bottomAnchor, constant: 19).isActive = true

        self.contentView.addSubview(imageCountWatches)
        imageCountWatches.leftAnchor.constraint(equalTo: self.labelCountLikes.rightAnchor, constant: 10).isActive = true
        imageCountWatches.topAnchor.constraint(equalTo: self.addressLot.bottomAnchor, constant: 19).isActive = true
        imageCountWatches.heightAnchor.constraint(equalToConstant: 14).isActive = true
        imageCountWatches.widthAnchor.constraint(equalToConstant: 15).isActive = true

        self.contentView.addSubview(labelCountWatches)
        labelCountWatches.leftAnchor.constraint(equalTo: self.imageCountWatches.rightAnchor, constant: 3).isActive = true
        labelCountWatches.topAnchor.constraint(equalTo: self.addressLot.bottomAnchor, constant: 19).isActive = true

        self.contentView.addSubview(titleDescription)
        titleDescription.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        titleDescription.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        titleDescription.topAnchor.constraint(equalTo: self.imageCountLikes.bottomAnchor, constant: 8).isActive = true

        self.contentView.addSubview(descriptionLot)
        descriptionLot.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        descriptionLot.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        descriptionLot.topAnchor.constraint(equalTo: self.titleDescription.bottomAnchor, constant: 8).isActive = true

        
        self.contentView.addSubview(viewProfile)
        viewProfile.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        viewProfile.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        viewProfile.topAnchor.constraint(equalTo: self.descriptionLot.bottomAnchor, constant: 20).isActive = true
        viewProfile.heightAnchor.constraint(equalToConstant: 95).isActive = true
        
        self.contentView.addSubview(imageUser)
        imageUser.leftAnchor.constraint(equalTo: self.viewProfile.leftAnchor, constant: 16).isActive = true
        imageUser.topAnchor.constraint(equalTo: self.viewProfile.topAnchor, constant: 16).isActive = true
        imageUser.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageUser.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        self.contentView.addSubview(nameUser)
        nameUser.leftAnchor.constraint(equalTo: self.imageUser.rightAnchor, constant: 8).isActive = true
        nameUser.topAnchor.constraint(equalTo: self.viewProfile.topAnchor, constant: 25).isActive = true
        nameUser.rightAnchor.constraint(equalTo: self.viewProfile.rightAnchor, constant: -16).isActive = true
        
        self.contentView.addSubview(ratingUser)
        ratingUser.leftAnchor.constraint(equalTo: self.imageUser.rightAnchor, constant: 8).isActive = true
        ratingUser.topAnchor.constraint(equalTo: self.nameUser.bottomAnchor, constant: 5).isActive = true
        ratingUser.rightAnchor.constraint(equalTo: self.viewProfile.rightAnchor, constant: -16).isActive = true
        
        
        
        
        self.contentView.addSubview(priceLot)
        priceLot.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        priceLot.topAnchor.constraint(equalTo: self.viewProfile.bottomAnchor, constant: 20).isActive = true

        self.contentView.addSubview(phoneButton)
        phoneButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        phoneButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -35).isActive = true
        phoneButton.topAnchor.constraint(equalTo: self.priceLot.bottomAnchor, constant: 18).isActive = true
        phoneButton.heightAnchor.constraint(equalToConstant: 47).isActive = true
        phoneButton.widthAnchor.constraint(equalToConstant: 165).isActive = true

        self.contentView.addSubview(chatButton)
        chatButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        chatButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -35).isActive = true
        chatButton.topAnchor.constraint(equalTo: self.priceLot.bottomAnchor, constant: 18).isActive = true
        chatButton.heightAnchor.constraint(equalToConstant: 47).isActive = true
        chatButton.widthAnchor.constraint(equalToConstant: 165).isActive = true

    }

    private func bindView() {
        navBtn.rx.tap.bind(onNext: {
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)

        phoneButton.rx.tap.bind(onNext: {
            self.presentAlert(
                style: .actionSheet,
                actions: [
                    AlertButton(
                        title: "Вызов \(self.phoneNumber.niceFormatNumber())",
                        style: .default,
                        handler: { _ in self.callNumber() }
                    ),
                    AlertButton(
                        title: "Отменить",
                        style: .cancel,
                        handler: nil
                    )
                ]
            )
        }).disposed(by: disposeBag)
        
        chatButton.rx.tap.bind(onNext: {
            // нажатие на кнопку написать и переход к чату
            
            let tabbarVC = self.presentingViewController as! TabBarViewController
            let chatListVC = tabbarVC.viewControllers?.first(where: { $0.children.first is ChatListViewController }) as? UINavigationController
            
            tabbarVC.selectedViewController = chatListVC
            
            
            let messageVC = ChatMessageViewController()
            
            
            let seller =  self.lot.seller
            
//            let profileInfo = ProfileInfo(id: UInt64(seller.id), name: seller.name, surname: seller.surname, imageUrl: "seller.imageURL", rating: seller.rating, address: Address(region: "Москва", town: "Москва", longitude: 13, latitude: 13))
            
            let chat = ChatGRPC.Chat.with({
                $0.interlocutorSummary.id = UInt64(seller.id)
                $0.interlocutorSummary.name = seller.name
                $0.interlocutorSummary.surname = seller.surname
                $0.interlocutorSummary.imageURL = seller.imageURL
                $0.messages = []
                $0.lots = [CoreGRPC.Lot.with({
                    $0.id = self.lot.id
                })]
            })
            
            
            messageVC.setup(chat, self.profileInfo)
            messageVC.hidesBottomBarWhenPushed = true
            
            
            chatListVC?.pushViewController(messageVC, animated: false)
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.profileInfo
            .subscribe(onNext: {
                self.profileInfo = $0
            }).disposed(by: disposeBag)
        
        
    }

    func setup(with lot: CardLot) {
        self.lot = lot
        if isConfigured { return }
        isConfigured.toggle()
        self.phoneNumber = lot.contact.channelLink.phone
        self.titleLot.text = lot.title
        lot.photos.first.flatMap { self.imageLot.kf.setImage(with: URL(string: $0.url)) }
        self.descriptionLot.text = lot.description_p
        self.addressLot.text = lot.address.address
        self.priceLot.text = lot.price

        if lot.hasGender {
            self.imageGenderMan.setImageColor(color: lot.gender == .male ? Color1.orange2 : Color1.gray2)
            self.imageGenderWoman.setImageColor(color: lot.gender == .female ? Color1.orange2 : Color1.gray2)
        } else {
            print("Gender is null, but current view \(self.description) dont implemented logic by this")
        }

        lot.contact.communicationChannel.forEach { channel in
            switch channel {
            case .phone: phoneButton.enable()
            case .vk: fatalError("not implemented")
            case .email: fatalError("not implemented")
            case .chat: chatButton.enable()
            default: fatalError("unexpected channel type")
            }
        }

        self.labelCountLikes.text = String(lot.statistics.favorite)
        self.labelCountWatches.text = String(lot.statistics.view)
        let seller = lot.seller
        self.nameUser.text = seller.name + " " + seller.surname
        self.imageUser.kf.setImage(with: URL(string: seller.imageURL))
        // обратно вернуть когда бек сделает
        self.ratingUser.rating = 4.0//seller.rating
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chatButton.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
        phoneButton.applyGradient(.phoneButton, .horizontal, Corner.mainButton.rawValue)
    }

    private func callNumber() {
        guard let url = URL(string: "telprompt://\(self.phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
