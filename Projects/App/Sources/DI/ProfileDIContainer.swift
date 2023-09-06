//
//  ProfileDIContainer.swift
//  Harmony
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import Feature

class ProfileDIContainer {
    func makeProfileListCoordinator(navigation: UINavigationController) -> ProfileCoordinator {
        return ProfileCoordinator(navigation: navigation, dependencies: self)
    }
}

extension ProfileDIContainer: ProfileCoordinatorDependencies {

    //비디오 리스트
    func makeProfileListViewController(actions coordinatorActions: ProfileListActions) -> ProfileListViewController {
        
        let makeProfileListViewModel = DefaultProfileListViewModel(actions: coordinatorActions)
        return ProfileListViewController.create(with: makeProfileListViewModel)
    }
    
    
    //비디오 화면
    func makeVideoViewController(actions coordinatorActions: Feature.VideoViewActions) -> Feature.VideoViewController {
        let viewModel = DefaultVideoViewModel(actions: coordinatorActions)
        return VideoViewController.create(with: viewModel)
    }
}
