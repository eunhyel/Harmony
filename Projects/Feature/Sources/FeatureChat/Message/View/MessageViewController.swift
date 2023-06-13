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

public class MessageViewController: UIViewController {
    
    var messageLayout: MessageLayout!
    var viewModel: MessageViewModel!
    var disposeBag: DisposeBag!
    
    public class func create(with viewModel: MessageViewModel, member ptrInfo: Member?) -> MessageViewController {
        let vc = MessageViewController()
        let disposeBag = DisposeBag()
        let layout = MessageLayout()
        layout.disposeBag = disposeBag
        
        vc.messageLayout = layout
        vc.viewModel = viewModel
        vc.disposeBag = disposeBag
//        vc.viewModel 멤버 조회
//        멤버 메시지들(페이지) 조회
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setDataSource()
        bind(to: viewModel)
        messageLayout.viewDidLoad(superView: self.view)
        messageLayout.bind(to: viewModel)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        log.d(#function)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        log.d(#function)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    public override func clearReference() {
        self.disposeBag = .init()
        viewModel = nil
    }
    
    public override func sceneDidBecomeActive() {
        log.d(#function)
        
//        self.viewModel.enterForeground()
    }
    
    public override func sceneWillEnterForeground() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.viewModel.updateChat()
        }
    }
    
    func bind(to viewModel: MessageViewModel) {
        
    }
    
    func setDelegate() {
        self.messageLayout.collectionView.delegate = self
        self.messageLayout.collectionView.prefetchDataSource = self
    }
    
    func setDataSource() {
        messageLayout.dataSource = UICollectionViewDiffableDataSource(collectionView: self.messageLayout.collectionView, cellProvider: { [weak self] collectionView, indexPath, chat in
            guard let self = self else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageTextCell.identifier, for: indexPath) as? MessageTextCell
            
            cell?.bind()
            
            
            return cell
            
        })
        
        self.messageLayout.collectionView.dataSource = self.messageLayout.dataSource
    }
}

extension MessageViewController: UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        log.d("\(#function)")
    }
    
    
}
