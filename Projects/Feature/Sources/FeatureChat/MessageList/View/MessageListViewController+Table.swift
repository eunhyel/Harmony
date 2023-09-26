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
    case stranger
    case user//(date: String)
}


extension MessageListViewController {
    
    func setDelegate() {
        
        listLayout.tableView.delegate = self
//        listLayout.tableView.contentInset.bottom = self.tabBarController?.tabBar.frame.size.height ?? 0
    }
    
    func setDataSource() {
        listLayout.dataSource = UITableViewDiffableDataSource<TypeOfSender, BoxUnit>(tableView: listLayout.tableView, cellProvider: { [weak self] tableView, indexPath, item in
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
        let messageDic = viewModel.messageDic
        let sectionKeys = viewModel.sectionKeyList
        
        _ = viewModel.messageList
        /// 새로운 스냅샷
        var snap = NSDiffableDataSourceSnapshot<TypeOfSender, BoxUnit>()
        /// 섹션 추가
        snap.appendSections([.system, .chatBot, .stranger, .user])
        /// 아이템 추가
        
        sectionKeys.forEach { date in
            let boxsByDate = messageDic[date] ?? []
            for box in boxsByDate {
                if box.memNo == 7777 {
                    snap.appendItems([box], toSection: .system)
                } else if box.memNo == 8888 {
                    snap.appendItems([box], toSection: .chatBot)
                } else if box.memNo == 9999 {
                    snap.appendItems([box], toSection: .stranger)
                } else {
                    snap.appendItems([box], toSection: .user)
                }
            }
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
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }
//            Task {
                
                if indexPath.section < 2 {
                    
                } else if indexPath.section == 2 {
                    self.viewModel.didOpenStrangersView()
                } else {
                    Task {
                        await self.viewModel.didOpenMessageView(index: indexPath)
                    }
                }
                log.d("선택한 셀 indexPath : \(indexPath)")
                
//            }
        }
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard indexPath.section == 2 else { return nil }
        
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


