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
    
    var toggleTabBar: PublishSubject<Bool> { get set }
}

public protocol TabbarViewModelOput {
    var _hideTabBar: BehaviorRelay<Bool> { get }
    var _selectedTabBarItem: BehaviorRelay<Int> { get }
    
    var _countMessageBadge: BehaviorRelay<Int> { get }
}



public protocol TabbarViewModel: TabbarViewModelInput, TabbarViewModelOput { }

public class DefaultTabbarViewModel: TabbarViewModel {
    public var toggleTabBar: RxSwift.PublishSubject<Bool> = .init()
    
    public var _hideTabBar: RxRelay.BehaviorRelay<Bool> = .init(value: false)
    public var _selectedTabBarItem: RxRelay.BehaviorRelay<Int> = .init(value: 1)
    public let _countMessageBadge: RxRelay.BehaviorRelay<Int> = .init(value: 0)
    
    public init(){
        
    }
    
    
    
}
