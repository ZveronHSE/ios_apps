//
//  ProfileViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 19.05.2022.
//

import UIKit
import ZveronRemoteDataService
import Cosmos
import RxSwift
import ZveronNetwork
import ConsumerDomain

class ProfileViewController: UIViewControllerWithAuth {
    
    private let viewModel = ViewModelFactory.get(ProfileViewModel.self)
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.backgroundScreen.color
        return view
    }()
    
    private var imageUser: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imgView.layer.masksToBounds = false
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = imgView.frame.height/2
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .gray
        return imgView
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    private var nameUser: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.sizeToFit()
        label.text = "Егор Шпак"
        return label
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
    
    
    private var editProfileBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Редактировать", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    private var feedbacksBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Мои отзывы", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        //button.isEnabled = false
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "profile_arrow"),for: .normal)
        button.imageView?.tintColor = Color1.orange3
        return button
    }()
    
    private var socialNetworksBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Социальные сети", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        //button.isEnabled = false
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "profile_arrow"),for: .normal)
        return button
    }()
    
    private var blackListBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Черный список", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        //button.isEnabled = false
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "profile_arrow"),for: .normal)
        return button
    }()
    
    private var exitProfileBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Выйти", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Corner.mainButton.rawValue
        return button
    }()
    
    private var deleteProfileBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить аккаунт", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    private var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let settingsBtn = NavigationButton.settings.button
    private let shareBtn = NavigationButton.share.button
    private var profileInfo: ProfileInfo!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bindViews()
        self.viewModel.isLoadedInfo.onNext(false)
        viewModel.loadProfileInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        exitProfileBtn.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
        let buttonWidth = feedbacksBtn.frame.width
        let imageWidth = feedbacksBtn.imageView!.frame.width
        feedbacksBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth - imageWidth - 30, bottom: 0, right: 0)
        socialNetworksBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth - imageWidth - 30, bottom: 0, right: 0)
        blackListBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth - imageWidth - 30, bottom: 0, right: 0)
    }
    
    // каждый раз при открытии экрана
    override func viewWillAppear(_ animated: Bool) {
        //viewModel.loadProfileInfo()
    }
    
    func layout() {
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Профиль"
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: settingsBtn), UIBarButtonItem(customView: shareBtn)]
        
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        containerView.addSubview(imageUser)
        imageUser.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        imageUser.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
        imageUser.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageUser.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        containerView.addSubview(nameUser)
        nameUser.leftAnchor.constraint(equalTo: imageUser.rightAnchor, constant: 16).isActive = true
        nameUser.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 43).isActive = true
        
        containerView.addSubview(ratingUser)
        ratingUser.leftAnchor.constraint(equalTo: imageUser.rightAnchor, constant: 16).isActive = true
        ratingUser.topAnchor.constraint(equalTo: nameUser.bottomAnchor, constant: 4).isActive = true
        ratingUser.heightAnchor.constraint(equalToConstant: 24).isActive = true
        ratingUser.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        containerView.addSubview(editProfileBtn)
        editProfileBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        editProfileBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        editProfileBtn.topAnchor.constraint(equalTo: imageUser.bottomAnchor, constant: 16).isActive = true
        editProfileBtn.heightAnchor.constraint(equalToConstant: 37).isActive = true
        
        
        containerView.addSubview(feedbacksBtn)
        feedbacksBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        feedbacksBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        feedbacksBtn.topAnchor.constraint(equalTo: editProfileBtn.bottomAnchor, constant: 32).isActive = true
        feedbacksBtn.heightAnchor.constraint(equalToConstant: 47).isActive = true
        
        containerView.addSubview(socialNetworksBtn)
        socialNetworksBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        socialNetworksBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        socialNetworksBtn.topAnchor.constraint(equalTo: feedbacksBtn.bottomAnchor, constant: 8).isActive = true
        socialNetworksBtn.heightAnchor.constraint(equalToConstant: 47).isActive = true
        
        containerView.addSubview(blackListBtn)
        blackListBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        blackListBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        blackListBtn.topAnchor.constraint(equalTo: socialNetworksBtn.bottomAnchor, constant: 8).isActive = true
        blackListBtn.heightAnchor.constraint(equalToConstant: 47).isActive = true
        
        
        containerView.addSubview(deleteProfileBtn)
        deleteProfileBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 100).isActive = true
        deleteProfileBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -100).isActive = true
        deleteProfileBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -113).isActive = true
        deleteProfileBtn.heightAnchor.constraint(equalToConstant: 19).isActive = true
        
        containerView.addSubview(exitProfileBtn)
        exitProfileBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        exitProfileBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        exitProfileBtn.bottomAnchor.constraint(equalTo: deleteProfileBtn.topAnchor, constant: -16).isActive = true
        exitProfileBtn.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func bindViews() {
        viewModel.profileInfo
          //  .distinctUntilChanged({ $0.id == $1.id && $0.name == $1.name})
            .subscribe(onNext: {
                print("SET INFO IN PROFILE")
                self.profileInfo = $0
                self.nameUser.text = $0.surname + " " + $0.name
                self.ratingUser.rating = $0.rating
                // TODO: Реализовать когда на беке появиться возможность получать фотки
                self.imageUser.kf.setImage(with: URL(string: "https://mirpozitiva.ru/wp-content/uploads/2019/11/1472042978_32.jpg"))
                self.viewModel.isLoadedInfo.onNext(true)
            }).disposed(by: disposeBag)
        
        
        viewModel.isLoadedInfo
//            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { isLoadedInfo in
            if !isLoadedInfo {
                self.containerView.isHidden = true
                self.activityIndicator.show()
                self.activityIndicator.startAnimating()
            } else {
                self.containerView.isHidden = false
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hide()
            }
        }).disposed(by: disposeBag)
        
        editProfileBtn.rx.tap.bind(onNext: {
            let vc = EditProfileViewController()
            vc.setup(with: self.profileInfo)
            self.navigationController?.pushViewController(vc, animated: true)
            vc.closure = { [weak self] info in
                self?.viewModel.isLoadedInfo.onNext(false)
                self?.viewModel.profileInfo.onNext(info)
            }    
        }).disposed(by: disposeBag)
        
        exitProfileBtn.rx.tap.bind(onNext: {
            TokenAcquisitionService.shared.cleanToken()
            self.tabBarController?.selectedIndex = 0
        }).disposed(by: disposeBag)
        
        deleteProfileBtn.rx.tap.bind(onNext: {
            TokenAcquisitionService.shared.cleanToken()
            self.tabBarController?.selectedIndex = 0
            self.viewModel.deleteProfile()
        }).disposed(by: disposeBag)
        
        
        shareBtn.rx.tap.bind(onNext: {
            // text to share
            let text = "zveron.ru/profile"
            
            // set up activity view controller
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
    }
    
}
