//
//  MessageListViewController.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import Shared

open class MessageListViewController: UIViewController {
    
    
    var viewModel: MessageListViewModel!
    
    public class func create(with viewModel: MessageListViewModel) -> MessageListViewController {
        let vc = MessageListViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        log.d("deinit")
    }
}
