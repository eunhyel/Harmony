//
//  ChatClockView.swift
//  Feature
//
//  Created by root0 on 2023/07/31.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit

import Shared

final class ChatClockView: CustomView {
    
    var date = UILabel().then {
        $0.text = "00:00"
        $0.textColor = UIColor(rgbF: 150)
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.setLineHeight(14)
        $0.setCharacterSpacing(-0.5)
    }
    
    var checkRead = UILabel().then {
        $0.text = "1"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.setLineHeight(20)
        $0.setCharacterSpacing(-0.5)
    }
    
    var stack = UIStackView().then {
        $0.axis = .vertical
    }
    
    override func addComponents() {
        addSubview(stack)
        
        [checkRead, date].forEach(stack.addArrangedSubview(_:))
    }
    
    override func setConstraints() {
        stack.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
            $0.width.greaterThanOrEqualTo(30)
        }
    }
}
