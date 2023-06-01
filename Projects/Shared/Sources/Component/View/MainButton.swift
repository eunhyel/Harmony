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

enum MainButtonType {
    case main
    case light
    
    var color: UIColor {
        switch self {
        case .main:
            return .primary500
        case .light:
            return .primary300
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .main:
            return .gray20
        case .light:
            return .gray50
        }
    }
    
    var highlightColor: UIColor {
        switch self {
        case .main:
            return UIColor(redF: 246, greenF: 197, blueF: 7)
        case .light:
            return UIColor(redF: 251, greenF: 233, blueF: 160)
        }
    }
}

class MainButton: UIButton {
    
    
    override var isEnabled: Bool {
        willSet {
            self.backgroundColor = newValue ? type.color : ResourceManager.Color.rgb(223, 221, 214).toUIColor
        }
    }
    
    var title: String? {
        get {
            return self.titleLabel?.text
        }
        
        set {
            self.setTitle(newValue, for: .normal)
        }
    }
    
    var type : MainButtonType = .main
    
    
    convenience init(_ type: MainButtonType, title: String) {
        self.init(frame: .zero)
        
        self.type = type
        self.clipsToBounds = true
        self.backgroundColor = type.color
        self.setBackgroundImage(UIImage.imageWithColor(color: type.highlightColor), for: .highlighted)
        self.setTitleColor(type.textColor, for: .normal)
        self.titleLabel?.font = .m16
        self.layer.cornerRadius = 12
        self.setTitle(title, for: .normal)
        
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
