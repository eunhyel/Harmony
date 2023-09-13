//
//  MessageListViewController+Table.swift
//  Feature
//
//  Created by root0 on 2023/06/07.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

import Core
import Shared

enum TypeOfSender: Hashable {
    case system
    case chatBot
    case user//(date: String)
}


extension MessageListViewController {
    
    func setDelegate() {
        
        listLayout.tableView.delegate = self
//        listLayout.tableView.contentInset.bottom = self.tabBarController?.tabBar.frame.size.height ?? 0
    }
    
    func setDataSource() {
        listLayout.dataSource = UITableViewDiffableDataSource<TypeOfSender, BoxList>(tableView: listLayout.tableView, cellProvider: { [weak self] tableView, indexPath, item in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: MessageListCell.reuseIdentifier, for: indexPath) as? MessageListCell
            else {
                return UITableViewCell()
            }
            
//            self.viewModel._isEditing.bind { editMode in
//                cell.
//            }
//            .disposed(by: self.disposeBag)
            
            cell.configUI(model: item)
            
            return cell
        })
        
        listLayout.tableView.dataSource = listLayout.dataSource
    }
    
    public func loadData(animate: Bool = false) {
        var messageDic = viewModel.messageDic
        let sectionKeys = viewModel.sectionKeyList
        
        let data = viewModel.messageList
        
        let css = viewModel.messageList.filter { $0.memNo == 7777 }
        let teams = viewModel.messageList.filter { $0.memNo == 8888 }
        
        messageDic = messageDic.filter { $0.value != css && $0.value != teams }
//        let users = viewModel.messageList.filter { $0.memNo != 7777 && $0.memNo != 8888 }
        /// 새로운 스냅샷
        var snap = NSDiffableDataSourceSnapshot<TypeOfSender, BoxList>()
        /// 섹션 추가
        snap.appendSections([.system, .chatBot, .user])
        /// 아이템 추가
        snap.appendItems(css, toSection: .system)
        snap.appendItems(teams, toSection: .chatBot)
        
        sectionKeys.forEach { date in
            snap.appendItems(messageDic[date] ?? [], toSection: .user)
        }

        /// 반영
        listLayout.dataSource.apply(snap, animatingDifferences: animate)
    }
    
}

extension MessageListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) { [weak self] in
            guard let self = self else { return }
            Task {
                await self.viewModel.didOpenMessageView(index: indexPath)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "delete") { action, sourceView, completion in
            
            
            self.viewModel.didSwipeDelete()
            var currentSnap = self.listLayout.dataSource.snapshot()
            let userBoxs = currentSnap.itemIdentifiers(inSection: .user)
            
            let ditem = userBoxs[indexPath.row]
            currentSnap.deleteItems([ditem])
//            currentSnap.deleteItems([self.viewModel.messageList[indexPath.row]])
            self.listLayout.dataSource.apply(currentSnap)
            completion(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete])
//        let swipeConfiguration = UISwipeActionsConfiguration(actions: [])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        return swipeConfiguration
    }
}


