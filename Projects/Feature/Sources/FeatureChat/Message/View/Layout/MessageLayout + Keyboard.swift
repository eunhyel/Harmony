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
        tableView.addGestureRecognizer(otherTap)


        otherTap.rx.event
            .withUnretained(self)
            .bind { (owner, tap) in
                owner.userInputView.inputTextView.endEditing(true)
            }
            .disposed(by: dBag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let userInfo = sender.userInfo!
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: duration) {
                self.tableView.isScrollEnabled = false
                let constant = keyboardSize.height - self.layout.safeAreaInsets.bottom
                
                let cOffset = self.tableView.contentOffset
    //            tableView.setContentOffset(CGPoint(x: cOffset.x, y: cOffset.y + constant), animated: false)
                
                self.userInputView.userInputBottomConstraint?.update(inset: 6 + constant)
                
                UIView.animate(withDuration: duration) {
                    self.layout.layoutIfNeeded()
                    
                } completion: { _ in
                    self.tableView.isScrollEnabled = true
                }
                
                self.moveToVisibleLastCell(duration)
            }
            
        }
        
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let userInfo = sender.userInfo!
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: duration) { [weak self] in
                guard let self = self else { return }
                
                let constant = keyboardSize.height - self.layout.safeAreaInsets.bottom
                
                let cOffset = self.tableView.contentOffset
                
                self.userInputView.userInputBottomConstraint?.update(inset: 6)
                
                self.tableView.setContentOffset(CGPoint(x: cOffset.x, y: cOffset.y - constant), animated: false)
                
                self.layout.layoutIfNeeded()
                
            }
            
        }
        
    }
    
    
    func moveToVisibleLastCell(_ duration: Double) {
        
        if let cell = tableView.visibleCells.last, let indexPath = tableView.indexPath(for: cell) {

            let rect = tableView.rectForRow(at: indexPath)

            UIView.animate(withDuration: duration) {
                self.tableView.scrollRectToVisible(rect, animated: false)

            }
        }
        
    }
    
}
