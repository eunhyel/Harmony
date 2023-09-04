//
//  TooltipView.swift
//  Shared
//
//  Created by root0 on 2023/09/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

open class BadgeToolTipView: UIView {
    
//    struct TipText {
//        var text: String
//        var textColor: UIColor
//        var font: UIFont
//    }
    
    public enum TipStatus {
        case active
        case inactive
        
        var textColor: UIColor {
            switch self {
            case .active: return UIColor(redF: 106, greenF: 242, blueF: 176)
            case .inactive: return UIColor(rgbF: 219)
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .active: return UIColor(rgbF: 17)
            case .inactive: return UIColor(rgbF: 99)
            }
        }
    }
    
    var titleLabel = UILabel().then {
        $0.textColor = TipStatus.active.textColor
        $0.text = "new"
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        $0.setLineHeight(14)
        
    }
    
    let shape = CAShapeLayer()
    
    public init(badgeText: String, mode: TipStatus,
                tipStartX: CGFloat, tipStartY: CGFloat,
                tipWidth: CGFloat, tipHeight: CGFloat) {
        super.init(frame: .zero)
        self.changeStatus(to: mode)
        self.backgroundColor = mode.backgroundColor
        
        self.addLabel(badgeText)
        
        self.addTipLine(tipStartX: tipStartX, tipStartY: tipStartY, tipWidth: tipWidth, tipHeight: tipHeight)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func changeStatus(to: TipStatus) {
        titleLabel.textColor = to.textColor
        backgroundColor = to.backgroundColor
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        shape.fillColor = to.backgroundColor.cgColor
        CATransaction.commit()
    }
    
    open func updateBadge(_ str: String) {
        titleLabel.text = str
    }
    
    private func addLabel(_ text: String = "new", font: UIFont = .systemFont(ofSize: 14, weight: .medium)) {
        
        titleLabel.text = text
        titleLabel.font = font
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(3)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    public func addTipLine(tipStartX: CGFloat, tipStartY: CGFloat,
                            tipWidth: CGFloat, tipHeight: CGFloat) {
        let path = CGMutablePath()
        let tipWidthCenter = tipWidth / 2.0
        let tipHeightCenter = tipHeight / 2.0
        
        let endXWidth = tipStartX + tipWidth
        
        path.move(to: .init(x: tipStartX, y: tipStartY))
        path.addLine(to: .init(x: tipStartX + tipWidthCenter, y: tipStartY + tipHeightCenter))
        path.addLine(to: .init(x: endXWidth, y: tipStartY))
        path.addLine(to: .init(x: tipStartX + tipWidthCenter, y: tipStartY - tipHeightCenter))
        
        
        shape.path = path
        shape.fillColor = backgroundColor?.cgColor
        
        self.layer.insertSublayer(shape, at: 0)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 8
    }
    
}
