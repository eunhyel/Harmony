//
//  MyPageDIContainer.swift
//  Harmony
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit

import Feature

class MyPageDIContainer {
    func makeMypageCoordinator(navigation: UINavigationController) -> MypageCoordinator {
        return MypageCoordinator(navigation: navigation, dependencies: self)
    }
}

extension MyPageDIContainer: MypageCoordinatorDependencies {
    func makeMypageViewController(actions coordinatorActions : MypageActions, mypageType: MypageType) -> MypageViewController {
        
        let viewModel = makeMypageViewModel(actions: coordinatorActions, mypageType: mypageType)
        
        return MypageViewController.create(with: viewModel)
    }
    
    func makeMypageViewModel(actions coordinatorActions: MypageActions, mypageType: MypageType) -> MypageViewModel {
        
        return DefaultMypageViewModel(actions: coordinatorActions, mypageType: mypageType)
    }
}
