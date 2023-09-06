//
//  MessageViewController+Bind.swift
//  Feature
//
//  Created by root0 on 2023/06/09.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import Shared


extension MessageViewController {
    
    func essentialBind(to viewModel: MessageViewModel) {
        
        viewModel._didListLoad
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe { (owner, state) in
//                owner.messageLayout set profile
                owner.reloadDatas()
                
                switch state {
                case .first, .bottom:
//                    owner.scrolltobottom
                    break
                case .last:
//                    owner.scrollToLastMessage
                    break
                case .none:
                    break
                }
                
//                owner.messageLayout.collectionView.supple
            }
            .disposed(by: disposeBag)
        
    }
    
}
