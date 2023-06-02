//
//  VideoDIContainer.swift
//  Harmony
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import Feature

class VideoDIContainer {
    func makeVideoCoordinator(navigation: UINavigationController) -> VideoCoordinator {
        return VideoCoordinator(naviagtion: navigation, dependencies: self)
    }
}

extension VideoDIContainer: VideoCoordinatorDependencies {
    func makeVideoListViewController(actions coordinatorActions: VideoListActions, pages: Any?) -> VideoListViewController {
        let viewModel = DefaultVideoListViewModel(actions: coordinatorActions)
        
        return VideoListViewController.create(with: viewModel, preVideoList: nil)
    }
}
