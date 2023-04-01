//
//  CategoryBreedsNestedViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 08.05.2022.
//

import UIKit
import RxSwift
import ZveronRemoteDataService
import ConsumerDomain
import ParameterGRPC

class ParametersViewController: UIViewController, UISearchBarDelegate {
    
    private var lot: CreateLot!
    
    private var data: [TableInfo] = []
    private var filteredData: [TableInfo] = []
    
    private var params: [ParameterGRPC.Parameter] = []
    private var currentParam : Parameter!
    
    
    let navBtn = NavigationButton.back.button
    let disposeBag: DisposeBag = DisposeBag()
    private let viewModel = ViewModelFactory.get(ParametersViewModel.self)
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.separatorStyle  = .none
        table.backgroundColor = Color.backgroundScreen.color
        table.showsVerticalScrollIndicator = false
        table.isScrollEnabled = true
        return table
    }()
    
    lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        s.searchResultsUpdater = self
        // чтобы взаимодействовать с отображаемым контентом для тапа по записям
        s.obscuresBackgroundDuringPresentation = false
        s.searchBar.placeholder = "Поиск по породам"
        s.searchBar.sizeToFit()
        s.searchBar.searchBarStyle = .prominent
        s.searchBar.delegate = self
        return s
    }()
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        bindViews()
    }
    
    // показывать searchBar по дефолту
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.isLoadedInfo.onNext(false)
        viewModel.getParameters(categoryId: lot.category_id, lotFormId: lot.lot_form_id)
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }

    // скрывать searchBar при прокрутке
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    public func setupLot(lot: CreateLot) {
        self.lot = lot
    }
    
    func setup() {
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Породы животных"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)
        navigationItem.searchController = searchController
    }
    
    func layout() {
        self.view.addSubview(tableView)
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func bindViews() {
        viewModel.params
            .subscribe(onNext: { parameters in
                self.params = parameters
                
                self.currentParam = parameters.first(where: { param in
                    param.name == "Порода" || param.name == "Вид"
                })!
                self.data = self.currentParam.values.map{TableInfo(title: $0, subtitle: nil, id: nil)}
                self.viewModel.isLoadedInfo.onNext(true)
            }).disposed(by: disposeBag)
        
        viewModel.isLoadedInfo
            .subscribe(onNext: { isLoadedInfo in
            if !isLoadedInfo {
                self.tableView.isHidden = true
                self.activityIndicator.show()
                self.activityIndicator.startAnimating()
            } else {
                self.tableView.isHidden = false
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hide()
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        navBtn.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    
}

extension ParametersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dataRes: TableInfo
        if !isFiltering {
            dataRes = data[indexPath.row]
        } else {
            dataRes = filteredData[indexPath.row]
        }
        lot.addParameters(key: currentParam.id, value: currentParam.values[indexPath.row])
        
        let dataForNextVC = [
            TableInfo(title: "Мужской", subtitle: nil, id: nil),
            TableInfo(title: "Женский", subtitle: nil, id: nil),
            TableInfo(title: "Метис", subtitle: "Родители разных пород", id: nil)
        ]
        let vc = AddingLotGenderViewController()
        vc.setupData(lot: lot, params: params, data: dataForNextVC)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = Color.backgroundScreen.color
        var dataRes: TableInfo
        
        if !isFiltering {
            dataRes = data[indexPath.row]
        } else {
            dataRes = filteredData[indexPath.row]
        }
        cell.textLabel?.text = dataRes.title
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.text = dataRes.subtitle
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredData.count
        }
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

extension ParametersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredData = data.filter { row in
            return row.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
}
