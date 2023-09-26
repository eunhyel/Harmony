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
    
    public enum TypeOfMsgList {
        case main
        case strangers
    }
    
    public var typeOfMsgLayout: TypeOfMsgList = .main
    
    var listLayout: MessageListLayout!
    var viewModel: MessageListViewModel!
    var disposeBag: DisposeBag!
    
//    open override func loadView() {
//        super.loadView()
//        self.view.backgroundColor = .grayF1
//    }
    
    public class func create(with viewModel: MessageListViewModel, type: TypeOfMsgList) -> MessageListViewController {
        let vc = MessageListViewController()
        let disposeBag = DisposeBag()
        let layout = MessageListLayout()
            layout.disposeBag = disposeBag
        
        vc.typeOfMsgLayout = type
        
        vc.viewModel = viewModel
        vc.listLayout = layout
        vc.disposeBag = disposeBag
        return vc
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setDataSource()
        
        bind(to: viewModel)
        listLayout.viewDidLoad(view: self.view, type: typeOfMsgLayout)
        listLayout.bind(to: viewModel)
        
        viewModel.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        loadData()
    }
    
    deinit {
        log.d("deinit")
    }
    
    // output
    func bind(to viewModel: MessageListViewModel) {
        viewModel._listDidLoad
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, animate in
                owner.loadData(animate: animate)
                owner.listLayout.tableView.refreshControl?.endRefreshing()
            }
            .disposed(by: disposeBag)
    }
}
