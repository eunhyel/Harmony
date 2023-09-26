//
//  MessageDIContainer.swift
//  Harmony
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import Core
import Feature

public class MessageDIContainer {
    func makeMessageCoordinator(navigation: UINavigationController) -> MessageCoordinator {
        return MessageCoordinator(navigation: navigation, dependencies: self)
    }
}

extension MessageDIContainer: MessageCoordiantorDependencies {
    
    public func makeMessageViewController(actions coordinatorActions: Feature.MessageViewActions) -> Feature.MessageViewController {
        
        let viewModel = DefaultMessageViewModel(actions: coordinatorActions,
                                                memberUseCase: makeMemberUseCase(),
                                                messageUseCase: makeMessageUseCase())
        return MessageViewController.create(with: viewModel, member: nil)
    }
    
    
    public func makeMessageListViewController(actions coordinatorActions: MessageListActions) -> MessageListViewController {
        let viewModel = DefaultMessageListViewModel(actions: coordinatorActions,
                                                    messageUseCase: makeMessageUseCase(),
                                                    memberUseCase: makeMemberUseCase())
        
        let openType = coordinatorActions.openStrangerListView != nil ? MessageListViewController.TypeOfMsgList.main : .strangers
        
        return MessageListViewController.create(with: viewModel, type: openType)
    }
    
    
    public func makeMediaCoordinator(navigation: UINavigationController) -> Feature.MediaCoordinator {
        let mediaViewDI = makeMediaDIContainer()
        return mediaViewDI.makeMediaCoordinator(navigation: navigation)
    }
    
    func makeMediaDIContainer() -> MediaDIContainer {
        return MediaDIContainer()
    }
    
    
    // MARK: MAKE USECASES
    func makeMemberUseCase() -> FetchMemberUseCase {
        return DefaulMemberUseCase(memberRepository: DefaultMembersRepository())
    }
    
    func makeMessageUseCase() -> FetchMessageUseCase {
        return DefaultMessageUseCase(repository: DefaultMessageRepository())
    }
}
