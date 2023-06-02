//
//  String+.swift
//  Shared
//
//  Created by root0 on 2023/05/31.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit

extension String {
    
    public var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
    
    public func replace(target: String, range: String) -> String {
        return self.replacingOccurrences(of: range, with: target, options: .literal, range: nil)
    }
}

extension NSAttributedString {
    public func addCharacterSpacing(_ spacing: CGFloat) -> NSAttributedString {
        let attributedStr = NSMutableAttributedString(attributedString: self)
        attributedStr.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedStr)
    }
    
    public func addColor(color: UIColor, range: String) -> NSAttributedString {
        let attributedStr = NSMutableAttributedString(attributedString: self)
        attributedStr.addAttribute(.foregroundColor, value: color, range: (string as NSString).range(of: range))
        
        return NSAttributedString(attributedString: attributedStr)
    }
    
    public func addFont(font: UIFont, range: String) -> NSAttributedString {
        let attributedStr = NSMutableAttributedString(attributedString: self)
        attributedStr.addAttribute(.font, value: font, range: (string as NSString).range(of: range))
        
        return NSAttributedString(attributedString: attributedStr)
    }
}
