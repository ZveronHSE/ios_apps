//
//  FilterViewController.swift
//  iosapp
//
//  Created by alexander on 03.05.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import ParameterGRPC

class FilterViewController: UIViewController {
    private var keyboardDismissTabGesture: UITapGestureRecognizer?

    // MARK: Properties
    let viewModel = ViewModelFactory.get(FilterViewModel.self)
    var delegate: FilterViewDelegate?
    // MARK: Processed Properties
    private var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }

    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIButton(type: .system)
        let closeIcon = #imageLiteral(resourceName: "close_icon")
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.setImage(closeIcon, for: .normal)
        closeButton.tintColor = .black
        return UIBarButtonItem(customView: closeButton)
    }()

    private var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Показать объявления", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var presentSection: PresentSection = {
        let view = PresentSection()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var categorySection: CategorySection = {
        let view = CategorySection()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var lotTypeSection: LotTypeSection = {
        let view = LotTypeSection()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var parametersSection: SubCategoryWithParametersSection = {
        let view = SubCategoryWithParametersSection()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var priceSection: PriceSection = {
        let view = PriceSection()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var sortingSection: SortingSection = {
        let view = SortingSection()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var statusBar: UIView = {
        let statusBar = UIView()
        let height = UIApplication.shared.statusBarFrame.height
        statusBar.frame = CGRect(x: 0, y: -height, width: view.frame.width, height: height)
        statusBar.backgroundColor = .white
        return statusBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        configureContentView()
        bindViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeKeyboardNotifications()
        super.viewDidDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presentSection.updatePresentationStyle()
        categorySection.updatePresentationStyle()
        sortingSection.updatePresentationStyle()
        continueButton.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
    }

    private func configureContentView() {
        contentView.addSubview(presentSection)
        presentSection.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        presentSection.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        presentSection.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        presentSection.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        presentSection.heightAnchor.constraint(equalToConstant: 60).isActive = true

        contentView.addSubview(categorySection)
        categorySection.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        categorySection.topAnchor.constraint(equalTo: presentSection.bottomAnchor, constant: 8).isActive = true
        categorySection.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        categorySection.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        categorySection.heightAnchor.constraint(equalToConstant: 100).isActive = true

        contentView.addSubview(lotTypeSection)
        lotTypeSection.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        let lotTypeTop = lotTypeSection.topAnchor.constraint(equalTo: categorySection.bottomAnchor, constant: 8)
        lotTypeTop.isActive = true
        lotTypeSection.leftAnchor.constraint(equalTo: categorySection.leftAnchor).isActive = true
        lotTypeSection.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        let lotTypeHeight = lotTypeSection.heightAnchor.constraint(equalToConstant: 100)
        lotTypeHeight.isActive = true


        contentView.addSubview(parametersSection)
        parametersSection.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        let parametersTop = parametersSection.topAnchor.constraint(equalTo: lotTypeSection.bottomAnchor, constant: 8)
        parametersTop.isActive = true
        parametersSection.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        parametersSection.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        let parametersHeight = parametersSection.heightAnchor.constraint(equalToConstant: 300)
        parametersHeight.isActive = true
        viewModel.parametersSectionHeight.bind {
            parametersHeight.constant = $0 == 0.0 ? 0.0: $0 + 24.0
            parametersTop.constant = $0 == 0.0 ? 0.0 : 8.0
            lotTypeTop.constant = $0 == 0.0 ? 0.0 : 8
            lotTypeHeight.constant = $0 == 0.0 ? 0.0 : CellHeight.filterCellTextPicker.height + 24
        }.disposed(by: disposeBag)

        contentView.addSubview(priceSection)
        priceSection.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        priceSection.topAnchor.constraint(equalTo: parametersSection.bottomAnchor, constant: 8).isActive = true
        priceSection.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        priceSection.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        priceSection.heightAnchor.constraint(equalToConstant: 160).isActive = true

        contentView.addSubview(sortingSection)
        sortingSection.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        sortingSection.topAnchor.constraint(equalTo: priceSection.bottomAnchor, constant: 8).isActive = true
        sortingSection.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        sortingSection.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sortingSection.heightAnchor.constraint(equalToConstant: 47.0 * CGFloat(SortingType.allCases.count)).isActive = true
        sortingSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
    }

    private func configureScrollView() {
        view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Фильтр"
        navigationItem.leftBarButtonItem = closeButton
        // navigationController?.navigationBar.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        scrollView.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        let margin = view.layoutMarginsGuide
        view.addSubview(continueButton)
        continueButton.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        continueButton.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 52).isActive = true

    }

    private func bindViews() {
        presentSection.bindViews(viewModel)
        categorySection.bindViews(viewModel)
        lotTypeSection.bindViews(viewModel)
        parametersSection.bindViews(viewModel)
        priceSection.bindViews(viewModel)
        sortingSection.bindViews(viewModel)

        continueButton.rx.tap.bind { _ in
            // все параметры что не селектабле и из них надо таким способом доставать данные

            let notStringParametersIdx = self.viewModel.parameters.value.enumerated().filter { $0.element.type == .date }.map { $0.offset }

            notStringParametersIdx.forEach { idx in
                guard let cell = self.parametersSection.tableView.cellForRow(at: IndexPath(row: idx, section: 0)) as? FilterCellDatePicker else { return }
                let minDate = cell.polsunok.selectedMinValue
                let maxDate = cell.polsunok.selectedMaxValue
                //обновить параметр на дату
            }

            let newFilter = FilterModel(
                sortingType: self.viewModel.sortingMode.value!,
                category: self.viewModel.selectedCategory.value,
                lotKind: self.viewModel.selectedLotKind.value,
                subCategory: self.viewModel.selectedSubCategory.value,
                parameters: self.viewModel.parameters.value,
                minPrice: self.viewModel.minimumPrice.value,
                maxPrice: self.viewModel.maximumPrice.value
            )

            self.delegate?.willFinish(
                presentMode: self.viewModel.presentationMode.value,
                filter: newFilter
            )
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)

        viewModel.needPresentPickerForSubCategory.bind { subcategories in
            let toVC = SinglePickerViewController(isBackButton: true)
            toVC.setup(
                topic: self.viewModel.selectedCategory.value!.name,
                categories: subcategories
            )
            toVC.delegate = self
            self.statusBar.backgroundColor = Color.backgroundScreen.color
            self.navigationController?.pushViewController(toVC, animated: true)
        }.disposed(by: disposeBag)

        viewModel.needPresentPickerForParameter.bind(onNext: { parameter in
            let toVC = MultiPickerViewController(isBackButton: true)
            toVC.setup(parameter: parameter)
            toVC.delegate = self
            self.statusBar.backgroundColor = Color.backgroundScreen.color
            self.navigationController?.pushViewController(toVC, animated: true)
        }).disposed(by: disposeBag)

        viewModel.needPresentPickerForLotType.bind {
            let toVC = SinglePickerViewController(isBackButton: true)
            toVC.setup(
                topic: "Тип объявления",
                lotForm: $0
            )
            toVC.delegate = self
            self.statusBar.backgroundColor = Color.backgroundScreen.color
            self.navigationController?.pushViewController(toVC, animated: true)
        }.disposed(by: disposeBag)
    }

    func setup(presentMode: PresentModeType, filter: FilterModel) {
        viewModel.selectedCategory.accept(filter.category)
        viewModel.selectedLotKind.accept(filter.lotKind)
        viewModel.parameters.accept(filter.parameters)
        viewModel.selectedSubCategory.accept(filter.subCategory)
        viewModel.minimumPrice.accept(filter.minPrice)
        viewModel.maximumPrice.accept(filter.maxPrice)
        viewModel.sortingMode.accept(filter.sortingType)
        viewModel.presentationMode.accept(presentMode)
    }

    @objc
    private func close() {
        dismiss(animated: true)
    }

}

class LotTypeSection: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var sectionContent: FilterCellTextPicker = {

        let content = FilterCellTextPicker()
        content.label.text = "Тип объявления"
        content.label.alpha = 0.5
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()

    private func configureSection() {
        addSubview(sectionContent)

        sectionContent.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        sectionContent.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        sectionContent.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        sectionContent.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
    }

    func bindViews(_ viewModel: FilterViewModel) {
        viewModel.selectedLotKind.map { $0?.name }.bind {
            let isNull = $0 == nil
            self.sectionContent.label.text = isNull ? "Тип объявления": $0!
            self.sectionContent.label.alpha = isNull ? 0.5 : 1.0
        }.disposed(by: viewModel.disposeBag)

        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        sectionContent.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind { _ in
            viewModel.selectedLotType()
        }.disposed(by: viewModel.disposeBag)
    }
}

extension FilterViewController: SinglePickerDelegate {
    func willFinish(lotForm: ParameterGRPC.LotForm) {
        guard viewModel.selectedLotKind.value?.id != lotForm.id else { return }
        viewModel.selectedLotKind.accept(lotForm)
    }

    func willFinish(subCategory: ParameterGRPC.Category) {
        guard viewModel.selectedSubCategory.value?.id != subCategory.id else { return }
        viewModel.selectedSubCategory.accept(subCategory)
    }
}

extension FilterViewController: MultiPickerDelegate {
    func willFinish(parameter: LotParameter) {
        var oldParameters = viewModel.parameters.value
        let index = oldParameters.firstIndex(where: { $0.name == parameter.name })!
        oldParameters.remove(at: index)
        oldParameters.insert(parameter, at: index)
        viewModel.parameters.accept(oldParameters)
    }
}

class PresentSection: UIView {
    var presentMode: PresentModeType? {
        didSet {
            guard oldValue != presentMode else { return }
            updatePresentationStyle()
        }
    }

    func updatePresentationStyle() {
        let isGridSelected = presentMode == .grid
        gridButton.tintColor = isGridSelected ? .orange : .gray
        tableButton.tintColor = !isGridSelected ? .orange : .gray
//        updateGradientLayer(elem: gridButton.imageView!, isGradient: isGridSelected)
//        updateGradientLayer(elem: tableButton.imageView!, isGradient: !isGridSelected)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Вид объявлений"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var gridButton: UIButton = {
        let icon = #imageLiteral(resourceName: "grid_icon").withTintColor(.black)
        let button = UIButton(type: .system)
        button.setImage(icon, for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var tableButton: UIButton = {
        let icon = #imageLiteral(resourceName: "table_icon").withTintColor(.black)
        let button = UIButton(type: .system)
        button.setImage(icon, for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private func configureSection() {
        addSubview(sectionLabel)
        addSubview(gridButton)
        addSubview(tableButton)

        sectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sectionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true

        tableButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        tableButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        gridButton.rightAnchor.constraint(equalTo: tableButton.leftAnchor, constant: -8).isActive = true
        gridButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func bindViews(_ viewModel: FilterViewModel) {
        gridButton.rx.tap.subscribe { _ in
            self.presentMode?.toggle()
            viewModel.presentationMode.accept(.grid)
        }.disposed(by: viewModel.disposeBag)

        tableButton.rx.tap.subscribe { _ in
            self.presentMode?.toggle()
            viewModel.presentationMode.accept(.table)
        }.disposed(by: viewModel.disposeBag)

        viewModel.presentationMode.bind(to: self.rx.presentMode).disposed(by: viewModel.disposeBag)
    }
}

class CategorySection: UIView {
    var category: ParameterGRPC.Category? {
        didSet {
            guard oldValue?.id != category?.id else { return }
            updatePresentationStyle()
        }
    }

    func updatePresentationStyle() {
        guard category != nil else { return }
        let isAnimalSelected = category!.name == CategoryType.animal.rawValue
        let select = #imageLiteral(resourceName: "radiobutton_select")
        let diselect = #imageLiteral(resourceName: "radiobutton_diselect")

        updateGradientLayer(elem: animalButton.imageView!, isGradient: isAnimalSelected)
        animalButton.setImage(isAnimalSelected ? select : diselect, for: .normal)
        animalButton.titleLabel?.alpha = isAnimalSelected ? 1.0 : 0.5

        updateGradientLayer(elem: goodsButton.imageView!, isGradient: !isAnimalSelected)
        goodsButton.setImage(!isAnimalSelected ? select : diselect, for: .normal)
        goodsButton.titleLabel?.alpha = !isAnimalSelected ? 1.0 : 0.5
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Категория"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var animalButton: UIButton = {
        let icon = #imageLiteral(resourceName: "radiobutton_diselect").withTintColor(.black)
        let button = UIButton(type: .system)
        button.setImage(icon, for: .normal)
        button.tintColor = .gray
        button.setTitle(CategoryType.animal.rawValue, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.titleLabel?.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var goodsButton: UIButton = {
        let icon = #imageLiteral(resourceName: "radiobutton_diselect").withTintColor(.black)
        let button = UIButton(type: .system)
        button.setImage(icon, for: .normal)
        button.tintColor = .gray
        button.setTitle(CategoryType.goods.rawValue, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.titleLabel?.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private func configureSection() {
        addSubview(sectionLabel)
        addSubview(animalButton)
        addSubview(goodsButton)

        sectionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        sectionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true

        animalButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        animalButton.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 20).isActive = true

        goodsButton.leftAnchor.constraint(equalTo: animalButton.rightAnchor, constant: 20).isActive = true
        goodsButton.centerYAnchor.constraint(equalTo: animalButton.centerYAnchor).isActive = true

        animalButton.layoutButton(style: .Left, imageTitleSpace: 4)
        goodsButton.layoutButton(style: .Left, imageTitleSpace: 4)
    }

    func bindViews(_ viewModel: FilterViewModel) {

        animalButton.rx.tap.subscribe { _ in
            guard viewModel.selectedCategory.value?.name != CategoryType.animal.rawValue else { return }
            viewModel.selectedCategory.accept(CategoryType.animal.getModel())
        }.disposed(by: viewModel.disposeBag)

        goodsButton.rx.tap.subscribe { _ in
            guard viewModel.selectedCategory.value?.name != CategoryType.goods.rawValue else { return }
            viewModel.selectedCategory.accept(CategoryType.goods.getModel())
        }.disposed(by: viewModel.disposeBag)

        viewModel.selectedCategory.bind(to: self.rx.category).disposed(by: viewModel.disposeBag)
    }
}

class SubCategoryWithParametersSection: UIView, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        parameters.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // сделать более адекватнее !!!
        var returnCell: UITableViewCell?
        if indexPath.item == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FilterCellTextPicker.reuseID,
                for: indexPath
            ) as? FilterCellTextPicker else {
                fatalError("")
            }

            let isNull = self.subCategory == nil
            cell.label.text = isNull ? "Подкатегория" : self.subCategory!.name
            cell.label.alpha = isNull ? 0.5 : 1.0
            returnCell = cell
        } else {
            let indexWithOffset = indexPath.item - 1
            let data = parameters[indexWithOffset]

            switch data.type {
            case .string:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: FilterCellTextPicker.reuseID,
                    for: indexPath
                ) as? FilterCellTextPicker else {
                    fatalError("")
                }
                let isEmpty = data.choosenValues!.isEmpty
                cell.label.text = isEmpty ? data.name : data.choosenValues!.joined(separator: ", ")
                cell.label.alpha = isEmpty ? 0.5 : 1.0
                returnCell = cell
            case .date:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: FilterCellDatePicker.reuseID,
                    for: indexPath
                ) as? FilterCellDatePicker else {
                    fatalError("")
                }
                cell.label.text = data.name
                returnCell = cell
            default:
                break
            }
        }

        returnCell?.separatorInset = .zero
        returnCell?.layoutMargins = .zero
        return returnCell!
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

    var subCategory: ParameterGRPC.Category? {
        didSet {
            tableView.reloadData()
        }
    }

    var parameters: [LotParameter] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FilterCellDatePicker.self, forCellReuseIdentifier: FilterCellDatePicker.reuseID)
        tableView.register(FilterCellTextPicker.self, forCellReuseIdentifier: FilterCellTextPicker.reuseID)
        tableView.isScrollEnabled = false

        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private func configureSection() {
        addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
    }

    func bindViews(_ viewModel: FilterViewModel) {
        viewModel.selectedSubCategory.bind(to: self.rx.subCategory).disposed(by: viewModel.disposeBag)

        viewModel.parameters.bind(to: self.rx.parameters).disposed(by: viewModel.disposeBag)

        tableView.rx.itemSelected.map { $0.row }.bind {
            viewModel.selectedParameterAt(index: $0)
        }.disposed(by: viewModel.disposeBag)
    }

}


class PriceSection: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var minPriceTextField: PriceTextField = {
        let textField = PriceTextField()
        textField.upperPriceBound = "99 999 999"
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.placeholder.text = "Цeна от"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var maxPriceTextField: PriceTextField = {
        let textField = PriceTextField()
        textField.upperPriceBound = "99 999 999"
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.placeholder.text = "Цeна до"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private func configureSection() {
        addSubview(minPriceTextField)
        addSubview(separator)
        addSubview(maxPriceTextField)
        minPriceTextField.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        minPriceTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        minPriceTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true

        separator.topAnchor.constraint(equalTo: minPriceTextField.bottomAnchor, constant: 12).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        maxPriceTextField.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 12).isActive = true
        maxPriceTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        maxPriceTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        maxPriceTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        maxPriceTextField.heightAnchor.constraint(equalTo: minPriceTextField.heightAnchor).isActive = true
    }

    func bindViews(_ viewModel: FilterViewModel) {
        minPriceTextField.bindView(field: viewModel.minimumPrice)
        maxPriceTextField.bindView(field: viewModel.maximumPrice)
    }
}


class SortingSection: UIView {
    var sortingType: SortingType? {
        didSet {
            guard oldValue != sortingType else { return }
            updatePresentationStyle()
        }
    }

    func updatePresentationStyle() {
        let select = #imageLiteral(resourceName: "radiobutton_select")
        let diselect = #imageLiteral(resourceName: "radiobutton_diselect")
        let selectedIndex = elements.firstIndex(where: { $0.titleLabel!.text == sortingType!.rawValue })!
        let selectedElem = elements[selectedIndex]
        selectedElem.setImage(select, for: .normal)
        updateGradientLayer(elem: selectedElem.imageView!, isGradient: true)

        elements.filter { $0.titleLabel!.text != sortingType!.rawValue }.forEach { diselectedButton in
            diselectedButton.setImage(diselect, for: .normal)
            updateGradientLayer(elem: diselectedButton.imageView!, isGradient: false)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = Color.inputDesc.color
        label.text = "Сортировать по"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var elements: [UIButton] = {
        var buttons: [UIButton] = []
        SortingType.allCases.map { $0.rawValue }.forEach { text in
            let icon = #imageLiteral(resourceName: "radiobutton_diselect").withTintColor(.black)
            let button = UIButton(type: .system)
            button.setImage(icon, for: .normal)
            button.tintColor = .black
            button.setTitle(text, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
            button.translatesAutoresizingMaskIntoConstraints = false
            buttons.append(button)
        }
        return buttons
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 16.0
        elements.forEach { button in
            button.layoutButton(style: .Left, imageTitleSpace: 4)
            stackView.addArrangedSubview(button)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private func configureSection() {
        addSubview(sectionLabel)
        addSubview(stackView)

        sectionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        sectionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        stackView.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 20).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        // stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16)
    }

    func bindViews(_ viewModel: FilterViewModel) {
        elements.forEach { button in
            button.rx.tap.bind(onNext: { _ in
                let text = button.titleLabel!.text!
                let type = SortingType.parseType(text)
                guard type != viewModel.sortingMode.value else { return }
                viewModel.sortingMode.accept(type)
            }).disposed(by: viewModel.disposeBag)
        }

        viewModel.sortingMode.bind(to: self.rx.sortingType).disposed(by: viewModel.disposeBag)
    }

}

protocol FilterViewDelegate: AnyObject {
    func willFinish(presentMode: PresentModeType, filter: FilterModel)
}

extension UIView {
    func updateGradientLayer(elem: UIView, isGradient: Bool) {
        elem.removeGradientLayer()
        if isGradient {
            elem.applyGradient(.mainButton, .horizontal, 8.0)
        }
    }
}

// блок с обработкой клавиатуры
extension FilterViewController {

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if keyboardDismissTabGesture == nil {
            keyboardDismissTabGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            keyboardDismissTabGesture?.cancelsTouchesInView = false
            view.addGestureRecognizer(keyboardDismissTabGesture!)
        }
    }

    @objc private func keyboardWillHide() {
        if keyboardDismissTabGesture != nil {
            view.removeGestureRecognizer(keyboardDismissTabGesture!)
            keyboardDismissTabGesture = nil
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
