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
        
        viewModel.viewDidLoad()
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
        essentialBind(to: viewModel)
    }
    
    func setDelegate() {
        messageLayout.tableView.delegate = self
        
        self.messageLayout.setCollectionViewLayout()
    }
    
    func setDataSource() {
        
        messageLayout.dataSource = UITableViewDiffableDataSource(tableView: messageLayout.tableView, cellProvider: { [weak self] tableView, indexPath, item in
            guard let self = self else { return UITableViewCell() }
            
            switch item.msgType {
            
            default:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageTextCell.reuseIdentifier, for: indexPath) as? MessageTextCell
                
                cell?.configUI(info: item, isSameWithPrev: false)
                item.sendType == "1" ? cell?.setOutgoingCell() : cell?.setIncomingCell()
                
                cell?.setProfile(info: viewModel.ptrMember)
                cell?.bind()
                
                cell?.longPress = {}
                
                
                return cell
            }
        })
        
        messageLayout.tableView.dataSource = messageLayout.dataSource
        
    }
    
    func reloadDatas() {
        let chatList = viewModel.getChatListByDate()
        let sectionList = viewModel.getChatDate()
        
        var snap = NSDiffableDataSourceSnapshot<String, MockList>()
        
        snap.appendSections(sectionList)
        
        sectionList.forEach { date in
            var items = chatList[date] ?? []
//            items = [items.first!]
            snap.appendItems(items, toSection: date)
        }
        
        messageLayout.dataSource.apply(snap, animatingDifferences: false)
    }
}

extension MessageViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let divisionView = MessageDateDivisionView(frame: .zero)
        
        let date = self.viewModel.getSectionToIndex(index: section)
        
        divisionView.configUI(date)
        
        return divisionView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = self.viewModel.getSectionToIndex(index: indexPath.section) ?? ""
        
        let message = self.messageLayout.dataSource.snapshot().itemIdentifiers(inSection: section)[indexPath.row]
        
        switch message.msgType {
        default:
            return UITableView.automaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.messageLayout.userInputView.inputTextView.endEditing(true)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableviewDidScroll(scrollView)
    }
    
    func tableviewDidScroll(_ scrollView: UIScrollView) {
        
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
