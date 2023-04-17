//
//  HeaderAndTitleView.swift
//  SpecialistApp
//
//  Created by alexander on 13.04.2023.
//

import Foundation
import UIKit

public final class HeaderAndTitleView: UIView {

    private let headerLabel: UILabel = createLabel(with: .zvGray3, and: .zvRegularCaption3)
    private let titleLabel: UILabel = createLabel(with: .zvBlack, and: .zvRegularSubheadline) {
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }

    override init(frame: CGRect) { super.init(frame: frame); layout() }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public func layout() {
        addSubview(headerLabel)
        addSubview(titleLabel)

        headerLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        titleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 4).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    public func setup(with header: String, and title: String) {
        self.headerLabel.text = header
        self.titleLabel.text = title
    }
}
