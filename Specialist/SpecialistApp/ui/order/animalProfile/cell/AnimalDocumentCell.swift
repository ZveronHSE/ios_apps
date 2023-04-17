//
//  AnimalDocumentCell.swift
//  SpecialistApp
//
//  Created by alexander on 13.04.2023.
//

import Foundation
import UIKit

final class AnimalDocumentCell: UICollectionViewCell, ReusableCell {
    static var reuseID: String = "animalDocumentCell"
    static var cellSize: CGSize = CGSize(width: 140, height: 140)

    private let documentView: UILabel = createLabel(with: .zvBlack, and: .zvRegularSubheadline) {
        $0.textAlignment = .center
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.zvGray3.cgColor
        $0.backgroundColor = .zvWhite
        $0.layer.cornerRadius = 8
    }

    override init(frame: CGRect) { super.init(frame: frame); layout() }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func layout() { addSubview(documentView) }

    override func layoutSubviews() { documentView.frame = bounds }

    public func setup(with name: String) { documentView.text = name }
}
