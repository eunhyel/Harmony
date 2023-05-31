//
//  GuidelinesView.swift
//  GlobalHoneysTests
//
//  Created by yeoboya on 2023/04/04.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import UIKit

import Then
import SnapKit

final class PopupListView: CustomView {
    
    let bgView = UIView().then {
        $0.backgroundColor = UIColor(rgbF: 242)
        $0.layer.cornerRadius = 12
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 14
        $0.backgroundColor = .clear
    }
    
    override func addComponents() {
        self.addSubview(bgView)
        
        bgView.addSubview(stackView)
    }
    
    override func setConstraints() {
        bgView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
        
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.top.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        
    }
    
    /***
     가이드라인 항목
     */
    convenience init(guidelines: [(String, String)]) {
        self.init()
        
        guidelines.forEach { fullStr, pointStr in
            let row = GuidelineRowView(fullStr: fullStr, pointStr: pointStr)
            
            stackView.addArrangedSubview(row)
        }
    }
    
    /***
     인증필요 항목
     */
    convenience init(authList: [String]) {
        self.init()
        
        authList.forEach { auth in
            let row = AuthRowView(auth: auth)
            
            stackView.addArrangedSubview(row)
        }
        
        stackView.spacing = 4
    }
}

final class GuidelineRowView: CustomView {
    let fullLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.textColor = .gray20
        $0.font = .m14
    }
    
    let hiddenLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.textColor = .clear
        $0.font = .b14
    }
    
    let underLine = UIView().then {
        $0.backgroundColor = .primary200
        $0.layer.cornerRadius = 4
    }
    
    convenience init(fullStr: String, pointStr: String) {
        self.init()
        
        fullLabel.text = fullStr
        let attributedStr = NSMutableAttributedString(string: fullStr)
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: -0.42, range: NSMakeRange(0, attributedStr.length))
        attributedStr.addAttribute(.font, value: UIFont.b14, range: (fullStr as NSString).range(of: pointStr))
        fullLabel.attributedText = attributedStr
        
        hiddenLabel.text = pointStr
        hiddenLabel.setCharacterSpacing(-0.42)
    }
    
    override func addComponents() {
        [hiddenLabel, underLine, fullLabel].forEach(addSubview(_:))
    }
    
    override func setConstraints() {
        fullLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        hiddenLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
        
        underLine.snp.makeConstraints {
            $0.height.equalTo(9)
            $0.left.right.equalTo(hiddenLabel)
            $0.bottom.equalTo(hiddenLabel)
        }
    }
}

final class AuthRowView: CustomView {
    let authLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.textColor = .gray20
        $0.font = .b14
        $0.textAlignment = .center
        $0.setLineHeight(20)
        $0.setCharacterSpacing(-0.42)
    }
    
    convenience init(auth: String) {
        self.init()
        
        authLabel.text = "- \(auth)"
    }
    
    override func addComponents() {
        addSubview(authLabel)
        
    }
    
    override func setConstraints() {
        authLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
}
