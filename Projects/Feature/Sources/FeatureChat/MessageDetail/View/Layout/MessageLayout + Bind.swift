//
//  MessageLayout + Bind.swift
//  Feature
//
//  Created by root0 on 2023/09/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

extension MessageLayout {
    
    func bind_userInput(to viewModel: MessageViewModel) {
        guard let dBag = disposeBag else { return }
        
        userInputView.menu.rx
            .tap
            .withUnretained(self)
            .bind { (this, tap) in
                UIView.animate(withDuration: 0.25) {
                    this.userInputView.menuContainer.isHidden.toggle()
                }
                
            }
            .disposed(by: dBag)
        
        userInputView.gallery.rx
            .tap
            .withUnretained(self)
            .bind { (owner, _) in
                viewModel.openPhoto(JSON())
            }
            .disposed(by: dBag)
    }
    
    func bind_headBar(to viewModel: MessageViewModel) {
        guard let dBag = disposeBag else { return }
        
        headBarView.bind(to: viewModel)
        
        
    }
}
