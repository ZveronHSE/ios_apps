//
//  UIView+Ext.swift
//  specialist
//
//  Created by alexander on 27.03.2023.
//

import Foundation
import UIKit

extension UIView {

    private func performAlpha(alpha: CGFloat, animated: Bool, completion: ((Bool) -> Void)?) {
        if animated {
            UIView.animate(
                withDuration: 0.3,
                animations: { self.alpha = alpha },
                completion: completion
            )
        } else {
            self.alpha = alpha
        }
    }

    func show(animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        performAlpha(alpha: 1.0, animated: animated, completion: completion)
    }

    func hide(animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        performAlpha(alpha: 0.0, animated: animated, completion: completion)
    }

    func select(animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        performAlpha(alpha: 0.5, animated: animated, completion: completion)
    }

    func unselect(animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        performAlpha(alpha: 1.0, animated: animated, completion: completion)
    }
}
