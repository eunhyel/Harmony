//
//  CoyTabBar.swift
//  Feature
//
//  Created by root0 on 2023/09/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import Shared

final class CoyTabBar: CustomView {
    
    private let plate = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let menuTap = PublishSubject<Int>()
    
    var menuTapped: Observable<Int> {
        return menuTap.asObservable()
    }
    
    override func addComponents() {
        
    }
    
    override func setConstraints() {
        
    }
    
    
}
