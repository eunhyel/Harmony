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
    
    open override func loadView() {
        super.loadView()
        self.view.backgroundColor = .grayF1
    }
    
    public class func create(with viewModel: MessageListViewModel) -> MessageListViewController {
        let vc = MessageListViewController()
        let disposeBag = DisposeBag()
        let layout = MessageListLayout()
        layout.disposeBag = disposeBag
        
        vc.viewModel = viewModel
        vc.listLayout = layout
        vc.disposeBag = disposeBag
        return vc
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        listLayout.viewDidLoad(view: self.view, viewModel: viewModel)
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        log.d("deinit")
    }
    
    // output
    func bind(to viewModel: MessageListViewModel) {
        
    }
}
