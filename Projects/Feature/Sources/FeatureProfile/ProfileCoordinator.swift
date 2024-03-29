//
//  ProfileListCoordinator.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2022/12/19.
//  Copyright © 2022 GlobalYeoboya. All rights reserved.
//

import UIKit
import SwiftyJSON
import Shared


public protocol ProfileCoordinatorDependencies {
    
    func makeProfileListViewController(actions coordinatorActions: ProfileListActions) -> ProfileListViewController
    
    func makeVideoViewController(actions coordinatorActions: VideoViewActions) -> VideoViewController
}

public class ProfileCoordinator: NSObject {
    
    weak var navigation: UINavigationController?
    private let dependencies: ProfileCoordinatorDependencies
    
    public init(navigation: UINavigationController? = nil, dependencies: ProfileCoordinatorDependencies) {
        self.navigation = navigation
        self.dependencies = dependencies
    }
    
    public func start() {
        self.navigation?.interactivePopGestureRecognizer?.delegate = navigation
        
        let actions = ProfileListActions(openVideoView: openVideoView)
        
        let vc = dependencies.makeProfileListViewController(actions: actions)
        self.navigation?.setViewControllers([vc], animated: false)
        
        // action ProcessPushIfNeeds
    }
    
    public func openVideoView(){
        let actions = VideoViewActions()

        let vc = dependencies.makeVideoViewController(actions: actions)
        vc.modalPresentationStyle = .fullScreen
        
        self.navigation?.present(vc, animated: false)
        
    }
}
