//
//  GPTViewController.swift
//  Feature
//
//  Created by John Park on 2023/03/26.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift
import RxGesture


public class GPTViewController: UIViewController {
    
    let layout = ChatGPTLayout(frame: UIScreen.main.bounds).then{
        $0.backgroundColor = .black
    }
    
    public override func loadView() {
        super.loadView()
        self.view = layout
        layout.loadView()
    }
        
    
    
    public class func create(with viewModel: DefaultChatGPTViewModel) -> GPTViewController {
        let vc                = GPTViewController()
        return vc
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
extension GPTViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        
        return HalfViewController(presentedViewController: presented, presenting: presenting)
//        CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
