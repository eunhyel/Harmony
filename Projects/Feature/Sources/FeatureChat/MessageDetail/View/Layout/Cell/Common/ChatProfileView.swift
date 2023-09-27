//
//  ChatProfileView.swift
//  Feature
//
//  Created by root0 on 2023/07/31.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Shared

final class ChatProfileView: CustomView {
    
    var thumbnailContainer = UIView().then {
        $0.backgroundColor = .clear
        $0.roundCorners(cornerRadius: 24, maskedCorners: [.allCorners])
    }
    
    var thumbnail = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    var name = UILabel().then {
        $0.text = "name"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.attributedText = $0.attributedText?.addCharacterSpacing(-0.5)
        $0.setLineHeight(16)
    }
    
    override func addComponents() {
        [thumbnailContainer, name].forEach(addSubview(_:))
        thumbnailContainer.addSubview(thumbnail)
        
    }
    
    override func setConstraints() {
        thumbnailContainer.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        thumbnail.snp.makeConstraints {
            $0.size.equalTo(48)
            $0.directionalEdges.equalToSuperview()
        }
        
        name.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.equalTo(thumbnailContainer.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
}
