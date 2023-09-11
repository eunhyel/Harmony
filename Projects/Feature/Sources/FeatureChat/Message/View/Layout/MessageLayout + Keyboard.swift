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


import Shared
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        collectionView.rx.contentOffset
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { (owner, offset) in
                
            }
            .disposed(by: dBag)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let userInfo = sender.userInfo!
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            collectionView.isScrollEnabled = false
            let constant = keyboardSize.height - layout.safeAreaInsets.bottom
            
            let cOffset = collectionView.contentOffset
            collectionView.setContentOffset(CGPoint(x: cOffset.x, y: cOffset.y + constant), animated: false)
            
            self.userInputView.userInputBottomConstraint?.update(inset: 6 + constant)
            
            UIView.animate(withDuration: duration) {
                self.layout.layoutIfNeeded()
                
            } completion: { _ in
                self.collectionView.isScrollEnabled = true
            }
            
//            self.moveToVisibleLastCell(duration)
        }
        
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let userInfo = sender.userInfo!
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let constant = keyboardSize.height - layout.safeAreaInsets.bottom
            
            let cOffset = collectionView.contentOffset
            collectionView.setContentOffset(CGPoint(x: 0, y: cOffset.y - constant), animated: false)
            
            userInputView.userInputBottomConstraint?.update(inset: 6)
            
            UIView.animate(withDuration: duration) {
                self.layout.layoutIfNeeded()
            }
        }
        
    }
    
    
    func moveToVisibleLastCell(_ duration: Double) {
        
        if let idxPath = collectionView.indexPathsForVisibleItems.max(),

            let attr = collectionView.layoutAttributesForItem(at: idxPath) {

            let rectFromCell = collectionView.convert(attr.frame, to: collectionView)

            log.d(rectFromCell)

            UIView.animate(withDuration: duration) {
                self.collectionView.scrollRectToVisible(rectFromCell, animated: false)
//                self.collectionView.scrollToItem(at: idxPath, at: .bottom, animated: false)
            }
        }
        
    }
    
}
