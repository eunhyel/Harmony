//
//  MainButton.swift
//  GlobalYeoboya
//
//  Created by cheonsong on 2022/12/27.
//  Copyright © 2022 GlobalYeoboya. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit

public enum MainButtonType {
    case main
    case light
    
    public var color: UIColor {
        switch self {
        case .main:
            return UIColor(redF: 147, greenF: 239, blueF: 181)
        case .light:
            return UIColor(redF: 197, greenF: 247, blueF: 218)
        }
    }
    
    public var textColor: UIColor {
        switch self {
        case .main:
            return .gray20
        case .light:
            return .gray50
        }
    }
    
    public var highlightColor: UIColor {
        switch self {
        case .main:
            return .grayE0
        case .light:
            return .grayE0
        }
    }
}

open class MainButton: UIButton {
    
    
    override open var isEnabled: Bool {
        willSet {
            self.backgroundColor = newValue ? type.color : ResourceManager.Color.rgb(223, 221, 214).toUIColor
        }
    }
    
    open var title: String? {
        get {
            return self.titleLabel?.text
        }
        
        set {
            self.setTitle(newValue, for: .normal)
        }
    }
    
    open var type : MainButtonType = .main
    
    public convenience init(_ type: MainButtonType, title: String) {
        self.init(frame: .zero)
        
        self.type = type
        self.clipsToBounds = true
        self.backgroundColor = type.color
        self.setBackgroundImage(UIImage.imageWithColor(color: type.highlightColor), for: .highlighted)
        self.setTitleColor(type.textColor, for: .normal)
        self.titleLabel?.font = .b16
        self.layer.cornerRadius = 8
        self.setTitle(title, for: .normal)
        
        self.snp.makeConstraints {
            $0.height.equalTo(45)
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
