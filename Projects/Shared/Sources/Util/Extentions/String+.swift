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
    
    // MARK: Associated Date
    public func makeDate() throws -> String {
        
        let insFormat   = DateFormatter().then{$0.dateFormat = "dd-MM-yyyy HH:mm:ss"}
        let transFormat = DateFormatter().then{$0.dateFormat = "dd-MM-yyyy"}
        
        guard let date = insFormat.date(from: self) else {
            throw Exception.GuardBinding.invalidData(name: self)
        }
        
        return transFormat.string(from: date)
    }
    
    public func makeReverseDate() throws -> String {
        
        let insFormat = DateFormatter().then{ $0.dateFormat = "yyyy-MM-dd HH:mm:ss"}
        let transFormat = DateFormatter().then{ $0.dateFormat = "dd-MM-yyyy"}
            transFormat.timeZone = .current
        
        guard let date = insFormat.date(from: self) else {
            throw Exception.GuardBinding.invalidData(name: self)
        }
        
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        
        guard let returnDate = Calendar.current.date(from: dateComponents) else {
            throw Exception.GuardBinding.invalidData(name: self)
        }

        return transFormat.string(from: returnDate)
    }
    
    public func makeTiemDate() -> String {
        
        let insFormat = DateFormatter().then{ $0.dateFormat = "yyyy-MM-dd HH:mm:ss"}
        let transFormat = DateFormatter().then{ $0.dateFormat = "a hh:mm"}
            transFormat.timeZone = .current
        
        guard let date = insFormat.date(from: self) else {
            return ""
        }
        
        return transFormat.string(from: date)
    }
    
    public func toDateWithReverse() -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.date(from: self) ?? Date()
        
    }
    
    public func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        guard let timeInterval = TimeInterval(self) else { return nil }
        
        let timeDate = Date(timeIntervalSince1970: timeInterval)
        return timeDate
    }
    
    public func toDateWithYMD() -> Date { //"dd-MM-yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter.date(from: self) ?? Date()
    }
    
    public func makeLocaleDate() throws -> String {
        
        guard let timeInterval = TimeInterval(self) else {
            throw Exception.message("timeInterval Error")
        }
        
        let timeDate = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // dd-MM-yyyy
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        
        return dateFormatter.string(from: timeDate)
    }
    
    public func makeLocaleTimeDate() -> String {
        
        let timeInterval = TimeInterval(self) ?? 0.0
        
        let timeDate = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"//"a hh:mm"
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        
        return dateFormatter.string(from: timeDate)
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
