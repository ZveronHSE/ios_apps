//
//  Base.swift
//  iosapp
//
//  Created by alexander on 01.05.2022.
//

import Foundation
import UIKit

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}

extension Date {
 func toString(withFormat: String) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = withFormat
        formatter.timeZone = TimeZone.init(identifier: "UTC")
        return formatter.string(from: self)
    }
}

extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()

        return label.frame.height
    }

    func width(constraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: .greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()

        return label.frame.width
    }
}

extension String {
    func parseToDate() -> Date {
        let utcISODateFormatter = ISO8601DateFormatter()
        let formattedString = String(self.reversed.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true)[1]).reversed + "Z"

        return utcISODateFormatter.date(from: formattedString)!
    }

    func parseToNewFormat(format: String) -> String {
       return self.parseToDate().toString(withFormat: format)
    }
}

extension String {
    var latinCharactersOnly: Bool {
        return self.range(of: "\\P{Latin}", options: .regularExpression) == nil
    }

    var сyrillicCharactersOnly: Bool {
        return self.range(of: "\\P{Cyrillic}", options: .regularExpression) == nil
    }
    
    var cyrillicCharactersWithSpaceOnly: Bool {
        let text = self.replacingOccurrences(of: " ", with: "")
        return text.range(of: "\\P{Cyrillic}", options: .regularExpression) == nil
    }
    
    var numericCharactersOnly: Bool {
        return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
    }

   
}

extension String {
    private func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }

}

extension String {
    func niceFormatNumber() -> String {
        let s = self
        
        let number = String(format: "+%@ (%@) %@-%@-%@",
                            s.substring(to: s.index(s.startIndex, offsetBy: 1)),
                            s.substring(with: s.index(s.startIndex, offsetBy: 1) ..< s.index(s.startIndex, offsetBy: 4)),
                            s.substring(with: s.index(s.startIndex, offsetBy: 4) ..< s.index(s.startIndex, offsetBy: 7)),
                            s.substring(with: s.index(s.startIndex, offsetBy: 7) ..< s.index(s.startIndex, offsetBy: 9)),
                            s.substring(with: s.index(s.startIndex, offsetBy: 9) ..< s.index(s.startIndex, offsetBy: 11))
        )
        return number
    }
    
}
