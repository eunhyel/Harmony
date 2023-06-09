//
//  ChatSceneViewController.swift
//  Feature
//
//  Created by inforex_imac on 2023/03/29.
//  Copyright (c) 2023 All rights reserved.
//

import UIKit

public class ChatSceneViewController: UIViewController {
    
    var viewModel: ChatSceneViewModel!
    
    public class func create(with viewModel: ChatSceneViewModel) -> ChatSceneViewController {
        let vc = ChatSceneViewController()
            vc.viewModel = viewModel
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
       //viewModel.viewDidLoad()
    }
    
    func bind(to viewModel: ChatSceneViewModel) {

    }
}

extension UIViewController {
    // 뷰컨 클리어 레퍼런스 호출.. 리스타트, 로그아웃 시 호출 한다
    @objc open func clearReference(){}
    
    // 유져가 강퇴를 당했다
    @objc open func didUserBlock(){}
    
    // 앱으로 돌아왔을 때
    @objc open func sceneDidBecomeActive(){}
    // 다른앱으로 이동 했을때
    @objc open func sceneWillResignActive (){}
    
    // 포어그라운드로 들어왔을 때
    @objc open func sceneWillEnterForeground(){}
    // 백그라운드로 들어갔을 때
    @objc open func sceneDidEnterBackground(){}
}
