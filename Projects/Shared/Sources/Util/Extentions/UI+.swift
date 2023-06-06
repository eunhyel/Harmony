//
//  UI+.swift
//  Shared
//
//  Created by root0 on 2023/05/31.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift

extension UIImage {
    
    /// Change UIButton isHighlighted State Background Color
    static func imageWithColor(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    public func resizeImageToFits(maxWidth: CGFloat?, maxHeight: CGFloat?) -> UIImage? {
        
        let maxWidthType1 = maxWidth ?? 236 - 50
        let maxWidthType2 = maxHeight ?? 206 - 50
        
        let originWidth = self.size.width
        let originHeight = self.size.height
        
        var newWidth: CGFloat = originWidth
        var newHeight: CGFloat = originHeight
        
        if originWidth > originHeight {
            newWidth = (originWidth > maxWidthType1) ? maxWidthType1 : newWidth
        } else {
            newWidth = (originWidth > maxWidthType2) ? maxWidthType2 : newWidth
        }
        
        newHeight = (originHeight * newWidth) / originWidth
        
        if originWidth != newWidth {
            let newSize = CGSize(width: newWidth, height: newHeight)
            let hasAlpha = false
            let scale: CGFloat = 1.0
            
            UIGraphicsBeginImageContextWithOptions(newSize, !hasAlpha, scale)
            draw(in: CGRect(origin: .zero, size: newSize))
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return scaledImage
        }
        
        return self
    }
}

extension UIView {
    
    public var tapGesture: Observable<UITapGestureRecognizer> {
        get {
            return self.tapGesture(1000)
        }
    }
    
    public func tapGesture(_ throttle: Int = 500,
                           _ state: UIGestureRecognizer.State = .recognized,
                           useThrottle: Bool =  true
    ) -> Observable<UITapGestureRecognizer> {
        return useThrottle ?
        self.rx.tapGesture().when(state).throttle(.milliseconds(throttle), scheduler: MainScheduler.instance) :
        self.rx.tapGesture().when(state)
    }
    
    public enum Corners {
        case bottomLeft
        case bottomRight
        case topLeft
        case topRight
        case allCorners
    }
    
    public func roundCorners(cornerRadius: CGFloat, maskedCorners: [Corners]) {
        
        var corners : CACornerMask = .init()
        
        maskedCorners.forEach{
            switch $0 {
            case .topLeft:
                corners.insert(.layerMinXMinYCorner)
            case .bottomLeft:
                corners.insert(.layerMinXMaxYCorner)
            case .topRight:
                corners.insert(.layerMaxXMinYCorner)
            case .bottomRight:
                corners.insert(.layerMaxXMaxYCorner)
            case .allCorners:
                corners.insert(.layerMinXMinYCorner)
                corners.insert(.layerMinXMaxYCorner)
                corners.insert(.layerMaxXMinYCorner)
                corners.insert(.layerMaxXMaxYCorner)
            }
        }
        
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: corners)
    }
    
    public func setGradient(color1: UIColor, color2: UIColor, axis: NSLayoutConstraint.Axis) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        switch axis {
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        case .vertical:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            
        @unknown default:
            fatalError()
        }
        layer.addSublayer(gradient)
    }
}

// MARK: - Layer
extension CALayer {
    
    /// draw 함수 내에서 구현해야 함
    /// 제플린 기준으로 작성하기 좋음.
    /// - Parameters:
    ///   - color: 그림자 컬러 기본: 검정
    ///   - alpha: 그림자 alpha
    ///   - x: 그림자  origin X
    ///   - y: 그림자  origin Y
    ///   - blur: 그림자 블러
    ///   - spread: 그림자가 뷰에서 삐져나오는 정도, zeplin에서는 0이지만 1로 써야 알맞게 나오는 듯.
    ///   - radius: 그림자 radius, 뷰가 radius가 있다면 같게 줘야함
    public func applySketchShadow(
        color: UIColor = .black,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat, // 퍼짐 정도
        spread: CGFloat = 1, // 밖으로 삐져나올 정도
        radius: CGFloat = 0 // 그림자의 radius
    ) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / UIScreen.main.scale
        let rect = bounds.insetBy(dx: -spread, dy: -spread)
        shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
    }
    
    public func applySketchShadow(option: ShadowOption) {
        masksToBounds = false
        shadowColor = option.color.cgColor
        shadowOpacity = option.alpha
        shadowOffset = CGSize(width: option.x, height: option.y)
        shadowRadius = option.blur / UIScreen.main.scale
        let rect = bounds.insetBy(dx: -option.spread, dy: -option.spread)
        shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: option.radius).cgPath
    }
}

// MARK: - Label
extension UILabel {
    
    public static func defaultLabel() -> UILabel {
        let label = UILabel()
            label.sizeToFit()
            label.textAlignment = .center
            label.numberOfLines = 1
            label.lineBreakMode = .byTruncatingTail
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "description"
            label.font = ResourceManager.Font.m(13).get
        return label
    }
    
    /// LineHeight를 설정
    public func setLineHeight(_ lineHeight: CGFloat) {
        if let text = self.text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key : Any] = [
                .paragraphStyle : style,
                .baselineOffset : (lineHeight - font.lineHeight) / 4
            ]
            
            let attrString = NSAttributedString(string: text, attributes: attributes)
            
            self.attributedText = attrString
        }
    }
    
    public func replace(target: String, range: String) {
        self.text = self.text?.replace(target: target, range: range)
    }
    
    // 컬러만 변경
    public func textColorChange(color: UIColor, range: String){
        guard let text = self.text else { return }
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.foregroundColor, value: color, range: (text as NSString).range(of: range))
        
        self.attributedText = attributedStr
    }

    // 폰트만 변경
    public func textFontChange(font: UIFont, range: String){
        guard let text = self.text else { return }
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.font, value: font, range: (text as NSString).range(of: range))
        
        self.attributedText = attributedStr
    }

    // 컬러, 폰트 변경
    public func textColorAndFontChange(color: UIColor, font: UIFont, range: String){
        guard let text = self.text else { return }
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.foregroundColor, value: color, range: (text as NSString).range(of: range))
        attributedStr.addAttribute(.font, value: font, range: (text as NSString).range(of: range))
        
        self.attributedText = attributedStr
    }
    
    // 자간 설정
    public func setCharacterSpacing(_ spacing: CGFloat){
       let attributedStr = NSMutableAttributedString(string: self.text ?? "")
       attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
       self.attributedText = attributedStr
    }
    
    // get lines
    public func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    
}
