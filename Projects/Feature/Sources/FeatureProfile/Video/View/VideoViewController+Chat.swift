//
//  VideoViewController+Chat.swift
//  Feature
//
//  Created by eunhye on 2023/09/14.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import UIKit

//Chatting
extension VideoViewController {
    func setChat(){
        videoLayout.chatTableView.delegate = self
        
        viewModel.dataSource = UITableViewDiffableDataSource<Int, ChatDataModel>(tableView: videoLayout.chatTableView, cellProvider: { chatTableView, indexPath, itemIdentifier in
            
            
            switch itemIdentifier.type {
            case .system:
                let cell = chatTableView.dequeueReusableCell(withIdentifier: SystemTextCell.identifier, for: indexPath) as? SystemTextCell
                cell?.setUI(itemIdentifier.text)
                return cell
            case .photo:
                let cell = chatTableView.dequeueReusableCell(withIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell
                cell?.setUI(itemIdentifier.text)
                return cell
            case .text:
                let cell = chatTableView.dequeueReusableCell(withIdentifier: TextCell.identifier, for: indexPath) as? TextCell
                cell?.setUI(itemIdentifier.text)
                return cell
            }
            
        })
    

        videoLayout.chatTableView.dataSource = viewModel.dataSource

        updateItem()
    }

    
    
    func updateItem() {
        var snapshot = viewModel.dataSource.snapshot()
        
        snapshot.appendSections([0])
        snapshot.appendItems([ChatDataModel(type: .system, text: "12345678hvkjbkjbjknkdagegagdagadagsgasgaadg90")], toSection: 0)
        
        viewModel.dataSource.apply(snapshot, animatingDifferences: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            snapshot.appendItems([ChatDataModel(type: .photo, text: "aa")], toSection: 0)
            self?.viewModel.dataSource.apply(snapshot, animatingDifferences: false){
                self?.scrollToBottom()
            }
        }

    }

    
    func scrollToBottom() {
        if videoLayout.chatTableView.contentSize.height < videoLayout.chatTableView.bounds.size.height {
            videoLayout.chatTableView.contentInset.top = videoLayout.chatTableView.bounds.size.height - videoLayout.chatTableView.contentSize.height
            
        } else {
            let bottomOffset = CGPoint(x: 0, y: videoLayout.chatTableView.contentSize.height - videoLayout.chatTableView.bounds.height + 10)
            videoLayout.chatTableView.setContentOffset(bottomOffset, animated: false)
            
        }
    }
}

extension VideoViewController :  UITableViewDelegate, UICollectionViewDelegateFlowLayout {
    
}



