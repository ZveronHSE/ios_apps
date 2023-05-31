//
//  ServiceTypePicker.swift
//  ConsumerApp
//
//  Created by alexander on 22.05.2023.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import ConsumerDomain

protocol ServiceTypePickerDelegate {
    func picked(value: ServiceType)
}

class ServiceTypePickerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let reuseID = "cell"
    var delegate: ServiceTypePickerDelegate?
    let navBtn = NavigationButton.back.button

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseID)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Выберите услугу"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)
        layout()
        bindViews()
        tableView.reloadData()
    }

    private func layout() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func bindViews() {
        navBtn.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)

        tableView.rx.itemSelected.bind { index in
            let selectedServiceType = ServiceType.allCases[index.row]
            self.delegate?.picked(value: selectedServiceType)
            self.leftItemButtonAction()
        }.disposed(by: disposeBag)
    }

    @objc
    private func leftItemButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}


extension ServiceTypePickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServiceType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.text = ServiceType.allCases[indexPath.item].rawValue
        return cell
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            tableView.cellForRow(at: indexPath)?.plainView.alpha = 0.5
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            tableView.cellForRow(at: indexPath)?.plainView.alpha = 1.0
        }
    }
}
