//
//  MediaCoordinator.swift
//  Feature
//
//  Created by root0 on 2023/09/19.
//  Copyright © 2023 Harmony. All rights reserved.
//


import UIKit

import Shared

public protocol MediaCoordinatorDependencies {
    
    func makePhotoViewController(actions coordinatorActions: Any) -> PhotoViewController?
    
}

public class MediaCoordinator {
    
    weak var navigation: UINavigationController?
    private let dependencies: MediaCoordinatorDependencies
    
    public init(navigation: UINavigationController, dependencies: MediaCoordinatorDependencies) {
        self.navigation = navigation
        self.dependencies = dependencies
    }
}
