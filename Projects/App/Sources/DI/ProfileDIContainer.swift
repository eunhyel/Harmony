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
    
    
    func makeProfileListViewController(actions coordinatorActions: ProfileListActions) -> ProfileListViewController {
        
        let makeProfileListViewModel = makeProfileListViewModel(actions: coordinatorActions)
        return ProfileListViewController.create(with: makeProfileListViewModel)
    }
    
    func makeProfileListViewModel(actions coordinatorActions: ProfileListActions) -> ProfileListViewModel {
        
        let profileViewModel = DefaultProfileListViewModel()
        return profileViewModel
    }
}
