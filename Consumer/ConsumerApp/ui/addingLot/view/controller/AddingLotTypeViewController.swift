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

class AddingLotTypeViewController: UIViewController {
    
    private var lot: CreateLot!
    let disposeBag: DisposeBag = DisposeBag()
    private var data: [TableInfo]!
    private var dataForNextVC: [TableInfo]!
    private let viewModel = ViewModelFactory.get(AddingLotTypeViewModel.self)
    
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
        label.text = "Вид объявления"
        return label
    }()
    let navBtn = NavigationButton.back.button
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        bindViews()
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
    
    func setup() {
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Создание объявления"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)
        viewModel.getChildren(categoryId: lot.category_id)
    }
    
    func bindViews() {
        navBtn.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        })
        
        viewModel.categories
            .subscribe(onNext: { categories in
                // TODO: прикрутить сюда еще imageURL $0.imageURL
                self.dataForNextVC = categories.map{TableInfo(title: $0.name, subtitle: nil, id: $0.id)}
            }).disposed(by: disposeBag)
    }
    
}

extension AddingLotTypeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dataRes: TableInfo
        dataRes = data[indexPath.row]
        lot.lot_form_id = dataRes.id!
        
        let vc =  CategoryTypeNestedViewController()
        vc.setUpData(data: dataForNextVC, lot: lot)
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

extension AddingLotTypeViewController: SetDataProtocol {
    public func setUpData(data: [TableInfo], lot: CreateLot) {
        self.data = data
        self.lot = lot
    }
}
