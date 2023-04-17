//
//  AnimalPhotoCell.swift
//  SpecialistApp
//
//  Created by alexander on 13.04.2023.
//

import Foundation
import UIKit

final class AnimalPhotoCell: UICollectionViewCell, ReusableCell {
    static var reuseID: String = "animalPhotoCell"
    static var cellSize: CGSize = CGSize(width: 140, height: 140)

    private let imageView: UIImageView = createView {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .zvGray3
    }

    override init(frame: CGRect) { super.init(frame: frame); layout() }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func layout() { addSubview(imageView) }

    override func layoutSubviews() { imageView.frame = bounds }

    public func setup(with url: URL) { self.imageView.kf.setImage(with: url) }
}
