//
//  BottomViewController.swift
//  iosapp
//
//  Created by alexander on 04.03.2022.
//

import UIKit
import RxSwift
import BottomSheet
import Foundation
import ZveronRemoteDataService
import AuthGRPC

class MainAuthViewController: UIViewController {

    var delegate: AuthPickerDelegate?

    // MARK: Outlets
    @IBOutlet weak var signInByPhoneButton: UIButton!
    @IBOutlet weak var signInByGoogleButton: UIButton!
    @IBOutlet weak var signInByAppleButton: UIButton!
    @IBOutlet weak var signInByVkButton: UIButton!
    @IBOutlet weak var signInByMailButton: UIButton!


    // MARK: Processed Properties
    let disposeBag = DisposeBag()
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        configureScreen()
    }
    
    private func bindViews() {
        // Обработка нажатия на кнопку авторизации через гугл
        signInByGoogleButton.rx.tap.subscribe { _ in
            self.delegate?.didClickExternalAuth(provider: .gmail)
        }.disposed(by: disposeBag)
        
        // Обработка нажатия на кнопку авторизации через вк
        signInByVkButton.rx.tap.subscribe { _ in
            self.delegate?.didClickExternalAuth(provider: .vk)
        }.disposed(by: disposeBag)

        signInByMailButton.rx.tap.subscribe { _ in
            self.delegate?.didClickExternalAuth(provider: .mailRu)
        }.disposed(by: disposeBag)

        signInByAppleButton.rx.tap.subscribe { _ in
            self.delegate?.didClickExternalAuth(provider: .apple)
        }.disposed(by: disposeBag)
        
        // Обработка нажатия на кнопку авторизации по номеру телефона
        signInByPhoneButton.rx.tap.subscribe { _ in
            self.delegate?.didClickAuthByPhone()
        }.disposed(by: disposeBag)
    }
    
    private func configureScreen() {
        view.backgroundColor = Color.backgroundScreen.color
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: view.bounds.height)
        signInByPhoneButton.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
        signInByPhoneButton.layer.cornerRadius = Corner.mainButton.rawValue
    }
}

protocol AuthPickerDelegate {
    func didClickExternalAuth(provider: AuthProvider)
    func didClickAuthByPhone()
}
