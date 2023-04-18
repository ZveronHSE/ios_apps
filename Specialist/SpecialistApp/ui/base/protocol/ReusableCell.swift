//
//  ReusableCell.swift
//  SpecialistApp
//
//  Created by alexander on 13.04.2023.
//

import Foundation
import UIKit

protocol ReusableCell: UICollectionViewCell {
    static var reuseID: String { get }
    static var cellSize: CGSize { get }
}

protocol ReusableHeader: UICollectionReusableView {
    static var reuseID: String { get }
    static var headerHeight: CGFloat { get }
}
