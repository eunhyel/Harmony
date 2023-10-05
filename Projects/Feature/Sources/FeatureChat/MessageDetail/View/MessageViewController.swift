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
//            layout.headBarView.setNoUserLayout(nil)
        
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
        messageLayout.dataSource = UITableViewDiffableDataSource<String, ChatUnit>(tableView: messageLayout.tableView, cellProvider: { [weak self] tableView, indexPath, item -> UITableViewCell? in
            guard let self = self else { return UITableViewCell() }
            
            let isContinuous: Bool = checkMemNoContinuous(item: item, with: indexPath)
            
            switch item.msgType {
            case .imageBundle:
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageImageBundleCell.reuseIdentifier, for: indexPath) as? MessageImageBundleCell
                
                item.sendType == "1" ? cell?.setOutgoingCell(isContinuous) : cell?.setIncomingCell(isContinuous)
                cell?.configUI(info: item, isContinuous: isContinuous)
                cell?.setProfile(info: viewModel.ptrMember)
                
                cell?.bind()
                
                cell?.longPress = { print("롱 프레스") }
                cell?.openMedia = { idx in print("사진 \(idx) 열기") }
                cell?.openProfile = { print("프로필 열기") }
                
                return cell
                
            case .text:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageTextCell.reuseIdentifier, for: indexPath) as? MessageTextCell

                cell?.configUI(info: item, isContinuous: isContinuous)
                
                item.sendType == "1" ? cell?.setOutgoingCell(isContinuous) : cell?.setIncomingCell(isContinuous)
                
                cell?.setProfile(info: viewModel.ptrMember)
                cell?.bind()
                if item.content != nil {
                    item.sendType == "1" ? () : cell?.setPtrTranslateMsg(item)
                }
                cell?.longPress = { print("롱 프레스") }
                
                return cell
            case .image:
                return UITableViewCell()
            case .video:
                return UITableViewCell()
            case .call:
                return UITableViewCell()
            }
        })
        
        
        messageLayout.tableView.dataSource = messageLayout.dataSource
        
    }
    
    func reloadDatas() {
        let chatList = viewModel.getChatListByDate()
        let sectionList = viewModel.getChatDate()
        
        var snap = NSDiffableDataSourceSnapshot<String, ChatUnit>()
        
        snap.appendSections(sectionList)
        
        sectionList.forEach { date in
            var items = chatList[date] ?? []
//            items = [items.first!]
            snap.appendItems(items, toSection: date)
        }
        
        messageLayout.dataSource.apply(snap, animatingDifferences: false)
    }
    
    func checkMemNoContinuous(item: ChatUnit, with idxPath: IndexPath) -> Bool {
        
        guard idxPath.section > -1, idxPath.row > 0 else { return false }
        
        let prevIdxPath = IndexPath(row: idxPath.row - 1, section: idxPath.section)

        guard let prevItem = self.messageLayout.dataSource.itemIdentifier(for: prevIdxPath) else {
            return false
        }

        let memNoCondition = prevItem.memNo == item.memNo
        return memNoCondition
    }
    
    func checkNextContinuous(item: ChatUnit, with idxPath: IndexPath) -> Bool {
        
        guard idxPath.section > -1, idxPath.row > 0 else { return false }
        
        let rowCount = messageLayout.tableView.numberOfRows(inSection: idxPath.section)

        guard idxPath.row < rowCount - 1 else { return false }

        let nextIdxPath = IndexPath(row: idxPath.row + 1, section: idxPath.section)

        guard let nextItem = messageLayout.dataSource.itemIdentifier(for: nextIdxPath) else { return false }
        let memNoCondition = item.memNo == nextItem.memNo
        let timeCondition = item.minsDate == nextItem.minsDate

        if memNoCondition && timeCondition {
            return true
        } else {
            return false
        }
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
        return 32 + 24
    }
    
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        let section = self.viewModel.getSectionToIndex(index: indexPath.section) ?? ""
//        
//        let message = self.messageLayout.dataSource.snapshot().itemIdentifiers(inSection: section)[indexPath.row]
//        
//        switch message.msgType {
//        default:
//            return UITableView.automaticDimension
//        }
//    }
    
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
