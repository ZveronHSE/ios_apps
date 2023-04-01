//
//  OrderCardViewController.swift
//  specialist
//
//  Created by alexander on 29.03.2023.
//

import Foundation
import UIKit
import SpecialistDomain

final class OrderCardViewController: UIViewController {

    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIButton(type: .system)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.setImage(.zvClose, for: .normal)
        closeButton.tintColor = .zvBlack
        return UIBarButtonItem(customView: closeButton)
    }()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        // view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Показать объявления", for: .normal)
        button.titleLabel?.font = .zvRegularSubheadline
        button.backgroundColor = .zvRedMain
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .zvBackground
        navigationItem.title = "Cтрижка кота"
        navigationItem.leftBarButtonItem = closeButton
        layoutScrollView()
        layoutContentView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    private func layoutScrollView() {
       // let _ = UIEdgeInsets(top: 60, left: 16, bottom: 0, right: -16)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(continueButton)

        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        continueButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        continueButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }

    private func layoutContentView() {

    }

    public func setup(with model: Order) {

    }

    @objc
    private func close() {
        self.dismiss(animated: true)
    }
}
