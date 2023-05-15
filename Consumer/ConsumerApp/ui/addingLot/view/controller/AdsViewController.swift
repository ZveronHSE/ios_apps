//
//  AdsViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 28.04.2022.
//

import UIKit
import BottomSheet
import RxSwift

class AdsViewController: UIViewController {
    private let viewModel = ViewModelFactory.get(AdsViewModel.self)
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bindViews()
    }
    
    private let addLotBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func bindViews() {
        addLotBtn.rx.tap.subscribe { _ in
            let addingLotVC = ControllerFactory.get(AddingLotViewController.self)
            let navAddingLotVC = UINavigationController(rootViewController: addingLotVC)
            navAddingLotVC.modalPresentationStyle = .fullScreen
            self.present(navAddingLotVC, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
    }
    
    func setUp() {
        addLotBtn.layer.cornerRadius = Corner.mainButton.rawValue
        addLotBtn.setTitle("Добавить объявление", for: .normal)
        addLotBtn.contentHorizontalAlignment = .center
        addLotBtn.setTitleColor(.white, for: .normal)
       // self.view.backgroundColor = Color.backgroundScreen.color
        view.addSubview(addLotBtn)

        addLotBtn.heightAnchor.constraint(equalToConstant: 52).isActive = true
        addLotBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16).isActive = true
        addLotBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        addLotBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        addLotBtn.layoutIfNeeded()
        addLotBtn.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
    }
}
