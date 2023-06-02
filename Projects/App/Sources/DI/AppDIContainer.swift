//
//  AppDIContainer.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2022/12/14.
//  Copyright © 2022 GlobalYeoboya. All rights reserved.
//

import UIKit
import Feature



public class AppDIContainer {
    
    func makeTabbarController() -> DefaultTabbarController {
        return DefaultTabbarController.create(with: makeTabbarViewModel())
    }
    
    func makeTabbarViewModel() -> TabbarViewModel {
        return DefaultTabbarViewModel()
    }
    
    // 빠른만남
    func makeProfileListCoordinator(navigation: UINavigationController) -> ProfileCoordinator {
        let profileDI = ProfileDIContainer()
        return profileDI.makeProfileListCoordinator(navigation: navigation)
    }
    
    // 영상대화
    func makeVideoChatCoordinator(navigation: UINavigationController) -> VideoCoordinator {
        let videoDI = VideoDIContainer()
        return videoDI.makeVideoCoordinator(navigation: navigation)
    }
    
    // 메세지
    func makeMessageCoordinator(navigation: UINavigationController) -> MessageCoordinator {
        let messageDI = MessageDIContainer()
        return messageDI.makeMessageCoordinator(navigation: navigation)
    }
    
    // 마이페이지
    func makeMypageCoordinator(navigation: UINavigationController) -> MypageCoordinator {
        let mypageDI = MyPageDIContainer()
        return mypageDI.makeMypageCoordinator(navigation: navigation)
    }
    
    
    // Once
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        
        let viewModel = DefaultLoginViewModel()
        
        return LoginViewController.create(with: viewModel)
    }
}
