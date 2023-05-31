//
//  PriceDropDown.swift
//  ConsumerApp
//
//  Created by alexander on 13.05.2023.
//

import Foundation
import RxSwift
import UIKit
import DropDown
import ConsumerDomain

class PriceDropDown: UIView {

    lazy var gesture: UITapGestureRecognizer = {
        return .init(target: self, action: #selector(changeState))
    }()

    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var dropDownContent: DropDown = {
        let dropDownContent = DropDown()
        dropDownContent.dataSource = PriceType.allCases.map { $0.rawValue }
       // dropDownContent.cellNib = UINib(nibName: "SortingCell", bundle: nil)
        dropDownContent.cornerRadius = 10
        dropDownContent.separatorColor = .clear
        dropDownContent.direction = .bottom
        dropDownContent.bottomOffset = CGPoint(x: 0, y: 55)
        dropDownContent.anchorView = self
        return dropDownContent
    }()

    private lazy var sortingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.setTitle(SortingType.popularity.rawValue, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(Color.title.color, for: .normal)
        let icon = #imageLiteral(resourceName: "dropdown_icon")
        button.setImage(icon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let label: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = PriceType.hour.rawValue
        v.textAlignment = .center
        v.font = Font.robotoRegular14
        return v
    }()

    private func layout() {
        widthAnchor.constraint(equalToConstant: 114).isActive = true
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        backgroundColor = .white
        layer.cornerRadius = 10

        addSubview(label)
        addSubview(sortingButton)

        sortingButton.topAnchor.constraint(equalTo: topAnchor, constant: 19).isActive = true
        sortingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -19).isActive = true
        sortingButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        sortingButton.widthAnchor.constraint(equalToConstant: 10).isActive = true

        label.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: sortingButton.leftAnchor, constant: -4).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true

        dropDownContent.selectionAction = { _, item in
            let type = PriceType.init(rawValue: item)
            self.selectedType = type
            self.label.text = item
        }

        addGestureRecognizer(gesture)

        self.dropDownContent.selectedTextColor = Color1.white
        self.dropDownContent.backgroundColor = .white
        self.dropDownContent.selectionBackgroundColor = Color1.orange3
        self.dropDownContent.selectRow(0)
        self.selectedType = .hour
    }

    var selectedType: PriceType?

    @objc private func changeState() {
        UIView.animate(withDuration: 0.3) { self.alpha = 0.5 }
        UIView.animate(withDuration: 0.3) { self.alpha = 1.0 }

        self.dropDownContent.cellConfiguration = { item, cell in
            return cell
        }

        let _: (Bool, CGFloat?) = self.dropDownContent.show()
    }

}
