//
//  ViewUtils.swift
//  SpecialistApp
//
//  Created by alexander on 12.04.2023.
//

import Foundation
import UIKit

func createView<T: UIView>(transform: ((T) -> Void)? = nil) -> T {
    let view = T()
    transform?(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}

func createLabel<T: UILabel>(with color: UIColor, and font: UIFont, transform: ((T) -> Void)? = nil) -> T {
    let label = T()
    label.textColor = color
    label.font = font
    transform?(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}

func createButton<T: UIButton>(transorm: ((T) -> Void)? = nil) -> T {
    let button = T(type: .system)
    transorm?(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}

func createNavigationButton(
    type: NavigationButtonType,
    for controlEvents: UIControl.Event = .touchUpInside,
    _ closure: @escaping() -> Void
) -> UIBarButtonItem {
    let button = UIButton(type: .system)
    let icon: UIImage
    switch type {
    case .back: icon = .zvArrowLeft
    case .close: icon = .zvClose
    case .setting: icon = .zvDotsVertical
    }
    button.setImage(icon, for: .normal)
    button.tintColor = .zvBlack
    button.addAction(for: controlEvents) { closure() }
    return UIBarButtonItem(customView: button)
}

enum NavigationButtonType {
    case back
    case close
    case setting
}

func createActivityIndicator<T: UIActivityIndicatorView>(transorm: ((T) -> Void)? = nil) -> T {
    let view = T(style: .large)
    transorm?(view)
    view.hide(animated: false)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}
