//
//  CustomSearchBar.swift
//  specialist
//
//  Created by alexander on 27.03.2023.
//

import Foundation
import UIKit
import RxSwift

final class CustomSearchBar: UIView {

    /// Публикует текст вводимый пользователем (включая пустые строки)
    let textInputTrigger = PublishSubject<String>()

    /// Публикует событие нажатии на кнопку фильтров
    let filterButtonClickTrigger = PublishSubject<Void>()

    /// Публикует событие нажатия на кнопку search на клавиатуре
    let searchResultsButtonClickTrigger = PublishSubject<Void>()

    private lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.frame = bounds
        return shadowView
    }()

    private lazy var cornerView: UIView = {
        let cornerView = UIView()
        cornerView.frame = self.bounds
        cornerView.backgroundColor = .zvWhite
        cornerView.layer.cornerRadius = 8
        cornerView.layer.masksToBounds = true
        return cornerView
    }()

    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.searchTextField.backgroundColor = .zvWhite
        view.backgroundImage = UIImage()
        view.searchBarStyle = .default
        view.placeholder = "Поиск"
        view.showsBookmarkButton = true
        view.setImage(.zvFilter2.withTintColor(.zvRedMain), for: .bookmark, state: .normal)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()

        cornerView.frame = self.bounds
        shadowView.frame = self.bounds

        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 8)
        let shadowLayer = CALayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowColor = UIColor.zvGray1.cgColor
        shadowLayer.shadowRadius = 2
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.addSublayer(shadowLayer)
    }

    public func layout() {
        addSubview(shadowView)
        addSubview(cornerView)
        cornerView.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: cornerView.topAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: cornerView.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: cornerView.rightAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: cornerView.bottomAnchor).isActive = true
    }
}

extension CustomSearchBar: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textInputTrigger.onNext(searchText)
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        filterButtonClickTrigger.onNext(Void())
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterButtonClickTrigger.onNext(Void())
    }
}
