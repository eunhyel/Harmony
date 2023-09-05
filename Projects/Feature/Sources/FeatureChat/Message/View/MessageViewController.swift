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
        navigationController?.delegate = self
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
        
        self.messageLayout.setCollectionViewLayout()
    }
    
    func setDataSource() {
        messageLayout.dataSource = UICollectionViewDiffableDataSource(collectionView: self.messageLayout.collectionView, cellProvider: { [weak self] collectionView, indexPath, chatMessage in
            guard let self = self else { return UICollectionViewCell() }
            
            switch chatMessage.msgType {
            case .text, .image, .video, .call:
                fallthrough
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageTextCell.identifier, for: indexPath) as? MessageTextCell
                
                cell?.configUI(info: chatMessage)
                
                cell?.bind()
                
                cell?.longPress = {}
                cell?.resend = {}
                cell?.openProfile = {}
                
                return cell
            }
            
        })
        
        self.messageLayout.collectionView.dataSource = self.messageLayout.dataSource
    }
    
    func reloadDatas() {
        let chatList = viewModel.getChatListByDate()
        let sectionList = viewModel.getChatDate()
        
        var snap = NSDiffableDataSourceSnapshot<String, ChatMessage>()
        sectionList.forEach { date in
            snap.appendItems(chatList[date] ?? [], toSection: date)
        }
        
        messageLayout.dataSource.apply(snap, animatingDifferences: false)
    }
}

extension MessageViewController: UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        log.d("\(#function)")
    }
    
    
}

extension MessageViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let coordinator = navigationController.topViewController?.transitionCoordinator {
            coordinator.notifyWhenInteractionChanges { context in
                log.s("IS CANCELLED \(context.isCancelled)")
            }
        }
    }
}
