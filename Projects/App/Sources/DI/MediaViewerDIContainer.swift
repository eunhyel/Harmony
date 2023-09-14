//
//  MediaViewerDIContainer.swift
//  Harmony
//
//  Created by root0 on 2023/09/14.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit

import Feature

class MediaViewerDIContainer {
    
    func makeMediaViewerCoordinator(navigation: UINavigationController) -> MediaViewerCoordinator {
        return MediaViewerCoordinator(navigation: navigation, dependencies: self)
    }
}

extension MediaViewerDIContainer: MediaViewerCoordinatorDependencies {
    func makeMediaViewerViewController(actions coordinatorActions: Any) -> Feature.MediaViewerViewController {
        
        
        
        return MediaViewerViewController.create(viewModel: ())
    }
    
    
}
