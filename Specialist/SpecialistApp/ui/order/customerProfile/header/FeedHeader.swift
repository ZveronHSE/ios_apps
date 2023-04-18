//
//  FeedHeader.swift
//  SpecialistApp
//
//  Created by alexander on 14.04.2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class FeedHeader: UICollectionReusableView, ReusableHeader {
    static var reuseID: String = "feedHeader"
    static var headerHeight: CGFloat = 10

    private let _selectFeedSourceTrigger = PublishSubject<ProfileFeedSource>()
    public var selectFeedSourceTrigger: Driver<ProfileFeedSource> {
        return _selectFeedSourceTrigger
            .startWith(.actived)
            .distinctUntilChanged()
            .skip(1)
            .asDriverOnErrorJustComplete()
    }

    private let disposeBag = DisposeBag()

    private let activedFeedButton: UIButton = createButton {
        $0.layer.cornerRadius = 12
        $0.setTitle("Активные", for: .normal)
        $0.titleLabel?.font = .zvRegularCaption1
        $0.applySelectedStyle()
    }

    private let closedFeedButton: UIButton = createButton {
        $0.layer.cornerRadius = 12
        $0.setTitle("Завершенные", for: .normal)
        $0.titleLabel?.font = .zvRegularCaption1
        $0.applyDiselectedStyle()
    }

    override init(frame: CGRect) { super.init(frame: frame); layout(); bindView() }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func layout() {
        backgroundColor = .zvBackground
        addSubview(activedFeedButton)
        addSubview(closedFeedButton)

        activedFeedButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        activedFeedButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        closedFeedButton.leftAnchor.constraint(equalTo: activedFeedButton.rightAnchor, constant: 8).isActive = true
        closedFeedButton.centerYAnchor.constraint(equalTo: activedFeedButton.centerYAnchor).isActive = true

        activedFeedButton.applySizeToFitConstraints(withVerticalPadding: 16, andHorizontal: 6)
        closedFeedButton.applySizeToFitConstraints(withVerticalPadding: 16, andHorizontal: 6)
    }

    private func bindView() {

        activedFeedButton.rx.tap.bind(onNext: { self._selectFeedSourceTrigger.onNext(.actived) })
            .disposed(by: disposeBag)

        closedFeedButton.rx.tap.bind(onNext: { self._selectFeedSourceTrigger.onNext(.closed) })
            .disposed(by: disposeBag)

        _selectFeedSourceTrigger.distinctUntilChanged().bind(onNext: { source in
            switch source {
            case .actived:
                self.activedFeedButton.applySelectedStyle()
                self.closedFeedButton.applyDiselectedStyle()
            case .closed:
                self.activedFeedButton.applyDiselectedStyle()
                self.closedFeedButton.applySelectedStyle()
            }
        }).disposed(by: disposeBag)
    }
}

enum ProfileFeedSource {
    case actived
    case closed
}

fileprivate extension UIButton {

    func applySelectedStyle() {
        self.backgroundColor = .zvRedMain
        self.setTitleColor(.zvWhite, for: .normal)

    }

    func applyDiselectedStyle() {
        self.backgroundColor = .zvRedUltraLight
        self.setTitleColor(.zvRedMain, for: .normal)
    }

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
