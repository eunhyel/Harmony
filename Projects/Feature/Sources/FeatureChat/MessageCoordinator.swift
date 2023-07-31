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
    
    func makeMessageViewController(actions coordinatorActions: MessageViewActions) -> MessageViewController
}

public class MessageCoordinator {
    
    weak var navigation: UINavigationController?
    var dependencies: MessageCoordiantorDependencies
    
    public init(navigation: UINavigationController? = nil, dependencies: MessageCoordiantorDependencies) {
        self.navigation = navigation
        self.dependencies = dependencies
    }
    
    deinit {
        log.d("deinit")
    }
    
    public func start() {
        
        let actions = MessageListActions(
            openMessageView: openMessageView,
            openProfileView: nil
        )
        
        let vc = dependencies.makeMessageListViewController(actions: actions)
        self.navigation?.pushViewController(vc, animated: true)
    }
    
    func openMessageView() {
        
        let actions = MessageViewActions(closeMessageView: nil,
                                         openProfileDetail: nil)
        
        DispatchQueue.main.async {
            let vc = self.dependencies.makeMessageViewController(actions: actions)
            
            if var vcs = self.navigation?.viewControllers {
                vcs.removeAll(where: { $0 is MessageViewController })
                vcs.append(vc)
                
                self.navigation?.setViewControllers(vcs, animated: true)
            } else {
                self.navigation?.pushViewController(vc, animated: true)
            }
        }
        
        
    }
    
}

extension MessageCoordinator {
    
    func closeLast() {
        self.navigation?.popViewController(animated: true)
    }
    
    
    
}

