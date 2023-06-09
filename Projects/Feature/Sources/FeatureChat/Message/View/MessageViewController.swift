//
//  MessageViewController.swift
//  Feature
//
//  Created by root0 on 2023/06/09.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import Then
import SnapKit

import Shared
import Core

class MessageViewController: UIViewController {
    
    var messageLayout: MessageLayout!
    var viewModel: MessageViewModel!
    var disposeBag: DisposeBag!
    
    class func create(with viewModel: MessageViewModel, member ptrInfo: Member?) -> MessageViewController {
        let vc = MessageViewController()
        let disposeBag = DisposeBag()
        let layout = MessageLayout()
        layout.disposeBag = disposeBag
        
        vc.viewModel = viewModel
        vc.disposeBag = disposeBag
//        vc.viewModel 멤버 조회
//        멤버 메시지들(페이지) 조회
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        messageLayout.viewDidLoad(superView: self.view)
        messageLayout.bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        log.d(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        log.d(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func clearReference() {
        self.disposeBag = .init()
        viewModel = nil
    }
    
    override func sceneDidBecomeActive() {
        log.d(#function)
        
//        self.viewModel.enterForeground()
    }
    
    override func sceneWillEnterForeground() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.viewModel.updateChat()
        }
    }
    
    func bind(to viewModel: MessageViewModel) {
        
    }
    
    func setDelegate() {
        
    }
    
    func setDataSource() {
        
    }
}
