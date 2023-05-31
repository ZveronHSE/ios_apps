//
//  Icon.swift
//  iosapp
//
//  Created by alexander on 08.02.2023.
//

import UIKit

// MARK: Basic icons
struct Icon {
    static let back: UIImage = #imageLiteral(resourceName: "back_icon").withTintColor(.black)
    static let close: UIImage = #imageLiteral(resourceName: "close_icon").withTintColor(.black)
    static let settings: UIImage = #imageLiteral(resourceName: "settings_icon_2").withTintColor(.black)
    static let filter: UIImage = #imageLiteral(resourceName: "settings_icon").withTintColor(.black)
    static let arrowRight: UIImage = #imageLiteral(resourceName: "arrow_right_icon").withTintColor(.black)
    static let arrowDown: UIImage = #imageLiteral(resourceName: "dropdown_icon").withTintColor(.black)
    static let accept: UIImage = #imageLiteral(resourceName: "check_icon").withTintColor(.black)
    static let presentationTable: UIImage = #imageLiteral(resourceName: "table_icon").withTintColor(.black)
    static let presentationGrid: UIImage = #imageLiteral(resourceName: "grid_icon").withTintColor(.black)
    static let favoriteSelected: UIImage = #imageLiteral(resourceName: "favorite")
    static let favoriteUnselected: UIImage = #imageLiteral(resourceName: "favorite_icon")
    static let error: UIImage = #imageLiteral(resourceName: "error_icon2")
    static let empty: UIImage = #imageLiteral(resourceName: "unfavorite")
    static let star: UIImage = #imageLiteral(resourceName: "star_icon")
    static let starEmpty: UIImage = #imageLiteral(resourceName: "star_empty_icon")

    static let unchecked: UIImage = #imageLiteral(resourceName: "Not_Selected_d")
    static let checked: UIImage = #imageLiteral(resourceName: "Selected")
}

// MARK: Iterable icons
extension Icon {
    static func subCategory(id: Int) -> UIImage {
        return UIImage.init(named: "subcategory_icon_\(id)") ?? #imageLiteral(resourceName: "countWatch")
    }
}

// MARK: Composite icons
public typealias CompositeIcon = (frontground: UIImage, background: UIImage)
extension Icon {
    static let animal: CompositeIcon = (#imageLiteral(resourceName: "animals_image"), #imageLiteral(resourceName: "animals_background"))
    static let goods: CompositeIcon = (#imageLiteral(resourceName: "product_image"), #imageLiteral(resourceName: "product_background"))
}
