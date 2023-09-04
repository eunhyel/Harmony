//
//  DefaultTabbarLayout.swift
//  HoneyGlobal
//
//  Created by inforex_imac on 2023/02/01.
//  Copyright © 2023 HoneyGlobal. All rights reserved.
//

import UIKit
import SnapKit
import Then


class DefaultTabbarLayout {
    
    var safetyView = UIView(frame: .zero)
    
    weak var layout: UIView?
    
    
    let indicator = UIView().then {
        $0.isUserInteractionEnabled = true
        $0.isHidden = true
        $0.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    
    func viewDidLoad(superView: UIView) {
        layout = superView
        setLayout()
        setConstraint()
    }
    
    func setLayout() {
        
    }
    
    func setConstraint() {
        
    }
    
    func bind(to viewModel: TabbarViewModel) {
        
    }
}



