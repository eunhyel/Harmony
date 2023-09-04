//
//  MessageLayout + Keyboard.swift
//  Feature
//
//  Created by root0 on 2023/09/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

extension MessageLayout {
    
    func bind_keyboard(to: MessageViewModel) {
        guard let dBag = disposeBag else { return }
        
        let otherTap = UITapGestureRecognizer()
        collectionView.addGestureRecognizer(otherTap)
        
        
        otherTap.rx.event
            .withUnretained(self)
            .bind { (owner, tap) in
                owner.userInputView.inputTextView.endEditing(true)
            }
            .disposed(by: dBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .map { $0.userInfo! }
            .withUnretained(self)
            .bind { (owner, userInfo) in
                let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
                let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
                
                let constant = keyboardSize.height - owner.layout.safeAreaInsets.bottom
                // 1. update constraint
                owner.userInputBottomConstraint?.update(inset: constant)
                // 2 . animation layout
                UIView.animate(withDuration: duration) {
                    owner.layout.layoutIfNeeded()
                }
            }
            .disposed(by: dBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .map { $0.userInfo! }
            .withUnretained(self)
            .bind { (owner, userInfo) in
                let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
                
                owner.userInputBottomConstraint?.update(inset: 0)
                
//                UIView.animate(withDuration: duration) {
//                    owner.layout.layoutIfNeeded()
//                }
            }
            .disposed(by: dBag)
    }
    
}
