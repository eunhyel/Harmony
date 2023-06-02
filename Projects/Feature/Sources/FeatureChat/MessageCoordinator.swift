//
//  MessageCoordinator.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import Shared

public protocol MessageCoordiantorDependencies {
    func makeMessageListViewController(actions coordinatorActions: MessageListActions) -> MessageListViewController
}

public class MessageCoordinator {
    
    weak var navigation: UINavigationController?
    var dependencies: MessageCoordiantorDependencies
    
    public init(navigation: UINavigationController? = nil, dependencies: MessageCoordiantorDependencies) {
        self.navigation = navigation
        self.navigation?.view.backgroundColor = .blue
        self.dependencies = dependencies
    }
    
    deinit {
        log.d("deinit")
    }
    
    public func start() {
        
        let actions = MessageListActions()
        
        let vc = dependencies.makeMessageListViewController(actions: actions)
        self.navigation?.pushViewController(vc, animated: true)
    }
    
}

