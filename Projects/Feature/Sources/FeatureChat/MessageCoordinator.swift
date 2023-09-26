//
//  MessageCoordinator.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SwiftyJSON

import Core
import Shared


public typealias BoxUnit = BoxList
public typealias BoxDic = [String : [BoxUnit]]
public typealias BoxSectionKeys = [String]

public typealias ChatUnit = MockChat//ChatMessage
public typealias ChatListByDate = [String : [ChatUnit]]
public typealias ChatDate = [String]

public protocol MessageCoordiantorDependencies {
    func makeMessageListViewController(actions coordinatorActions: MessageListActions) -> MessageListViewController
    
    func makeMessageViewController(actions coordinatorActions: MessageViewActions) -> MessageViewController
    
    func makeMediaCoordinator(navigation: UINavigationController) -> MediaCoordinator
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
    
    public func start() { // Open MessageListView
        
        let actions = MessageListActions(
            openMessageView: openMessageView,
            openStrangerListView: openStrangerListView,
            openProfileView: nil,
            closeList: nil
        )
        
        let vc = dependencies.makeMessageListViewController(actions: actions)
        self.navigation?.pushViewController(vc, animated: true)
    }
    
    func openMessageView() {
        
        let actions = MessageViewActions(closeMessageView: closeLast,
                                         openProfileDetail: nil,
                                         openPhotoAlbum: openPhotoAlbum(_:))
        
        DispatchQueue.main.async {
            let vc = self.dependencies.makeMessageViewController(actions: actions)
            
            if var vcs = self.navigation?.viewControllers {
                vcs.removeAll(where: { $0 is MessageViewController })
                vcs.append(vc)
                
//                self.navigation?.setViewControllers(vcs, animated: true)
                vc.modalPresentationStyle = .overFullScreen
                
                self.navigation?.present(vc, animated: true)
            } else {
                self.navigation?.pushViewController(vc, animated: true)
            }
        }
        
        
    }
    
    func openStrangerListView() {
        
        let actions = MessageListActions(
            openMessageView: openMessageView,
            openStrangerListView: nil,
            openProfileView: nil,
            closeList: closeStrangersList)
        
        DispatchQueue.main.async {
            let strangers = self.dependencies.makeMessageListViewController(actions: actions)
            
            if var vcs = self.navigation?.viewControllers {
                vcs.removeAll(where: { vc in
                    guard let listvc = vc as? MessageListViewController else { return false }
                    
                    return listvc.typeOfMsgLayout == .strangers
                })
                vcs.append(strangers)
                
                self.navigation?.setViewControllers(vcs, animated: true)
                
            } else {
                
                self.navigation?.pushViewController(strangers, animated: true)
            }
            
            let tabbar = self.navigation?.tabBarController as? DefaultTabbarController
//                tabbar?.layout.tabBar.isHidden = true
            tabbar?.viewModel._hideTabBar.accept(true)
            
        }
    }
    
    func closeStrangersList() {
        let tabBar = navigation?.tabBarController as? DefaultTabbarController
//            tabBar?.layout.tabBar.isHidden = false
        tabBar?.viewModel._hideTabBar.accept(false)
        
        navigation?.popViewController(animated: true)
    }
    
    func closeLast() {
//        self.navigation?.popViewController(animated: true)
        self.navigation?.dismiss(animated: true)
    }
    
}

extension MessageCoordinator {
    
    func openPhotoAlbum(_ requireData: JSON) {
        
        let vc = PhotoViewController.instantiate(name: "PhotoMain", SharedResources.bundle)
            vc.jsonData = requireData
            vc.modalPresentationStyle = .overFullScreen
        
        self.navigation?.present(vc, animated: true)
    }
    
    
}

