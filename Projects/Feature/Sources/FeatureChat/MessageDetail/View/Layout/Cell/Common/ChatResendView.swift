//
//  ChatResendView.swift
//  Feature
//
//  Created by root0 on 2023/07/31.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Shared

final class ChatResendView: CustomView {
    
    var plate = UIView().then {
        $0.roundCorners(cornerRadius: 10, maskedCorners: [.allCorners])
    }
    
    var stack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 2
    }
    
    var resend = UIButton().then {
        $0.setImage(nil, for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    
    var cancel = UIButton().then {
        $0.setImage(nil, for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    
    
    override func addComponents() {
        addSubview(stack)
    }
    
    override func setConstraints() {
        stack.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}