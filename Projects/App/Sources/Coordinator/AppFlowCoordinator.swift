//
//  AppCoordinator.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2022/12/14.
//  Copyright © 2022 GlobalYeoboya. All rights reserved.
//
import Foundation
import Shared
import UIKit
import Feature
import SwiftyJSON
import Core

open class AppFlowCoordinator: NSObject {
    
    
    var tabbarController: DefaultTabbarController
//    var navigationController : UINavigationController = UINavigationController.defaultNavigation()
    var profileNavigation: UINavigationController = .defaultNavigation()
    var videoNavigation: UINavigationController = .defaultNavigation()
    var messageNavigation: UINavigationController = .defaultNavigation()
    var myPageNavigation: UINavigationController = .defaultNavigation()
    
    private var appDIContainer: AppDIContainer
    
    init(tabbarController: DefaultTabbarController, appDIContainer: AppDIContainer) {
        self.tabbarController = tabbarController
        self.appDIContainer   = appDIContainer
        
        super.init()
        //navigationController.delegate = self
    }

    
    func start(){
        let profileCoordinator = appDIContainer.makeProfileListCoordinator(navigation: profileNavigation)
        let videoCoordinator = appDIContainer.makeVideoChatCoordinator(navigation: videoNavigation)
        let messageCoordinator = appDIContainer.makeMessageCoordinator(navigation: messageNavigation)
        let mypageCoordinator = appDIContainer.makeMypageCoordinator(navigation: myPageNavigation)
        
        profileNavigation.tabBarItem = UITabBarItem(title: nil,
                                                    image: UIImage(systemName: "paperplane"),
                                                    selectedImage: UIImage(systemName: "paperplane.fill"))
        videoNavigation.tabBarItem = UITabBarItem(title: nil,
                                                  image: UIImage(systemName: "video"),
                                                  selectedImage: UIImage(systemName: "video.fill"))
        messageNavigation.tabBarItem = UITabBarItem(title: nil,
                                                    image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        myPageNavigation.tabBarItem = UITabBarItem(title: nil,
                                                   image: UIImage(systemName: "person"),
                                                   selectedImage: UIImage(systemName: "person.fill"))
        
        
        self.tabbarController.setViewControllers([profileNavigation, videoNavigation, messageNavigation, myPageNavigation], animated: false)
        
        self.tabbarController.selectedIndex = 0
        
        profileCoordinator.start()
        videoCoordinator.start()
        messageCoordinator.start()
        mypageCoordinator.start(mypageType: .mypage)
    }
    
    func moveToLogin() {
        let actions = LoginViewModelActions(loginDidSuccess: start)
        let loginVC = appDIContainer.makeLoginViewController(actions: actions)
        self.tabbarController.setViewControllers([loginVC], animated: true)
    }
    
//    func moveToProfileList() {
//        let profileCoordinator = appDIContainer.makeProfileListCoordinator(navigation: navigationController)
//
//        self.tabbarController.setViewControllers([navigationController], animated: false)
//
//        profileCoordinator.start()
//    }
    
    func close(){
    }
    
    // 앱으로 돌아왔을 때
    func sceneDidBecomeActive() {
//        self.navigationController.viewControllers.forEach{ $0.sceneDidBecomeActive() }
        (self.tabbarController.selectedViewController as? UINavigationController)?.viewControllers.forEach { $0.sceneDidBecomeActive() }
        self.tabbarController.viewControllers?.forEach{ $0.sceneDidBecomeActive() }
        self.tabbarController.sceneDidBecomeActive()
    }
    // 다른앱으로 이동 했을때
    func sceneWillResignActive () {
//        self.navigationController.viewControllers.forEach{ $0.sceneWillResignActive() }
        self.tabbarController.viewControllers?.forEach{ $0.sceneWillResignActive() }
        self.tabbarController.sceneWillResignActive()
        
    }
    // 포어그라운드로 들어왔을 때
    func sceneWillEnterForeground() {
//        self.navigationController.viewControllers.forEach{ $0.sceneWillEnterForeground() }
        self.tabbarController.viewControllers?.forEach{ $0.sceneWillEnterForeground() }
        self.tabbarController.sceneWillEnterForeground()
    }
    // 백그라운드로 들어갔을 때
    func sceneDidEnterBackground() {
//        self.navigationController.viewControllers.forEach{ $0.sceneDidEnterBackground() }
        self.tabbarController.viewControllers?.forEach{ $0.sceneDidEnterBackground() }
        self.tabbarController.sceneDidEnterBackground()
    }
    
    deinit {
    }
}

// MARK: 푸시
extension AppFlowCoordinator {
    
    func didReceivePush(name: String, data: String) {
//        guard let vc = navigationController.viewControllers.first as? LoginViewController else {
//            Toast.defaultToast("controller not setting", controller: navigationController)
//            UserDefaultsManager.receivedPushData = data
//            return
//        }
//        vc.webPushSend(name: name, data: data)
        let nav = (tabbarController.selectedViewController as? UINavigationController)
        guard let nav, let vc = nav.viewControllers.first as? LoginViewController else {
            Toast.defaultToast("controller not Setting", controller: nav)
            UserDefaultsManager.receivedPushData = data
            return
        }
        vc.webPushSend(name: name, data: data)
    }
}
