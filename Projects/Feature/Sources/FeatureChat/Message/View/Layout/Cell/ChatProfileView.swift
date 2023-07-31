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

class ChatProfileView: CustomView {
    
    var thumbnailContainer = UIView().then {
        $0.backgroundColor = .clear
        $0.roundCorners(cornerRadius: 24, maskedCorners: [.allCorners])
    }
    
    var thumbnail = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    var name = UILabel().then {
        $0.text = "name"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.setCharacterSpacing(-0.5)
    }
}
