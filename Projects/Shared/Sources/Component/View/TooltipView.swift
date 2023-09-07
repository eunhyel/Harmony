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
    
    private var titleLabel = UILabel().then {
        $0.textColor = TipStatus.active.textColor
        $0.text = "new"
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(14)
        
    }
    
    private let shape = CAShapeLayer()
    
    public init(badgeText: String, mode: TipStatus,
                tipStartX: CGFloat, tipStartY: CGFloat,
                tipWidth: CGFloat, tipHeight: CGFloat) {
        super.init(frame: .zero)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 8
        
        self.changeStatus(to: mode)
        
        self.addLabel(badgeText)
        
//        self.addTipLine(tipStartX: tipStartX, tipStartY: tipStartY, tipWidth: tipWidth, tipHeight: tipHeight)
        self.addTipView(tipWidth: tipWidth, tipHeight: tipHeight)
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
    
    open func updateBadge(_ count: Int) {
        if count <= 0 {
            titleLabel.text = ""
            self.isHidden = true
        } else {
            titleLabel.text = count > 99 ? "99+" : "\(count)"
            self.isHidden = false
        }
        
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
    }
    
    public func addTipView(tipWidth: CGFloat, tipHeight: CGFloat) {
        let tipView = UIView()
//        let shape = CAShapeLayer()
        
        let path = CGMutablePath()
        let tipStartX: CGFloat = 0.0
        let tipStartY: CGFloat = 0.0
        let tipCenterX = tipWidth / 2.0
        let tipCenterY = tipHeight / 2.0
        
        path.move(to: .init(x: tipStartX, y: tipStartY))
        path.addLine(to: .init(x: tipStartX + tipCenterX, y: tipStartY + tipHeight))
        path.addLine(to: .init(x: tipStartX + tipWidth, y: tipStartY))
        path.addLine(to: .init(x: tipStartX + 0, y: tipStartY - 0))
        
        shape.path = path
        shape.fillColor = backgroundColor?.cgColor
        shape.lineJoin = .round
        
        tipView.layer.insertSublayer(shape, at: 0)
        
        insertSubview(tipView, at: 0)
        tipView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(tipWidth)
            $0.height.equalTo(tipHeight)
            $0.bottom.equalToSuperview().offset(tipCenterY)
        }
    }
    
}
