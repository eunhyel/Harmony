//
//  MessageTopHeadView.swift
//  Feature
//
//  Created by root0 on 2023/09/06.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Shared

class MessageTopHeadView: CustomView {
    
    let container = UIView().then {
        $0.backgroundColor = .white
    }
    
    let hStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    let closeBtn = UIButton().then {
        $0.setImage(<#T##image: UIImage?##UIImage?#>, for: .normal)
    }
    
    override func addComponents() {
        
    }
    
    override func setConstraints() {
        
    }
    
    
}
