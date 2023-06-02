//
//  MessageListViewController.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import Then
import Shared

open class MessageListViewController: UIViewController {
    
    var dataSource: UITableViewDiffableDataSource<String, String>! // <Section, LastMessageWithMember>
    var viewModel: MessageListViewModel!
    var listLayout: MessageListLayout!
    var disposeBag: DisposeBag!
    
    public class func create(with viewModel: MessageListViewModel) -> MessageListViewController {
        let vc = MessageListViewController()
        let disposeBag = DisposeBag()
        
        vc.viewModel = viewModel
        vc.disposeBag = disposeBag
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
