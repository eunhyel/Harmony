//
//  MediaDIContainer.swift
//  Harmony
//
//  Created by root0 on 2023/09/14.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit

import Feature
import Shared

class MediaDIContainer {
    
    
    func makeMediaCoordinator(navigation: UINavigationController) -> MediaCoordinator {
        return MediaCoordinator(navigation: navigation, dependencies: self)
    }
    
}

extension MediaDIContainer: MediaCoordinatorDependencies {
    
}
