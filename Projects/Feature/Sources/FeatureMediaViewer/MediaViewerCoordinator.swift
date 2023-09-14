//
//  MediaViewerCoordinator.swift
//  Feature
//
//  Created by root0 on 2023/09/14.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit

public protocol MediaViewerCoordinatorDependencies {
    func makeMediaViewerViewController(actions coordinatorActions: Any) -> MediaViewerViewController
}

public class MediaViewerCoordinator {
    
    weak var navigation: UINavigationController?
    private let dependencies: MediaViewerCoordinatorDependencies
    
    public init(navigation: UINavigationController, dependencies: MediaViewerCoordinatorDependencies) {
        self.navigation = navigation
        self.dependencies = dependencies
    }
}

