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
    var navigationController : UINavigationController = UINavigationController.defauleNavigation()
    
    private var appDIContainer: AppDIContainer
    
    init(tabbarController: DefaultTabbarController, appDIContainer: AppDIContainer) {
        self.tabbarController = tabbarController
        self.appDIContainer   = appDIContainer
        
        super.init()
        navigationController.delegate = self
    }

    
    func start(){
        let vc = LoginViewController.create(with: DefaultLoginViewModel())
        navigationController.setViewControllers([vc], animated: false)
        self.tabbarController.setViewControllers([navigationController], animated: false)
    }
    
    
    func close(){
    }
    
    // 앱으로 돌아왔을 때
    func sceneDidBecomeActive() {
        self.navigationController.viewControllers.forEach{ $0.sceneDidBecomeActive() }
        self.tabbarController.viewControllers?.forEach{ $0.sceneDidBecomeActive() }
        self.tabbarController.sceneDidBecomeActive()
    }
    // 다른앱으로 이동 했을때
    func sceneWillResignActive () {
        self.navigationController.viewControllers.forEach{ $0.sceneWillResignActive() }
        self.tabbarController.viewControllers?.forEach{ $0.sceneWillResignActive() }
        self.tabbarController.sceneWillResignActive()
        
    }
    // 포어그라운드로 들어왔을 때
    func sceneWillEnterForeground() {
        self.navigationController.viewControllers.forEach{ $0.sceneWillEnterForeground() }
        self.tabbarController.viewControllers?.forEach{ $0.sceneWillEnterForeground() }
        self.tabbarController.sceneWillEnterForeground()
    }
    // 백그라운드로 들어갔을 때
    func sceneDidEnterBackground() {
        self.navigationController.viewControllers.forEach{ $0.sceneDidEnterBackground() }
        self.tabbarController.viewControllers?.forEach{ $0.sceneDidEnterBackground() }
        self.tabbarController.sceneDidEnterBackground()
    }
    
    deinit {
    }
}

extension AppFlowCoordinator: UINavigationControllerDelegate {
}

// MARK: 푸시
extension AppFlowCoordinator {
    
    func didReceivePush(name: String, data: String) {
        guard let vc = navigationController.viewControllers.first as? LoginViewController else {
            Toast.defaultToast("controller not setting", controller: navigationController)
            UserDefaultsManager.receivedPushData = data
            return
        }
        
        vc.webPushSend(name: name, data: data)
    }
}
