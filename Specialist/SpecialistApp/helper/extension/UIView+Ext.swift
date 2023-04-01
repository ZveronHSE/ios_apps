//
//  UIView+Ext.swift
//  specialist
//
//  Created by alexander on 27.03.2023.
//

import Foundation
import UIKit

extension UIView {

    private func performAlpha(alpha: CGFloat, animated: Bool) {
        if animated { UIView.animate(withDuration: 0.3) { self.alpha = alpha } } else { self.alpha = alpha }
    }

    func show(animated: Bool = false) { performAlpha(alpha: 1.0, animated: animated) }

    func hide(animated: Bool = false) { performAlpha(alpha: 0.0, animated: animated) }

    func select(animated: Bool = false) { performAlpha(alpha: 0.5, animated: animated) }

    func unselect(animated: Bool = false) { performAlpha(alpha: 1.0, animated: animated) }
}
