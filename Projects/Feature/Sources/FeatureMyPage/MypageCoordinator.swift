//
//  MypageCoordinator.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import Shared

public enum MypageType: Equatable {
    case mypage
    case account(Bool)
}

public protocol MypageCoordinatorDependencies {
    
    // VC :: Mypage
    func makeMypageViewController(actions coordinatorActions: MypageActions, mypageType: MypageType) -> MypageViewController
}

public class MypageCoordinator {
    
    var navigation: UINavigationController?
    var dependencies: MypageCoordinatorDependencies
    
    public init(navigation: UINavigationController, dependencies: MypageCoordinatorDependencies) {
        self.navigation = navigation
        self.navigation?.view.backgroundColor = .purple
        self.dependencies = dependencies
    }
    
    public func start(mypageType: MypageType) {
        let actions = MypageActions()
        
        let vc = dependencies.makeMypageViewController(actions: actions, mypageType: mypageType)
        
        // 인증이 안되어 계정관리페이지로 바로 진입할 경우 네이게이션 팝 스와이프액션 X
        self.navigation?.interactivePopGestureRecognizer?.isEnabled = mypageType != .account(true)
        self.navigation?.pushViewController(vc, animated: true)
    }
    
    deinit {
        log.d("MyPage Coordinator deinit")
    }
    
}

