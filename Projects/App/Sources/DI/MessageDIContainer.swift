//
//  MessageDIContainer.swift
//  Harmony
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import Feature

public class MessageDIContainer {
    func makeMessageCoordinator(navigation: UINavigationController) -> MessageCoordinator {
        return MessageCoordinator(navigation: navigation, dependencies: self)
    }
}

extension MessageDIContainer: MessageCoordiantorDependencies {
    
    public func makeMessageListViewController(actions coordinatorActions: MessageListActions) -> MessageListViewController {
        let viewModel = DefaultMessageListViewModel(actions: coordinatorActions)
        
        return MessageListViewController.create(with: viewModel)
    }
}
