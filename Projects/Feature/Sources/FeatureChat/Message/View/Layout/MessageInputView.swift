//
//  MessageInputView.swift
//  Feature
//
//  Created by root0 on 2023/06/09.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Shared

class MessageInputView: CustomView {
    
    let containerStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .bottom
        $0.distribution = .fill
    }
    
    let menuContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let gallery = UIImageView().then {
        $0.image = FeatureAsset.boosterBasic.image
    }
    
    let textViewContainer = UIView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .grayE1
    }
    
    let inputTextView = UITextView().then {
        $0.font = .m15
        $0.textColor = .warmGrey
        $0.textContainerInset = .zero
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    
    let sendContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let searchGif = UIImageView().then {
        $0.image = FeatureAsset.boosterBasic.image
    }
    
    let send = UIImageView().then {
        $0.image = FeatureAsset.rectangle135.image
    }
    
}
