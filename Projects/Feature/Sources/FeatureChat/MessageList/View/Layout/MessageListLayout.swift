//
//  MessageListLayout.swift
//  Feature
//
//  Created by root0 on 2023/06/02.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import Lottie

import Core
import Shared

class MessageListLayout: NSObject {
    
    enum TypeOfMsgList {
        case main
        case strangers
    }
    var typeOfMsgLayout: TypeOfMsgList = .main
    
    var layout = UIView().then {
        $0.backgroundColor = .white
    }
    
    var topMenuBar: TopMenuBar = TopMenuBar(status: .message)
    var refreshImage = LottieAnimationView(name: "refresh").then {
        $0.contentMode = .scaleAspectFit
        $0.loopMode    = .loop
        $0.alpha = 0
    }
    
    lazy var refreshControl : UIRefreshControl = UIRefreshControl().then{
        $0.addSubview(refreshImage)
        $0.tintColor = .clear
        $0.backgroundColor = .blue
        $0.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        refreshImage.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: 32, height: 32))
            $0.top.equalToSuperview().offset(0)
            $0.centerX.equalToSuperview()
        }
    }
    var tableView: UITableView = .init(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.separatorStyle = .singleLine
        $0.separatorColor = UIColor(rgbF: 241)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        $0.contentInsetAdjustmentBehavior = .never
        $0.sectionFooterHeight = .leastNormalMagnitude
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.rowHeight = UITableView.automaticDimension
        $0.bounces = true
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0
        }
        
        $0.register(MessageListCell.self, forCellReuseIdentifier: MessageListCell.reuseIdentifier)
    }
    var dataSource: UITableViewDiffableDataSource<TypeOfSender, BoxList>! // <Section, LastMessageWithMember>
    
    
    
    
    weak var disposeBag: DisposeBag?
    
    init(_ type: TypeOfMsgList = .main) {
        self.typeOfMsgLayout = type
        super.init()
    }
    
    func viewDidLoad(view: UIView) {
        
        setLayout(superView: view)
        setConstraint()
        setProperty()
    }
    
    func setLayout(superView: UIView) {
        superView.addSubview(layout)
        
        [tableView, topMenuBar]
            .forEach(layout.addSubview(_:))
        
        
    }
    
    
    func setConstraint() {
        layout.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        topMenuBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topMenuBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(layout.safeAreaLayoutGuide)
        }
    }
    
    func setProperty() {
        // add tableview refresh
        tableView.refreshControl = refreshControl
    }
    
    /// Binding Subviews <-> ViewModel
    func bind(to viewModel: MessageListViewModel) {
        
        guard let dBag = disposeBag else { return }
        
        refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .bind { (owner, _) in
                
                viewModel.loadMessageBoxList(isPaging: false)
                
                
                
                
                
            }
            .disposed(by: dBag)
    }
    
    /// Binding TapGesture <-> ViewModel
    func setInput(to viewModel: MessageListViewModel) {
        
    }
    
    
    func removeViews() {
        layout = .init()
        topMenuBar = .init(frame: .zero)
        
        
    }
    
    deinit {
        log.d("MessageListLayout Deinit")
    }
    
    @objc func refresh() {
        self.refreshControl.beginRefreshing()

        //데이터 로드 완료 되면
        getMainList(page: 1) { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func getMainList(page: Int, completion: (() -> Void)? = nil ) {
        //API or socket
        
        
        if let completion = completion {
            completion()
        }
    }
}
