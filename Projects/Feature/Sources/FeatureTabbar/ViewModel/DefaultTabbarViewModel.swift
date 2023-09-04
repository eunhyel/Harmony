//
//  DevaultViewModel.swift
//  HoneyGlobal
//
//  Created by inforex_imac on 2023/02/01.
//  Copyright (c) 2023 All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxGesture
import SwiftyJSON



public protocol TabbarViewModelInput {
}

public protocol TabbarViewModelOput {
    var _selectedTabBarItem: BehaviorRelay<Int> { get }
}



public protocol TabbarViewModel: TabbarViewModelInput, TabbarViewModelOput { }

public class DefaultTabbarViewModel: TabbarViewModel {
    public var _selectedTabBarItem: RxRelay.BehaviorRelay<Int> = .init(value: 1)
    
    public init(){
        
    }
}
