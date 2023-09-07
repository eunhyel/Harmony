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

extension MessageListViewController {
    
    enum TypeOfList {
        case main
        case strangers
    }
    
    enum TypeOfSender {
        case system
        case chatBot
        case user
    }
    
    func setDelegate() {
        self.listLayout.listBody.tableView.delegate = self
//        listLayout.listBody.tableView.contentInset.bottom = self.tabBarController?.tabBar.frame.size.height ?? 0
    }
    
    func setDataSource() {
        dataSource = UITableViewDiffableDataSource<TypeOfSender, String>(tableView: listLayout.listBody.tableView, cellProvider: { [weak self] tableView, indexPath, item in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: MessageListCell.reuseIdentifier, for: indexPath) as? MessageListCell
            else { return UITableViewCell() }
            
            self.viewModel._isEditing.bind { editMode in
//                cell.
            }
            .disposed(by: self.disposeBag)
            
            cell.configUI(model: item)
            cell.showDummyIndexPath(indexPath: indexPath)
            
            return cell
        })
        listLayout.listBody.tableView.dataSource = dataSource
    }
    
    func loadData(animate: Bool = false) {
        let data = viewModel.messageList
        listLayout.listEmpty.isHidden = !data.isEmpty
        
        /// 새로운 스냅샷
        var snapshot = NSDiffableDataSourceSnapshot<TypeOfSender, String>()
        /// 섹션 추가
        snapshot.appendSections([.system, .chatBot, .user])
        /// 아이템 추가
        snapshot.appendItems([data[0]], toSection: .system)
        snapshot.appendItems([data[1]], toSection: .chatBot)
        snapshot.appendItems(Array(data[2..<data.count]), toSection: .user)
        /// 반영
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
}

extension MessageListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
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
            var currentSnap = self.dataSource.snapshot()
            currentSnap.deleteItems([self.viewModel.messageList[indexPath.row]])
            self.dataSource.apply(currentSnap)
            completion(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete])
        return swipeConfiguration
    }
}


