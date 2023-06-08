//
//  Color+.swift
//  Shared
//
//  Created by root0 on 2023/05/31.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(redF: CGFloat, greenF: CGFloat, blueF: CGFloat, alphaF: CGFloat = 1.0) {
        
        let calculated_red: CGFloat = redF / 255.0
        let calculated_green: CGFloat = greenF / 255.0
        let calculated_blue: CGFloat = blueF / 255.0
        
        self.init(red: calculated_red, green: calculated_green, blue: calculated_blue, alpha: alphaF)
    }
    
    public convenience init(rgbF: CGFloat, a: CGFloat = 1) {
        self.init(red: rgbF / 255.0, green: rgbF / 255, blue: rgbF / 255.0, alpha: a)
    }
    
    static var primary500: UIColor {
        UIColor(red: 1.0, green: 206.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)
    }
    
    static var primary450: UIColor {
        UIColor(red: 1.0, green: 213.0 / 255.0, blue: 46.0 / 255.0, alpha: 1.0)
    }
    
    static var primary400: UIColor {
        UIColor(red: 1.0, green: 224.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    }
    
    static var primary350: UIColor {
        UIColor(red: 1.0, green: 231.0 / 255.0, blue: 136.0 / 255.0, alpha: 1.0)
    }
    
    static var primary300: UIColor {
        UIColor(red: 1.0, green: 238.0 / 255.0, blue: 168.0 / 255.0, alpha: 1.0)
    }
    
    static var primary250: UIColor {
        UIColor(red: 1.0, green: 243.0 / 255.0, blue: 197.0 / 255.0, alpha: 1.0)
    }
    
    static var primary200: UIColor {
        UIColor(red: 1.0, green: 247.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    }
    
    static var primary150: UIColor {
        UIColor(red: 1.0, green: 250.0 / 255.0, blue: 228.0 / 255.0, alpha: 1.0)
    }
    
    static var primary100: UIColor {
        UIColor(red: 254.0 / 255.0, green: 251.0 / 255.0, blue: 236.0 / 255.0, alpha: 1.0)
    }
    
    /// 32 32 32
    static var gray20: UIColor {
        UIColor(white: 32.0 / 255.0, alpha: 1.0)
    }
    
    /// 80  80 80
    static var gray50: UIColor {
        UIColor(white: 80.0 / 255.0, alpha: 1.0)
    }
    
    static var warmGrey: UIColor {
        UIColor(white: 112.0 / 255.0, alpha: 1.0)
    }
    
    static var gray90: UIColor {
        UIColor(white: 144.0 / 255.0, alpha: 1.0)
    }
    
    static var grayA4: UIColor {
        UIColor(white: 164.0 / 255.0, alpha: 1.0)
    }
    
    static var greyishTwo: UIColor {
        UIColor(white: 184.0 / 255.0, alpha: 1.0)
    }
    
    static var grayD4: UIColor {
        UIColor(white: 212.0 / 255.0, alpha: 1.0)
    }
    
    public static var grayE0: UIColor {
        UIColor(white: 223.0 / 255.0, alpha: 1.0)
    }
    
    public static var grayE1: UIColor {
        UIColor(white: 225.0 / 255.0, alpha: 1.0)
    }
    
    public static var grayF1: UIColor {
        UIColor(white: 241.0 / 255.0, alpha: 1.0)
    }
    
    static var grayFa: UIColor {
        UIColor(white: 250.0 / 255.0, alpha: 1.0)
    }
    
    static var badgeCount: UIColor {
        UIColor(red: 41.0 / 255.0, green: 197.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
    }
    
    static var errorNotice: UIColor {
        UIColor(red: 1.0, green: 100.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)
    }
    
    static var nicknameM: UIColor {
        UIColor(red: 54.0 / 255.0, green: 119.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
    }
    
    static var nicknameF: UIColor {
        UIColor(red: 238.0 / 255.0, green: 103.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0)
    }
    
    public static var dimView: UIColor {
        UIColor.init(redF: 0, greenF: 0, blueF: 0, alphaF: 0.7)
    }
    
    static var dimView40: UIColor {
        UIColor.init(redF: 0, greenF: 0, blueF: 0, alphaF: 0.4)
    }
    
    static var none: UIColor {
        UIColor.init(redF: 0, greenF: 0, blueF: 0, alphaF: 0)
    }
    
    static var messageName: UIColor {
        UIColor(redF: 149, greenF: 104, blueF: 0, alphaF: 1.0)
    }
    
    static var main_nicknameM: UIColor {
        UIColor(redF: 70, greenF: 90, blueF: 149, alphaF: 1.0)
    }
    
    static var main_nicknameF: UIColor {
        UIColor(redF: 220, greenF: 84, blueF: 120, alphaF: 1.0)
    }
    
    static var waveColor: UIColor {
        UIColor(redF: 255, greenF: 86, blueF: 86, alphaF: 1.0)
    }

    static var translated_Text: UIColor {
        UIColor(redF: 149, greenF: 104, blueF: 0, alphaF: 1.0)
    }
    
}
