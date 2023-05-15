//
//  UIView+Chat.swift
//  ConsumerApp
//
//  Created by Nikita on 12.05.2023.
//

import Foundation
import UIKit

extension UIView {
    
    /** Adds Constraints in Visual Formate Language. It is a helper method defined in extensions for convinience usage
     
     - Parameter format: string formate as we give in visual formate, but view placeholders are like v0,v1, etc
     - Parameter views: It is a variadic Parameter, so pass the sub-views with "," seperated.
     */
    func addConstraintsWithVisualStrings(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
