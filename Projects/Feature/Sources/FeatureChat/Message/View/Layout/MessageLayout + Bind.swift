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

extension MessageLayout {
    
    func bind_userInput(to viewModel: MessageViewModel) {
        guard let dBag = disposeBag else { return }
        
        userInputView.gallery.rx
            .tap
            .withUnretained(self)
            .bind { (this, tap) in
                viewModel.didTapClose()
            }
            .disposed(by: dBag)
    }
    
}
