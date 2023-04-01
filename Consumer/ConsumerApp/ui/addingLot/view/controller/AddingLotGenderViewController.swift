//
//  AddingLotGenderViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 09.05.2022.
//

//
//  LotTableViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 07.05.2022.
//

import UIKit
import ZveronRemoteDataService
import RxSwift
import RxRelay
import ConsumerDomain
import ParameterGRPC

class AddingLotGenderViewController: UIViewController {
    
    private var lot: CreateLot!
    
    private var data: [TableInfo]!
    
    private var params: [ParameterGRPC.Parameter]!
    private var currentParam : Parameter!
    
    
    let navBtn = NavigationButton.back.button
    let disposeBag: DisposeBag = DisposeBag()
    
    
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.separatorStyle  = .none
        table.backgroundColor = Color.backgroundScreen.color
        table.showsVerticalScrollIndicator = false
        table.isScrollEnabled = false
        return table
    }()
    
    lazy var titleTable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        label.textColor = .black
        label.sizeToFit()
        label.text = "Укажите пол"
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        bindViews()
    }
    
    public func setupData(lot: CreateLot, params: [ParameterGRPC.Parameter], data: [TableInfo]) {
        self.lot = lot
        self.params = params
        self.data = data
    }
    
    func setup() {
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Создание объявления"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)
    }
    
    func layout() {
        self.view.addSubview(titleTable)
        titleTable.translatesAutoresizingMaskIntoConstraints = false
        titleTable.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        titleTable.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        titleTable.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 15).isActive = true
        
        self.view.addSubview(tableView)
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.titleTable.bottomAnchor, constant: 15).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func bindViews() {
        
        
        navBtn.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        })
    }
}

extension AddingLotGenderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gender = Gender(rawValue: indexPath.row)
        lot.gender = gender
        
        let vc = AddingLotDescriptionViewController()
        vc.setupData(lot: lot, params: params)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = Color.backgroundScreen.color
        var dataRes: TableInfo
        dataRes = data[indexPath.row]
        cell.textLabel?.text = dataRes.title
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.text = dataRes.subtitle
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView( _ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            tableView.cellForRow(at: indexPath)?.plainView.alpha = 0.5
        }
    }
    
    func tableView( _ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            tableView.cellForRow(at: indexPath)?.plainView.alpha = 1.0
        }
    }
}
