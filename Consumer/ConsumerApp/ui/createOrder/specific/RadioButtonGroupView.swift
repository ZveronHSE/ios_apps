//
//  RadioButtonGroupView.swift
//  ConsumerApp
//
//  Created by alexander on 13.05.2023.
//

import Foundation
import UIKit
import RxSwift


protocol Converter {

    associatedtype Value

    func allValues() -> [String]

    func convertToResult(_ value: String) -> Value
}

class RadioButtonGroup: UIView {

    var callback: ((Any) -> ())?

    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var converter: (any Converter)?

    public convenience init(converter: any Converter) {
        self.init(frame: .zero)
        self.converter = converter
        layout(converter.allValues())
    }

    private var buttns: [UIButton] = []

    private var countBtns: Int = 0

    private func layout(_ buttons: [String]) {

        buttons.forEach {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            addSubview(button)
            button.setTitle($0, for: .normal)
            unselectButton(button)
            button.layer.cornerRadius = 10
            button.topAnchor.constraint(equalTo: topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            self.buttns.append(button)
        }

        buttns[0].leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        buttns[1..<buttns.count].forEach {
            let previousIndex = buttns.firstIndex(of: $0)!.advanced(by: -1)
            $0.leftAnchor.constraint(equalTo: buttns[previousIndex].rightAnchor, constant: 8).isActive = true
        }

        buttns[buttns.count - 1].rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        buttns.forEach {
            let idx = buttns.firstIndex(of: $0)!
            $0.rx.tap.bind(onNext: {
                self.buttonSelected(idx: idx.advanced(by: 0))
                self.callback?(self.getSelectedValue())
            }).disposed(by: disposeBag)

            $0.applySizeToFitConstraints(withVerticalPadding: 8, andHorizontal: 8)
        }


        selectedIdx = 0
        selectButton(buttns[0])
    }

    private func unselectButton(_ button: UIButton) {
        button.tintColor = .black
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = Color1.orange3.cgColor
    }

    private func selectButton(_ button: UIButton) {
        button.tintColor = .white
        button.backgroundColor = Color1.orange3
        button.layer.borderWidth = 0
    }

    public func buttonSelected(idx: Int) {
        selectButton(buttns[idx])

        buttns.forEach {
            let idxs = buttns.firstIndex(of: $0)?.advanced(by: 0)
            if idxs != idx {
                unselectButton($0)
            }
        }

        selectedIdx = idx
    }

    private var selectedIdx: Int = -1

    public func getSelectedValue() -> Any {
        return converter!.convertToResult( buttns[selectedIdx].titleLabel!.text!)
    }
}


fileprivate extension UIButton {

    func applySizeToFitConstraints(withVerticalPadding vertical: CGFloat, andHorizontal horizontal: CGFloat) {
        let text = self.titleLabel?.text

        let fitHeight = text?.height(constraintedWidth: 0, font: self.titleLabel!.font) ?? 0
        let heightWithPadding = fitHeight + horizontal * 2

        let fitWidth = text?.width(constraintedHeight: 0, font: self.titleLabel!.font) ?? 0
        let widthWithPadding = fitWidth + vertical * 2

        self.widthAnchor.constraint(equalToConstant: widthWithPadding).isActive = true
        self.heightAnchor.constraint(equalToConstant: heightWithPadding).isActive = true
    }
}
