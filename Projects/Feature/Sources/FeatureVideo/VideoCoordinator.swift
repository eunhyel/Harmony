//
//  VideoCoordinator.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import Shared

public protocol VideoCoordinatorDependencies {
    func makeVideoListViewController(actions coordinatorActions: VideoListActions, pages: Any?) -> VideoListViewController
}

public class VideoCoordinator {
    
    weak var naviagtion: UINavigationController?
    var dependencies: VideoCoordinatorDependencies
    
    public init(naviagtion: UINavigationController? = nil, dependencies: VideoCoordinatorDependencies) {
        self.naviagtion = naviagtion
        self.dependencies = dependencies
    }
    
    deinit {
        log.d("deinit")
    }
    
    public func start() {
        let actions = VideoListActions()
        let vc = dependencies.makeVideoListViewController(actions: actions, pages: nil)
        self.naviagtion?.pushViewController(vc, animated: false)
    }
}
